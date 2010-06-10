/*
 * Copyright (c) 2010, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Janos Sallai, Miklos Maroti
 * Author: Thomas Schmid (port to CC2520)
 */

#include <CC2520DriverLayer.h>
#include <Tasklet.h>
#include <RadioAssert.h>
#include <TimeSyncMessageLayer.h>
#include <RadioConfig.h>

module CC2520DriverLayerP
{
    provides
    {
        interface Init as SoftwareInit @exactlyonce();

        interface RadioState;
        interface RadioSend;
        interface RadioReceive;
        interface RadioCCA;
        interface RadioPacket;

        interface PacketField<uint8_t> as PacketTransmitPower;
        interface PacketField<uint8_t> as PacketRSSI;
        interface PacketField<uint8_t> as PacketTimeSyncOffset;
        interface PacketField<uint8_t> as PacketLinkQuality;
    }

    uses
    {
        interface BusyWait<TMicro, uint16_t>;
        interface LocalTime<TRadio>;
        interface CC2520DriverConfig as Config;

        interface Resource as SpiResource;
        interface SpiByte;
        interface SpiPacket;
        interface GeneralIO as CSN;
        interface GeneralIO as VREN;
        interface GeneralIO as CCA;
        interface GeneralIO as RSTN;
        interface GeneralIO as FIFO;
        interface GeneralIO as FIFOP;
        interface GeneralIO as SFD;
        interface GpioCapture as SfdCapture;
        interface GpioInterrupt as FifopInterrupt;

        interface PacketFlag as TransmitPowerFlag;
        interface PacketFlag as RSSIFlag;
        interface PacketFlag as TimeSyncFlag;

        interface PacketTimeStamp<TRadio, uint32_t>;

        interface Tasklet;
        interface RadioAlarm;

#ifdef RADIO_DEBUG
        interface DiagMsg;
#endif
        interface Leds;
    }
}

