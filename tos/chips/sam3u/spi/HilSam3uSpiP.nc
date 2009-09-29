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
    }
}
implementation
{

    void setClockDivisor()
    {
        uint32_t mck;
        uint16_t cd;

        mck = call ClockConfig.getMainClockSpeed(); // in kHz (e.g., 48,000)

        // Can be set up to 8MHz. We use 4MHz for now
        // clock speed = mck / cd
        // here, cd = mck/speed
        cd = (uint8_t) (mck / 4000); // mck is in kHz!

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

        call SpiPinNPCS.disablePioControl();
        call SpiPinNPCS.selectPeripheralA(); // FIXME: this only works for NPCS0! Others are peripheralB!!!

        // configure for master
        call HplSam3uSpiConfig.setMaster();

        // chip select options
        call HplSam3uSpiConfig.setFixedCS(); // CS needs to be configured through chip select register!
        call HplSam3uSpiConfig.setDirectCS(); // CS pins are not multiplexed

        // configure clock
        call HplSam3uSpiChipSelConfig.setClockPolarity(0); // logic zero is inactive
        call HplSam3uSpiChipSelConfig.setClockPhase(0);    // out on rising, in on falling
        call HplSam3uSpiChipSelConfig.disableAutoCS();
        call HplSam3uSpiChipSelConfig.setBitsPerTransfer(SPI_CSR_BITS_8);
        setClockDivisor();

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

        call HplSam3uSpiStatus.setDataToTransmit(tx);
        while(!call HplSam3uSpiStatus.isRxFull());
        byte = (uint8_t)call HplSam3uSpiStatus.getReceivedData();
        return byte;
    }

    async command error_t SpiPacket.send( uint8_t* txBuf, uint8_t* rxBuf, uint16_t len)
    {
        uint8_t* m_tx_buf = txBuf;
        uint8_t* m_rx_buf = rxBuf;
        uint16_t m_len = len;
        uint16_t m_pos = 0;

        if(len)
        {
            while( m_pos < len) 
            {
                m_rx_buf[m_pos] = call SpiByte.write(m_tx_buf[m_pos]);
                m_pos += 1;
            }
        }
        signal SpiPacket.sendDone(m_tx_buf, m_rx_buf, m_len, SUCCESS);
        return SUCCESS;
    }

    default async event void SpiPacket.sendDone(uint8_t* tx_buf, uint8_t* rx_buf, uint16_t len, error_t error) {}

    async event void HplSam3uSpiInterrupts.receivedData(uint16_t data) {};
    async event void ClockConfig.mainClockChanged() {};
}

