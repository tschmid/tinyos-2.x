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
        interface SpiByte[uint8_t];
        interface SpiPacket[uint8_t]; // not supported yet
    }
    uses
    {
	interface ArbiterInfo;
        interface HplSam3uSpiConfig;
        interface HplSam3uSpiControl;
        interface HplSam3uSpiInterrupts;
        interface HplSam3uSpiStatus;
        interface HplNVICInterruptCntl as SpiIrqControl;
        interface HplSam3uPeripheralClockCntl as SpiClockControl;
        interface HplSam3uClock as ClockConfig;
        interface HplSam3uGeneralIOPin as SpiPinMiso;
        interface HplSam3uGeneralIOPin as SpiPinMosi;
        interface HplSam3uGeneralIOPin as SpiPinSpck;
    }
}
implementation
{

    void signalDone();
    task void signalDone_task();

    uint8_t* globalTxBuf;
    uint8_t* globalRxBuf;
    uint16_t globalLen;

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

        // reset the SPI configuration
        call HplSam3uSpiControl.resetSpi();

        // configure for master
        call HplSam3uSpiConfig.setMaster();

        // chip select options
        call HplSam3uSpiConfig.setFixedCS(); // CS needs to be configured for each message sent!
        //call HplSam3uSpiConfig.setVariableCS(); // CS needs to be configured for each message sent!
        call HplSam3uSpiConfig.setDirectCS(); // CS pins are not multiplexed

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

    async command uint8_t SpiByte.write[uint8_t device]( uint8_t tx)
    {
        uint8_t byte;

        //call HplSam3uSpiChipSelConfig.enableCSActive();
        call HplSam3uSpiStatus.setDataToTransmitCS(tx, device, FALSE);
        while(!call HplSam3uSpiStatus.isRxFull());
        byte = (uint8_t)call HplSam3uSpiStatus.getReceivedData();
        return byte;
    }

    async command error_t SpiPacket.send[uint8_t device](uint8_t* txBuf, uint8_t* rxBuf, uint16_t len)
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
                call HplSam3uSpiStatus.setDataToTransmitCS(txBuf[m_pos], device, FALSE);

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
        uint8_t device = call ArbiterInfo.userId();
        signal SpiPacket.sendDone[device](globalTxBuf, globalRxBuf, globalLen, SUCCESS);
    }


    default async event void SpiPacket.sendDone[uint8_t device](uint8_t* tx_buf, 
                                    uint8_t* rx_buf, uint16_t len, error_t error) {}

    async event void HplSam3uSpiInterrupts.receivedData(uint16_t data) {};
    async event void ClockConfig.mainClockChanged() {};
}

