/*
 * Copyright (c) 2009 Stanford University.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Stanford University nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * @author wanja@cs.fau.de
 **/

#include "sam3uuarthardware.h"

module TestUartC
{
	uses interface Leds;
	uses interface Boot;
	uses interface HplSam3uUartConfig;
	uses interface HplSam3uUartControl;
	uses interface HplSam3uUartInterrupts;
	uses interface HplSam3uUartStatus;
	uses interface HplNVICInterruptCntl as UartIrqControl;
}
implementation
{
	event void Boot.booted()
	{
		//uint8_t counter = 0;
		uint8_t letter = 'a';

		volatile uint32_t *PIOA_PDR = (volatile uint32_t *) 0x400e0c04;
		volatile uint32_t *PIOA_ABSR = (volatile uint32_t *) 0x400e0c70;
		volatile uint32_t *PMC_PCER = (volatile uint32_t *) 0x400e0410;
//		volatile uint32_t *UART_CR = (volatile uint32_t *) 0x400e0600;
//		volatile uint32_t *UART_MR = (volatile uint32_t *) 0x400e0604;
//		volatile uint32_t *UART_BRGR2 = (volatile uint32_t *) 0x400e0620;

		// setup PIOC: PA11, PA12 -> peripheral A
		// disable PIO driving
		*PIOA_PDR = 0x00001800;
		// select peripheral A
		*PIOA_ABSR = 0x00000000;

		// enable peripheral clock (ID 8; p. 41)
		*PMC_PCER = 0x00000100;
		//*PMC_PCER = 0xffffffff;

		// Baud rate = MCK / (13 x 16) = 4 MHz / 208 = 19,230 Hz
		// Baud rate = MCK / (26 x 16) = 4 MHz / 416 = 9,615 Hz
		//call HplSam3uUartConfig.setClockDivisor(26);
		call HplSam3uUartConfig.setClockDivisor(312); // 9,615 Hz
		//call HplSam3uUartConfig.setClockDivisor(3333); // 900 Hz
		//*UART_BRGR2 = 0x0000000d;

		// 0100.0010.0000.0000: CHMODE = Remote Loopback, PAR = No Parity
		// 0100.0010.0000.0000: CHMODE = Auto Echo
		//*UART_MR = 0x00004800;
		call HplSam3uUartConfig.setChannelMode(UART_MR_CHMODE_NORMAL);

		// FIXME: bug (has to be written at once)
		call HplSam3uUartConfig.setParityType(UART_MR_PAR_NONE);

		// enable UART and echo mode
		// 0000.0000.0101.0000: TXEN, RXEN
		//*UART_CR = 0x00000050;
		call HplSam3uUartControl.enableReceiver();
		call HplSam3uUartControl.enableTransmitter();
		
//		call HplSam3uUartInterrupts.enableRxrdyIrq();
//		call HplSam3uUartInterrupts.enableRxbuffIrq();
//
//		call UartIrqControl.configure(7);
//		call UartIrqControl.setPriority(7);
//		call UartIrqControl.enable();
//
//		__nesc_enable_interrupt();

		while (1) {
			volatile int i = 0;
			for (i = 0; i < 100000; i++);

			letter++;
			if (letter == 'z') { letter = 'a'; }


			if ((call HplSam3uUartStatus.isTransmitterReady()) == TRUE) {
				call HplSam3uUartStatus.setCharToTransmit(letter);
				call Leds.led1Toggle(); // Led 1 = Sent Something
				while ((call HplSam3uUartStatus.isTransmitterEmpty()) == FALSE) {
					// wait until character is sent
					call Leds.led2Toggle(); // Led 2 = Waiting
				}
			}
			call Leds.led0Toggle(); // Led 0 = Living
			//counter++;
			//counter = counter % 8;
			//call Leds.set(counter);
		}
	}

	async event void HplSam3uUartInterrupts.uartInterrupt()
	{
	}


//	void UartIrqHandler() @C() @spontaneous()
//	{
//		//call Leds.led1Toggle();
//	}
}