implementation
{
    cc2520_header_t* getHeader(message_t* msg)
    {
        return ((void*)msg) + call Config.headerLength(msg);
    }

    /*
     * Return a pointer to the data portion of the message.
     */
    void* getPayload(message_t* msg)
    {
        return ((void*)msg)  + call RadioPacket.headerLength(msg);
    }

    cc2520_metadata_t* getMeta(message_t* msg)
    {
        return ((void*)msg) + sizeof(message_t) - call RadioPacket.metadataLength(msg);
    }

/*----------------- STATE -----------------*/

    enum
    {
        STATE_VR_ON = 0,
        STATE_PD = 1,
        STATE_PD_2_IDLE = 2,
        STATE_IDLE = 3,
        STATE_IDLE_2_RX_ON = 4,
        STATE_RX_ON = 5,
        STATE_BUSY_TX_2_RX_ON = 6,
        STATE_IDLE_2_TX_ON = 7,
        STATE_TX_ON = 8,
        STATE_RX_DOWNLOAD = 9,
    };
    tasklet_norace uint8_t state = STATE_VR_ON;

    enum
    {
        CMD_NONE = 0,           // the state machine has stopped
        CMD_TURNOFF = 1,        // goto SLEEP state
        CMD_STANDBY = 2,        // goto TRX_OFF state
        CMD_TURNON = 3,         // goto RX_ON state
        CMD_TRANSMIT = 4,       // currently transmitting a message
        CMD_RECEIVE = 5,        // currently receiving a message
        CMD_CCA = 6,            // performing clear chanel assesment
        CMD_CHANNEL = 7,        // changing the channel
        CMD_SIGNAL_DONE = 8,        // signal the end of the state transition
        CMD_DOWNLOAD = 9,       // download the received message
    };
    tasklet_norace uint8_t cmd = CMD_NONE;

    norace bool radioIrq = 0;

    tasklet_norace uint8_t txPower;
    tasklet_norace uint8_t channel;

    tasklet_norace message_t* rxMsg;
#ifdef RADIO_DEBUG_MESSAGES
    tasklet_norace message_t* txMsg;
#endif
    message_t rxMsgBuffer;

    uint16_t capturedTime;  // the current time when the last interrupt has occured

    tasklet_norace uint8_t rssiClear;
    tasklet_norace uint8_t rssiBusy;


    enum
    { // FIXME: need to check these for CC2520
        TX_SFD_DELAY = (uint16_t)(0 * RADIO_ALARM_MICROSEC),
        RX_SFD_DELAY = (uint16_t)(0 * RADIO_ALARM_MICROSEC),
    };


    inline cc2520_status_t getStatus();
    tasklet_async event void RadioAlarm.fired()
    {

        if( state == STATE_PD_2_IDLE ) {
            state = STATE_IDLE;
            if( cmd == CMD_STANDBY )
                cmd = CMD_SIGNAL_DONE;
        }
        else if( state == STATE_IDLE_2_RX_ON ) {
            state = STATE_RX_ON;
            // in receive mode, enable SFD capture
            call SfdCapture.captureRisingEdge();

            cmd = CMD_SIGNAL_DONE;
        }
        else
            ASSERT(FALSE);

        // make sure the rest of the command processing is called
        call Tasklet.schedule();
    }

/*----------------- REGISTER -----------------*/

    inline cc2520_status_t writeRegister(uint8_t reg, uint8_t value)
    {
        cc2520_status_t status;
        uint8_t v;

        ASSERT( call SpiResource.isOwner() );

        call CSN.set();
        call CSN.clr();

        if( reg <= CC2520_FREG_MASK)
        {
            // we can use 1 byte less to write this register using the
            // register write command

            ASSERT( reg == (reg & CC2520_FREG_MASK) );


            status.value = call SpiByte.write(CC2520_CMD_REGISTER_WRITE | reg);

        }
        else
        {
            // we have to use the memory write command as the register is in
            // SREG

            ASSERT( reg == (reg & CC2520_SREG_MASK) );

            // the register has to be below the 0x100 memory address. Thus, we
            // don't have to add anything to the MEMORY_WRITE command.
            status.value = call SpiByte.write(CC2520_CMD_MEMORY_WRITE);
            status.value = call SpiByte.write(reg);

        }
        // v is the value previously in the register
        v = call SpiByte.write(value);

        call CSN.set();

        return status;

    }

    /*
     * Strobes changed a lot between CC2420 and CC2520. They are now just an
     * other command, without any parameters.
     */
    inline cc2520_status_t strobe(uint8_t reg)
    {
        cc2520_status_t status;

        ASSERT( call SpiResource.isOwner() );

        call CSN.set();
        call CSN.clr();

        status.value = call SpiByte.write(reg);

        call CSN.set();
        return status;

    }

    inline cc2520_status_t getStatus() {
        return strobe(CC2520_CMD_SNOP);
    }

    inline uint8_t readRegister(uint8_t reg)
    {
        uint8_t value = 0;

        ASSERT( call SpiResource.isOwner() );

        call CSN.set();
        call CSN.clr();

        if( reg <= CC2520_FREG_MASK )
        {
            ASSERT( reg == (reg & CC2520_FREG_MASK) );


            call SpiByte.write(CC2520_CMD_REGISTER_READ | reg);

        }
        else
        {
            ASSERT( reg == (reg & CC2520_SREG_MASK) );

            call SpiByte.write(CC2520_CMD_MEMORY_WRITE);
            call SpiByte.write(reg);
        }

        value = call SpiByte.write(0);
        call CSN.set();

        return value;
    }

    inline cc2520_status_t writeTxFifo(uint8_t* data, uint8_t length)
    {
        cc2520_status_t status;
        uint8_t idx;

        ASSERT( call SpiResource.isOwner() );

        call CSN.set();
        call CSN.clr();

        status.value = call SpiByte.write(CC2520_CMD_TXBUF);
        // FIXME: replace this at some point with a SPIPacket call.
        for(idx = 0; idx<length; idx++)
            call SpiByte.write(data[idx]);

        call CSN.set();

        return status;

    }


    inline uint8_t waitForRxFifoNoTimeout() {
        // wait for fifo to go high
        while(call FIFO.get() == 0);

        return call FIFO.get();
    }

    inline uint8_t waitForRxFifo() {
        // wait for fifo to go high or timeout
        // timeout is now + 2 byte time (4 symbol time)
        uint16_t timeout = call RadioAlarm.getNow() + 4 * CC2520_SYMBOL_TIME;

        while(call FIFO.get() == 0 && (timeout - call RadioAlarm.getNow() < 0x7FFF));
        return call FIFO.get();
    }

    inline cc2520_status_t readLengthFromRxFifo(uint8_t* lengthPtr)
    {
        cc2520_status_t status;

        ASSERT( call SpiResource.isOwner() );
        ASSERT( call CSN.get() == 1 );

        // FIXME: ???? why do we do this ????
        call CSN.set();
        call CSN.clr();
        call CSN.set();
        call CSN.clr();
        call CSN.set();
        call CSN.clr();

        status.value = call SpiByte.write(CC2520_CMD_RXBUF);
        waitForRxFifoNoTimeout();
        *lengthPtr = call SpiByte.write(0);
        return status;
    }

    inline void readPayloadFromRxFifo(uint8_t* data, uint8_t length)
    {
        uint8_t idx;

        // readLengthFromRxFifo was called before, so CSN is cleared and spi is ours
        ASSERT( call CSN.get() == 0 );

        for(idx = 0; idx<length; idx++) {
            waitForRxFifo();
            ASSERT(call FIFO.get());
            data[idx] = call SpiByte.write(0);
        }
    }

    inline void readRssiFromRxFifo(uint8_t* rssiPtr)
    {
        // FIXME: make sure that RSSI is added to the frame in the
        // configuration! See 20.3.4 in CC2520 Manual (Dec. 2007)

        // readLengthFromRxFifo was called before, so CSN is cleared and spi is ours

        waitForRxFifo();
        ASSERT(call FIFO.get());
        *rssiPtr = call SpiByte.write(0);
    }

    inline void readCrcOkAndLqiFromRxFifo(uint8_t* crcOkAndLqiPtr)
    {
        // readLengthFromRxFifo was called before, so CSN is cleared and spi is ours
        ASSERT( call CSN.get() == 0 );

        *crcOkAndLqiPtr = call SpiByte.write(0);

        // end RxFifo read operation
        call CSN.set();
    }

    inline void flushRxFifo() {
        // set it to stop possible pending fifo transfer

        {
            cc2520_status_t status = strobe(CC2520_CMD_SFLUSHRX);
#ifdef RADIO_DEBUG_MESSAGES
            if( call DiagMsg.record() )
            {
                call DiagMsg.str("b_flush");
                call DiagMsg.uint8(status.value);
                call DiagMsg.send();
            }
#endif
        }
        // FIXME: Why so many? Bug in CC2420?
        /*
//      strobe(CC2420X_SRFOFF);
        strobe(CC2420X_SFLUSHRX);
        strobe(CC2420X_SFLUSHRX);
        strobe(CC2420X_SFLUSHRX);
        {
            cc2420X_status_t status = strobe(CC2420X_SFLUSHRX);
#ifdef RADIO_DEBUG_MESSAGES
            if( call DiagMsg.record() )
            {
                call DiagMsg.str("a_flush");
                call DiagMsg.uint16(status.value);
                call DiagMsg.send();
            }
#endif
*/
        //strobe(CC2520_CMD_SRXON);


    }

/*----------------- INIT -----------------*/

    command error_t SoftwareInit.init()
    {
        // set pin directions
        call CSN.makeOutput();
        call VREN.makeOutput();
        call RSTN.makeOutput();
        call CCA.makeInput();
        call SFD.makeInput();
        call FIFO.makeInput();
        call FIFOP.makeInput();

        call FifopInterrupt.disable();
        call SfdCapture.disable();

        // CSN is active low
        call CSN.set();

        // start up voltage regulator
        call VREN.clr();
        call VREN.set();
        // do a reset
        call RSTN.clr();
        // hold line low for Tdres
        call BusyWait.wait( 200 ); // typical .1ms VR startup time

        call RSTN.set();
        // wait another .2ms for xosc to stabilize
        call BusyWait.wait( 200 );


        rxMsg = &rxMsgBuffer;

        state = STATE_VR_ON;

        // request SPI, rest of the initialization will be done from
        // the granted event
        return call SpiResource.request();
    }

    inline void resetRadio() {
        // now register access is enabled: set up defaults
        cc2520_fifopctrl_t fifopctrl;
        cc2520_frmfilt1_t frmfilt1;
        cc2520_srcmatch_t srcmatch;

        // do a reset
        call RSTN.clr();
        call BusyWait.wait( 200 ); //
        call RSTN.set();

        // update default values of registers
        // given from SWRS068, December 2007, Section 28.1
        writeRegister(CC2520_TXPOWER, cc2520_txpower_default.value);
        writeRegister(CC2520_CCACTRL0, cc2520_ccactrl0_default.value);
        writeRegister(CC2520_MDMCTRL0, cc2520_mdmctrl0_default.value);
        writeRegister(CC2520_MDMCTRL1, cc2520_mdmctrl1_default.value);
        writeRegister(CC2520_RXCTRL, cc2520_rxctrl_default.value);
        writeRegister(CC2520_FSCTRL, cc2520_fsctrl_default.value);
        writeRegister(CC2520_FSCAL1, cc2520_fscal1_default.value);
        writeRegister(CC2520_AGCCTRL1, cc2520_agcctrl1_default.value);
        writeRegister(CC2520_ADCTEST0, cc2520_adctest0_default.value);
        writeRegister(CC2520_ADCTEST1, cc2520_adctest1_default.value);
        writeRegister(CC2520_ADCTEST2, cc2520_adctest2_default.value);

        // setup fifop threshold
        fifopctrl.f.fifop_thr = 127;
        writeRegister(CC2520_FIFOPCTRL, fifopctrl.value);

        // accept reserved frames
        frmfilt1 = cc2520_frmfilt1_default;
        frmfilt1.f.accept_ft_4to7_reserved = 1;
        writeRegister(CC2520_FRMFILT1, frmfilt1.value);

        // disable src address decoding
        srcmatch = cc2520_srcmatch_default;
        srcmatch.f.src_match_en = 0;
        writeRegister(CC2520_SRCMATCH, srcmatch.value);

        // enable auto crc and append rssi to frame
        // this is done by default.
    }

    void initRadio()
    {
        resetRadio();

        txPower = CC2520_DEF_RFPOWER & CC2520_TX_PWR_MASK;
        channel = CC2520_DEF_CHANNEL & CC2520_CHANNEL_MASK;

        state = STATE_PD;
    }

/*----------------- SPI -----------------*/

    event void SpiResource.granted()
    {
        call CSN.makeOutput();
        call CSN.set();

        if( state == STATE_VR_ON )
        {
            initRadio();
            call SpiResource.release();
        }
        else
            call Tasklet.schedule();
    }

    bool isSpiAcquired()
    {
        if( call SpiResource.isOwner() )
            return TRUE;

        if( call SpiResource.immediateRequest() == SUCCESS )
        {
            call CSN.makeOutput();
            call CSN.set();

            return TRUE;
        }

        call SpiResource.request();
        return FALSE;
    }

    async event void SpiPacket.sendDone(uint8_t* txBuf, uint8_t* rxBuf, uint16_t len, error_t error) {};

/*----------------- CHANNEL -----------------*/

    tasklet_async command uint8_t RadioState.getChannel()
    {
        return channel;
    }

    tasklet_async command error_t RadioState.setChannel(uint8_t c)
    {
        c &= CC2520_CHANNEL_MASK;

        if( cmd != CMD_NONE )
            return EBUSY;
        else if( channel == c )
            return EALREADY;

        channel = c;
        cmd = CMD_CHANNEL;
        call Tasklet.schedule();

        return SUCCESS;
    }

    inline void setChannel()
    {
        cc2520_freqctrl_t freqctrl;
        // set up freq
        freqctrl = cc2520_freqctrl_default;
        freqctrl.f.freq = 11 + 5 * (channel - 11);
#ifdef RADIO_DEBUG_MESSAGES
        if( call DiagMsg.record() )
        {
            call DiagMsg.str("freqctrl");
            call DiagMsg.uint8(freqctrl.value);
            call DiagMsg.send();
        }
#endif

        writeRegister(CC2520_FREQCTRL, freqctrl.value);
    }

    inline void changeChannel()
    {
        ASSERT( cmd == CMD_CHANNEL );
        ASSERT( state == STATE_PD || state == STATE_IDLE || ( state == STATE_RX_ON && call RadioAlarm.isFree()));

        if( isSpiAcquired() )
        {
            setChannel();

            if( state == STATE_RX_ON ) {
                call RadioAlarm.wait(IDLE_2_RX_ON_TIME); // 12 symbol periods
                state = STATE_IDLE_2_RX_ON;
            }
            else
                cmd = CMD_SIGNAL_DONE;
        }
    }

/*----------------- TURN ON/OFF -----------------*/

    inline void changeState()
    {

        if( (cmd == CMD_STANDBY || cmd == CMD_TURNON)
            && state == STATE_PD  && isSpiAcquired() && call RadioAlarm.isFree() )
        {

            // start oscillator
            strobe(CC2520_CMD_SXOSCON);

            call RadioAlarm.wait(PD_2_IDLE_TIME); // .86ms OSC startup time
            state = STATE_PD_2_IDLE;
        }
        else if( cmd == CMD_TURNON && state == STATE_IDLE && isSpiAcquired() && call RadioAlarm.isFree())
        {
            // setChannel was ignored in SLEEP because the SPI was not working, so do it here
            setChannel();

            // start receiving
            strobe(CC2520_CMD_SRXON);
            call RadioAlarm.wait(IDLE_2_RX_ON_TIME); // 12 symbol periods
            state = STATE_IDLE_2_RX_ON;
        }
        else if( (cmd == CMD_TURNOFF || cmd == CMD_STANDBY)
            && state == STATE_RX_ON && isSpiAcquired() )
        {
            // stop receiving
            strobe(CC2520_CMD_SRFOFF);

            state = STATE_IDLE;
        }

        if( cmd == CMD_TURNOFF && state == STATE_IDLE  && isSpiAcquired() )
        {
            // stop oscillator
            strobe(CC2520_CMD_SXOSCOFF);

            // do a reset
            initRadio();
            state = STATE_PD;
            cmd = CMD_SIGNAL_DONE;
        }
        else if( cmd == CMD_STANDBY && state == STATE_IDLE )
            cmd = CMD_SIGNAL_DONE;
    }

    // TODO: turn off SFD capture when turning off radio
    tasklet_async command error_t RadioState.turnOff()
    {
        if( cmd != CMD_NONE )
            return EBUSY;
        else if( state == STATE_PD )
            return EALREADY;

#ifdef RADIO_DEBUG_MESSAGES
        if( call DiagMsg.record() )
        {
            call DiagMsg.str("turnOff");
            call DiagMsg.send();
        }
#endif

        cmd = CMD_TURNOFF;
        call Tasklet.schedule();

        return SUCCESS;
    }

    tasklet_async command error_t RadioState.standby()
    {
        if( cmd != CMD_NONE || (state == STATE_PD && ! call RadioAlarm.isFree()) )
            return EBUSY;
        else if( state == STATE_IDLE )
            return EALREADY;

#ifdef RADIO_DEBUG_MESSAGES
        if( call DiagMsg.record() )
        {
            call DiagMsg.str("standBy");
            call DiagMsg.send();
        }
#endif

        cmd = CMD_STANDBY;
        call Tasklet.schedule();

        return SUCCESS;
    }

    // TODO: turn on SFD capture when turning off radio
    tasklet_async command error_t RadioState.turnOn()
    {
        if( cmd != CMD_NONE || (state == STATE_PD && ! call RadioAlarm.isFree()) )
            return EBUSY;
        else if( state == STATE_RX_ON )
            return EALREADY;

#ifdef RADIO_DEBUG_MESSAGES
        if( call DiagMsg.record() )
        {
            call DiagMsg.str("turnOn");
            call DiagMsg.send();
        }
#endif

        cmd = CMD_TURNON;
        call Tasklet.schedule();

        return SUCCESS;
    }

    default tasklet_async event void RadioState.done() { }

/*----------------- TRANSMIT -----------------*/

    tasklet_async command error_t RadioSend.send(message_t* msg)
    {
        uint16_t time;
        uint8_t p;
        uint8_t length;
        uint8_t* data;
        uint8_t header;
        uint32_t time32;
        void* timesync;
        cc2520_status_t status;


        if( cmd != CMD_NONE || (state != STATE_IDLE && state != STATE_RX_ON) || ! isSpiAcquired() || radioIrq )
            return EBUSY;

        p = (call PacketTransmitPower.isSet(msg) ?
            call PacketTransmitPower.get(msg) : CC2520_DEF_RFPOWER) & CC2520_TX_PWR_MASK;

        if( p != txPower )
        {
            cc2520_txpower_t txpower = cc2520_txpower_default;

            txPower = p;

            txpower.f.pa_power = txPower;
            writeRegister(CC2520_TXPOWER, txpower.value);
        }

#ifdef RADIO_DEBUG_MESSAGES
        {
            uint8_t tmp1, tmp2;
            tmp1 = call Config.requiresRssiCca(msg);
            tmp2 = call CCA.get();
            if( call DiagMsg.record() )
            {
                length = getHeader(msg)->length;

                call DiagMsg.str("cca");
                call DiagMsg.int8(tmp1);
                call DiagMsg.int8(tmp2);
                call DiagMsg.send();
            }
            if( tmp1 && !tmp2)
                return EBUSY;
        }
#else
        if( call Config.requiresRssiCca(msg) && !call CCA.get() )
            return EBUSY;
#endif

        // there's a chance that there was a receive SFD interrupt in such a
        // short time.
        // TODO: there's still a chance

        atomic if (call SFD.get() == 1 || radioIrq)
            return EBUSY;
        else
            // stop receiving
            strobe(CC2520_CMD_SRFOFF);

        ASSERT( ! radioIrq );

        data = getPayload(msg);
        length = getHeader(msg)->length;

        // length | data[0] ... data[length-3] | automatically generated FCS

        atomic writeTxFifo(&length, 1);

        // FCS is automatically generated
        length -= 2;

        // preload fcf, dsn, destpan, and dest
        header = call Config.headerPreloadLength();
        if( header > length )
            header = length;

        length -= header;

        // first upload the header to gain some time
        atomic writeTxFifo(data, header);


        atomic {
            strobe(CC2520_CMD_STXON);
            time = call RadioAlarm.getNow();
            call SfdCapture.captureFallingEdge();
            state = STATE_TX_ON;
        }

#ifdef RADIO_DEBUG_MESSAGES
        txMsg = msg;
#endif

        // do something useful, just to wait a little (12 symbol periods)
        time32 = call LocalTime.get();
        timesync = call PacketTimeSyncOffset.isSet(msg) ? ((void*)msg) + call PacketTimeSyncOffset.get(msg) : 0;

        time32 += (int16_t)(time + TX_SFD_DELAY) - (int16_t)(time32);

        if( timesync != 0 )
            *(timesync_relative_t*)timesync = (*(timesync_absolute_t*)timesync) - time32;

        // write the rest of the payload to the fifo
        atomic writeTxFifo(data+header, length);

        // get status
        status = getStatus();
        ASSERT ( status.tx_active == 1);
        // FIXME: have to check for underflow exception!
        //ASSERT ( status.tx_underflow == 0);
        ASSERT ( status.xosc_stable == 1);

        if( timesync != 0 )
            *(timesync_absolute_t*)timesync = (*(timesync_relative_t*)timesync) + time32;

        call PacketTimeStamp.set(msg, time32);

#ifdef RADIO_DEBUG_MESSAGES
        if( call DiagMsg.record() )
        {
            length = getHeader(msg)->length;

            call DiagMsg.chr('t');
            call DiagMsg.uint32(call PacketTimeStamp.isValid(msg) ? call PacketTimeStamp.timestamp(msg) : 0);
            call DiagMsg.uint16(call RadioAlarm.getNow());
            call DiagMsg.int8(length);
            call DiagMsg.hex8s(getPayload(msg), length - 2);
            call DiagMsg.send();
        }
#endif

        // wait for SFD falling edge
        state = STATE_BUSY_TX_2_RX_ON;
        cmd = CMD_TRANSMIT;

        return SUCCESS;
    }

    default tasklet_async event void RadioSend.sendDone(error_t error) { }
    default tasklet_async event void RadioSend.ready() { }

/*----------------- CCA -----------------*/

    tasklet_async command error_t RadioCCA.request()
    {
        if( cmd != CMD_NONE || state != STATE_RX_ON )
            return EBUSY;

        if(call CCA.get()) {
            signal RadioCCA.done(SUCCESS);
        } else {
            signal RadioCCA.done(EBUSY);
        }
        return SUCCESS;
    }

    default tasklet_async event void RadioCCA.done(error_t error) { }

/*----------------- RECEIVE -----------------*/

    // recover from an error
    // rx fifo flush does not always work
    inline void recover() {
        cc2520_status_t status;

        // reset the radio, initialize registers to default values
        ASSERT(0);
        resetRadio();

        call SfdCapture.disable();

        ASSERT(state == STATE_PD);

        // start oscillator
        strobe(CC2520_CMD_SXOSCON);

        // going idle in PD_2_IDLE_TIME
        state = STATE_PD_2_IDLE;

        call BusyWait.wait(PD_2_IDLE_TIME); // .86ms OSC startup time

        // get status
        status = getStatus();
        ASSERT ( status.rssi_valid == 0);
        //ASSERT ( status.lock == 0);
        ASSERT ( status.tx_active == 0);
        //ASSERT ( status.enc_busy == 0);
        //ASSERT ( status.tx_underflow == 0);
        ASSERT ( status.xosc_stable == 1);

        // we're idle now
        state = STATE_IDLE;

        // download current channel to the radio
        setChannel();

        // start receiving
        strobe(CC2520_CMD_SRXON);
        state = STATE_IDLE_2_RX_ON;

        call SfdCapture.captureRisingEdge();

        // we will be able to receive packets in 12 symbol periods
        state = STATE_RX_ON;
    }

    inline void downloadMessage()
    {
        uint8_t length;
        uint16_t crc = 1;
        uint8_t* data;
        uint8_t rssi;
        uint8_t crc_ok_lqi;
        uint16_t sfdTime;

        state = STATE_RX_DOWNLOAD;

        atomic sfdTime = capturedTime;

        // data starts after the length field
        data = getPayload(rxMsg);

        // read the length byte
        readLengthFromRxFifo(&length);

#ifdef RADIO_DEBUG_MESSAGES
        if( call DiagMsg.record() )
        {
            call DiagMsg.str("rx");
            call DiagMsg.uint16(call RadioAlarm.getNow() - (uint16_t)call PacketTimeStamp.timestamp(rxMsg) );
            call DiagMsg.uint16(call RadioAlarm.getNow());
            call DiagMsg.uint16(call PacketTimeStamp.isValid(rxMsg) ? call PacketTimeStamp.timestamp(rxMsg) : 0);
            call DiagMsg.int8(length);
            call DiagMsg.hex8s(getPayload(rxMsg), length - 2);
            call DiagMsg.send();
        }
#endif

        // check for too short lengths
        if (length == 0) {
            // stop reading RXFIFO
            call CSN.set();

            ASSERT( call FIFOP.get() == 0 );
            ASSERT( call FIFO.get() == 0 );

            state = STATE_RX_ON;
            cmd = CMD_NONE;
            call SfdCapture.captureRisingEdge();
            return;
        }

        if (length == 1) {
            // skip payload and rssi
            atomic readCrcOkAndLqiFromRxFifo(&crc_ok_lqi);

            ASSERT( call FIFOP.get() == 0 );
            ASSERT( call FIFO.get() == 0 );

            state = STATE_RX_ON;
            cmd = CMD_NONE;
            call SfdCapture.captureRisingEdge();
            return;
        }

        if (length == 2) {
            // skip payload
            atomic readRssiFromRxFifo(&rssi);
            atomic readCrcOkAndLqiFromRxFifo(&crc_ok_lqi);

            ASSERT( call FIFOP.get() == 0 );
            ASSERT( call FIFO.get() == 0 );

            state = STATE_RX_ON;
            cmd = CMD_NONE;
            call SfdCapture.captureRisingEdge();
            return;
        }

        // check for too long lengths

        if( length > 127 ) {

            atomic recover();

            ASSERT( call FIFOP.get() == 0 );
            ASSERT( call FIFO.get() == 0 );

            state = STATE_RX_ON;
            cmd = CMD_NONE;
            call SfdCapture.captureRisingEdge();
            return;
        }

        if( length > call RadioPacket.maxPayloadLength() + 2 )
        {
            while( length-- > 2 ) {
                atomic readPayloadFromRxFifo(data, 1);
            }

            atomic readRssiFromRxFifo(&rssi);
            atomic readCrcOkAndLqiFromRxFifo(&crc_ok_lqi);

            ASSERT( call FIFOP.get() == 0 );

            state = STATE_RX_ON;
            cmd = CMD_NONE;
            call SfdCapture.captureRisingEdge();
            return;
        }

        // if we're here, length must be correct
        ASSERT(length >= 3 && length <= call RadioPacket.maxPayloadLength() + 2);

        getHeader(rxMsg)->length = length;

        // we'll read the FCS/CRC separately
        length -= 2;

        // download the whole payload
        readPayloadFromRxFifo(data, length );

        // the last two bytes are not the fsc, but RSSI(8), CRC_ON(1)+LQI(7)
        readRssiFromRxFifo(&rssi);
        readCrcOkAndLqiFromRxFifo(&crc_ok_lqi);

        // there are still bytes in the fifo or if there's an overflow,
        // recover
        // TODO: actually, we can signal that a message was received, without
        // timestamp set
        if (call FIFOP.get() == 1 || call FIFO.get() == 1) {
            atomic recover();
            state = STATE_RX_ON;
            cmd = CMD_NONE;
            call SfdCapture.captureRisingEdge();
            return;
        }

        state = STATE_RX_ON;
        cmd = CMD_NONE;

        // ready to receive new message: enable SFD interrupts
        call SfdCapture.captureRisingEdge();

        if( signal RadioReceive.header(rxMsg) )
        {
            // set RSSI, CRC and LQI only if we're accepting the message
            call PacketRSSI.set(rxMsg, rssi);
            call PacketLinkQuality.set(rxMsg, crc_ok_lqi & 0x7f);
            crc = (crc_ok_lqi > 0x7f) ? 0 : 1;
        }

        // signal only if it has passed the CRC check
        if( crc == 0 )
        {
           uint32_t time32;

            time32 = call LocalTime.get();
            atomic time32 += (int16_t)(sfdTime - RX_SFD_DELAY) - (int16_t)(time32);
            call PacketTimeStamp.set(rxMsg, time32);

#ifdef RADIO_DEBUG_MESSAGES
            if( call DiagMsg.record() )
            {
                call DiagMsg.str("r");
                call DiagMsg.uint16(call RadioAlarm.getNow() - (uint16_t)call PacketTimeStamp.timestamp(rxMsg) );
                call DiagMsg.uint16(call RadioAlarm.getNow());
                call DiagMsg.uint16(call PacketTimeStamp.isValid(rxMsg) ? call PacketTimeStamp.timestamp(rxMsg) : 0);
                call DiagMsg.int8(length);
                call DiagMsg.hex8s(getPayload(rxMsg), length);
                call DiagMsg.send();
            }
#endif
            rxMsg = signal RadioReceive.receive(rxMsg);

        }

    }


/*----------------- IRQ -----------------*/

    // RX SFD (rising edge), disabled for TX
    async event void SfdCapture.captured( uint16_t time )
    {
        ASSERT( ! radioIrq );
        ASSERT( state == STATE_RX_ON || state == STATE_TX_ON || state == STATE_BUSY_TX_2_RX_ON);

        radioIrq = TRUE;
        call SfdCapture.disable();
        capturedTime = time;

#ifdef RADIO_DEBUG_MESSAGES________
        if( call DiagMsg.record() )
        {
            call DiagMsg.str("SFD");
            call DiagMsg.uint16(call RadioAlarm.getNow());
            call DiagMsg.str("s=");
            call DiagMsg.uint8(state);
            if(call FIFO.get())
                call DiagMsg.str("FIFO");
            if(call FIFOP.get())
                call DiagMsg.str("FIFOP");
            if(call SFD.get())
                call DiagMsg.str("SFD");

            call DiagMsg.send();
        }
#endif

        // do the rest of the processing
        call Tasklet.schedule();
    }

    // FIFOP interrupt, last byte received
    async event void FifopInterrupt.fired()
    {
        // not used
    }

    inline void serviceRadio()
    {
        atomic if( isSpiAcquired() )
        {
            radioIrq = FALSE;

            if( state == STATE_RX_ON && cmd == CMD_NONE )
            {
                // it's an RX SFD
                cmd = CMD_DOWNLOAD;
            }
            else if( state == STATE_BUSY_TX_2_RX_ON && cmd == CMD_TRANSMIT)
            {
                // it's a TX_END
                state = STATE_RX_ON;
                cmd = CMD_NONE;
#ifdef RADIO_DEBUG_MESSAGES
            if( call DiagMsg.record() )
            {
                call DiagMsg.str("txdone");
                call DiagMsg.uint16(capturedTime - (uint16_t)call PacketTimeStamp.timestamp(txMsg));
                call DiagMsg.uint16(call RadioAlarm.getNow());
                if(call FIFO.get())
                    call DiagMsg.str("FIFO");
                if(call FIFOP.get())
                    call DiagMsg.str("FIFOP");
                if(call SFD.get())
                    call DiagMsg.str("SFD");

                call DiagMsg.send();
            }
#endif

                call SfdCapture.captureRisingEdge();
                signal RadioSend.sendDone(SUCCESS);

            }

            else
                ASSERT(FALSE);
        }
    }

    default tasklet_async event bool RadioReceive.header(message_t* msg)
    {
        return TRUE;
    }

    default tasklet_async event message_t* RadioReceive.receive(message_t* msg)
    {
        return msg;
    }

/*----------------- TASKLET -----------------*/

    tasklet_async event void Tasklet.run()
    {
        if( radioIrq )
            serviceRadio();

        if( cmd != CMD_NONE )
        {
            if( cmd == CMD_DOWNLOAD && state == STATE_RX_ON)
                downloadMessage();
            else if( CMD_TURNOFF <= cmd && cmd <= CMD_TURNON )
                changeState();
            else if( cmd == CMD_CHANNEL )
                changeChannel();

            if( cmd == CMD_SIGNAL_DONE )
            {
                cmd = CMD_NONE;
                signal RadioState.done();
            }
        }

        if( cmd == CMD_NONE && state == STATE_RX_ON && ! radioIrq )
            signal RadioSend.ready();

        if( cmd == CMD_NONE )
            call SpiResource.release();
    }

/*----------------- RadioPacket -----------------*/

    async command uint8_t RadioPacket.headerLength(message_t* msg)
    {
        return call Config.headerLength(msg) + sizeof(cc2520_header_t);
    }

    async command uint8_t RadioPacket.payloadLength(message_t* msg)
    {
        return getHeader(msg)->length - 2;
    }

    async command void RadioPacket.setPayloadLength(message_t* msg, uint8_t length)
    {
        ASSERT( 1 <= length && length <= 125 );
        ASSERT( call RadioPacket.headerLength(msg) + length + call RadioPacket.metadataLength(msg) <= sizeof(message_t) );

        // we add the length of the CRC, which is automatically generated
        getHeader(msg)->length = length + 2;
    }

    async command uint8_t RadioPacket.maxPayloadLength()
    {
        ASSERT( call Config.maxPayloadLength() - sizeof(cc2520_header_t) <= 125 );

        return call Config.maxPayloadLength() - sizeof(cc2520_header_t);
    }

    async command uint8_t RadioPacket.metadataLength(message_t* msg)
    {
        return call Config.metadataLength(msg) + sizeof(cc2520_metadata_t);
    }

    async command void RadioPacket.clear(message_t* msg)
    {
        // all flags are automatically cleared
    }

/*----------------- PacketTransmitPower -----------------*/

    async command bool PacketTransmitPower.isSet(message_t* msg)
    {
        return call TransmitPowerFlag.get(msg);
    }

    async command uint8_t PacketTransmitPower.get(message_t* msg)
    {
        return getMeta(msg)->power;
    }

    async command void PacketTransmitPower.clear(message_t* msg)
    {
        call TransmitPowerFlag.clear(msg);
    }

    async command void PacketTransmitPower.set(message_t* msg, uint8_t value)
    {
        call TransmitPowerFlag.set(msg);
        getMeta(msg)->power = value;
    }

/*----------------- PacketRSSI -----------------*/

    async command bool PacketRSSI.isSet(message_t* msg)
    {
        return call RSSIFlag.get(msg);
    }

    async command uint8_t PacketRSSI.get(message_t* msg)
    {
        return getMeta(msg)->rssi;
    }

    async command void PacketRSSI.clear(message_t* msg)
    {
        call RSSIFlag.clear(msg);
    }

    async command void PacketRSSI.set(message_t* msg, uint8_t value)
    {
        // just to be safe if the user fails to clear the packet
        call TransmitPowerFlag.clear(msg);

        call RSSIFlag.set(msg);
        getMeta(msg)->rssi = value;
    }

/*----------------- PacketTimeSyncOffset -----------------*/

    async command bool PacketTimeSyncOffset.isSet(message_t* msg)
    {
        return call TimeSyncFlag.get(msg);
    }

    async command uint8_t PacketTimeSyncOffset.get(message_t* msg)
    {
        return call RadioPacket.headerLength(msg) + call RadioPacket.payloadLength(msg) - sizeof(timesync_absolute_t);
    }

    async command void PacketTimeSyncOffset.clear(message_t* msg)
    {
        call TimeSyncFlag.clear(msg);
    }

    async command void PacketTimeSyncOffset.set(message_t* msg, uint8_t value)
    {
        // we do not store the value, the time sync field is always the last 4 bytes
        ASSERT( call PacketTimeSyncOffset.get(msg) == value );

        call TimeSyncFlag.set(msg);
    }

/*----------------- PacketLinkQuality -----------------*/

    async command bool PacketLinkQuality.isSet(message_t* msg)
    {
        return TRUE;
    }

    async command uint8_t PacketLinkQuality.get(message_t* msg)
    {
        return getMeta(msg)->lqi;
    }

    async command void PacketLinkQuality.clear(message_t* msg)
    {
    }

    async command void PacketLinkQuality.set(message_t* msg, uint8_t value)
    {
        getMeta(msg)->lqi = value;
    }

}
