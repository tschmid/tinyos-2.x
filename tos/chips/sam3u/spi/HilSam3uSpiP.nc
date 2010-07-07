/**
 * "Copyright (c) 2009 The Regents of the University of California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement
 * is hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
 * OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 * SPI implementation for the SAM3U chip. Does not use DMA (PDC) at this
 * point. Byte interface performs busy wait!
 *
 * @author Thomas Schmid
 */

#include "sam3uspihardware.h"

module HilSam3uSpiP
{
    provides
    {
        interface Init;
        interface StdControl;
        interface SpiByte;
        interface SpiPacket; // not supported yet
    }
    uses
    {
        interface HplSam3uSpiConfig;
        interface HplSam3uSpiControl;
        interface HplSam3uSpiInterrupts;
        interface HplSam3uSpiStatus;
        interface HplSam3uSpiChipSelConfig;
        interface HplNVICInterruptCntl as SpiIrqControl;
        interface HplSam3uGeneralIOPin as SpiPinMiso;
        interface HplSam3uGeneralIOPin as SpiPinMosi;
        interface HplSam3uGeneralIOPin as SpiPinSpck;
        interface HplSam3uGeneralIOPin as SpiPinNPCS;
        interface HplSam3uPeripheralClockCntl as SpiClockControl;
        interface HplSam3uClock as ClockConfig;
	interface Leds;
    }
}
implementation
{

    void signalDone();
    task void signalDone_task();

    uint8_t* globalTxBuf;
    uint8_t* globalRxBuf;
    uint16_t globalLen;

    void setClockDivisor()
    {
        uint32_t mck;
        uint16_t cd;

        mck = call ClockConfig.getMainClockSpeed(); // in kHz (e.g., 48,000)

        // Can be set up to 8MHz.
        // clock speed = mck / cd
        // here, cd = mck/speed
        //cd = (uint8_t) (mck / 500); // mck is in kHz!
        //cd = (uint8_t) (mck / 4);
	cd = 10;

        call HplSam3uSpiChipSelConfig.setBaud(cd);
    }

    command error_t Init.init()
    {
        // turn off all interrupts
        call HplSam3uSpiInterrupts.disableAllSpiIrqs();

        // configure NVIC
        call SpiIrqControl.configure(IRQ_PRIO_SPI);
        call SpiIrqControl.enable();

        // configure PIO
        call SpiPinMiso.disablePioControl();
        call SpiPinMiso.selectPeripheralA();
        call SpiPinMosi.disablePioControl();
        call SpiPinMosi.selectPeripheralA();
        call SpiPinSpck.disablePioControl();
        call SpiPinSpck.selectPeripheralA();
/*
        call SpiPinNPCS.enablePullUpResistor();
        call SpiPinNPCS.disablePioControl();
        call SpiPinNPCS.selectPeripheralB();
        call SpiPinNPCS.disableInterrupt();
*/
        call HplSam3uSpiControl.resetSpi();

        // configure for master
        call HplSam3uSpiConfig.setMaster();

        // chip select options
        call HplSam3uSpiConfig.setFixedCS(); // CS needs to be configured for each message sent!
        //call HplSam3uSpiConfig.setVariableCS(); // CS needs to be configured for each message sent!
        call HplSam3uSpiConfig.setDirectCS(); // CS pins are not multiplexed

        // configure clock
        setClockDivisor();
        call HplSam3uSpiChipSelConfig.setClockPolarity(0); // logic zero is inactive
        call HplSam3uSpiChipSelConfig.setClockPhase(1);    // out on rising, in on falling
        call HplSam3uSpiChipSelConfig.disableAutoCS();     // disable automatic rising of CS after each transfer
        //call HplSam3uSpiChipSelConfig.enableAutoCS();

        call HplSam3uSpiChipSelConfig.enableCSActive();    // if the CS line is not risen automatically after the last tx. The lastxfer bit has to be used.
        //call HplSam3uSpiChipSelConfig.disableCSActive(); 

        call HplSam3uSpiChipSelConfig.setBitsPerTransfer(SPI_CSR_BITS_8);
        call HplSam3uSpiChipSelConfig.setTxDelay(0);
        call HplSam3uSpiChipSelConfig.setClkDelay(0);

        // do we really have to start it??? It seems that the CC2420 driver
        // doesn't do that!
        // the grant/release should take care of this!
        call StdControl.start();

        return SUCCESS;
    }

    command error_t StdControl.start()
    {
        // enable peripheral clock
        call SpiClockControl.enable();

        // enable SPI
        call HplSam3uSpiControl.enableSpi();

        // enable SPI IRQ (Byte is a busy wait!)
        //call HplSam3uSpiInterrupts.enableRxFullIrq();

        return SUCCESS;
    }

    command error_t StdControl.stop()
    {
        // stop the SPI
        call HplSam3uSpiControl.disableSpi();

        // stop the peripheral clock
        call SpiClockControl.disable();

        return SUCCESS;
    }

    async command uint8_t SpiByte.write( uint8_t tx)
    {
        uint8_t byte;

        //call HplSam3uSpiChipSelConfig.enableCSActive();
        call HplSam3uSpiStatus.setDataToTransmitCS(tx, 2, FALSE);
        while(!call HplSam3uSpiStatus.isRxFull());
        byte = (uint8_t)call HplSam3uSpiStatus.getReceivedData();
        return byte;
    }

    async command error_t SpiPacket.send( uint8_t* txBuf, uint8_t* rxBuf, uint16_t len)
    {
        uint16_t m_len = len;
        uint16_t m_pos = 0;

        if(len)
        {
            while( m_pos < len) 
            {
                /**
                 * FIXME: in order to be compatible with the general TinyOS
                 * Spi Interface, we can't do automatic CS control!!!
                if(m_pos == len-1)
                    call HplSam3uSpiStatus.setDataToTransmitCS(txBuf[m_pos], 3, TRUE);
                else
                    call HplSam3uSpiStatus.setDataToTransmitCS(txBuf[m_pos], 3, FALSE);
                    */
                call HplSam3uSpiStatus.setDataToTransmitCS(txBuf[m_pos], 3, FALSE);

                while(!call HplSam3uSpiStatus.isRxFull());
                rxBuf[m_pos] = (uint8_t)call HplSam3uSpiStatus.getReceivedData();
                m_pos += 1;
            }
        }
        atomic {
            globalRxBuf = rxBuf;
            globalTxBuf = txBuf;
            globalLen = m_len;
        }
        post signalDone_task();
        //atomic signal SpiPacket.sendDone(txBuf, rxBuf, m_len, SUCCESS);
        return SUCCESS;
    }

    task void signalDone_task() {
        atomic signalDone();
    }


    void signalDone() {
        signal SpiPacket.sendDone( globalTxBuf, globalRxBuf, globalLen, SUCCESS );
    }


    default async event void SpiPacket.sendDone(uint8_t* tx_buf, uint8_t* rx_buf, uint16_t len, error_t error) {}

    async event void HplSam3uSpiInterrupts.receivedData(uint16_t data) {};
    async event void ClockConfig.mainClockChanged() {};
}

