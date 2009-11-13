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
 * @author Thomas Schmid
 **/

module TestSpiC
{
	uses interface Leds;
	uses interface Boot;
	uses interface StdControl as SpiControl;
	uses interface SpiByte;
    uses interface SpiPacket;
    uses interface GeneralIO as CSN;
    uses interface HplSam3uSpiConfig as SpiConfig;
}
implementation
{
    task void transferPacketTask()
    {
        uint8_t tx_buf[10];
        uint8_t rx_buf[10];
        uint8_t i;

        for(i=0; i<10; i++)
        {
            tx_buf[i] = 0xCD;
            rx_buf[i] = 0;
        }

        call SpiControl.start();

        call CSN.clr();
        call SpiPacket.send(tx_buf, rx_buf, 10);
    }

	task void transferTask()
	{
		uint8_t byte;

		call SpiControl.start();
        call CSN.clr();
        
        byte = call SpiByte.write(0xCD);
        if(byte == 0xCD)
        {
            call Leds.led0Toggle();
        } else {
            call Leds.led1Toggle();
        }
        byte = call SpiByte.write(0xAB);
        if(byte == 0xAB)
        {
            call Leds.led0Toggle();
        } else {
            call Leds.led1Toggle();
        }
        call CSN.set();

        call SpiControl.stop();

        post transferPacketTask();
        //post transferTask();
	}

	event void Boot.booted()
	{

        call SpiConfig.enableLoopBack();
        call CSN.makeOutput();

		post transferTask();
	}

    async event void SpiPacket.sendDone(uint8_t* tx_buf, uint8_t* rx_buf, uint16_t len, error_t error)
    {
        uint8_t i;

        if(error == SUCCESS)
        {
            if(len == 10)
            {
                for(i=0; i<10; i++){
                    if(rx_buf[i] != 0xCD)
                    {
                        call Leds.led1Toggle();
                        return;
                    }
                }
                call Leds.led0Toggle();
                return;
            }
        }
        call Leds.led1Toggle();
        //call CSN.set();
    }
}
