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

#include "sam3uuarthardware.h"

/**
 * The hardware abstraction layer for the SAM3U UART, grouping functionality.
 *
 * @author wanja@cs.fau.de
 */

module HalSam3uUartP
{
	provides
	{
		interface Init;
		interface HalSam3uUart;
	}
	uses
	{
		interface HplSam3uUartConfig;
		interface HplSam3uUartControl;
		interface HplSam3uUartInterrupts;
		interface HplSam3uUartStatus;
	}
}
implementation
{
	async event void HplSam3uUartInterrupts.uartInterrupt()
	{
		// decode and dispatch the actual interrupt cause
		if (call HplSam3uUartStatus.isReceiverReady()) {
			signal HalSam3uUart.receiverReady();
		}
		if (call HplSam3uUartStatus.isTransmitterReady()) {
			signal HalSam3uUart.transmitterReady();
		}
		if (call HplSam3uUartStatus.isEndOfReceiverTransfer()) {
			signal HalSam3uUart.endOfReceiverTransfer();
		}
		if (call HplSam3uUartStatus.isEndOfTransmitterTransfer()) {
			signal HalSam3uUart.endOfTransmitterTransfer();
		}
		if (call HplSam3uUartStatus.isOverrunError()) {
			signal HalSam3uUart.overrunError();
		}
		if (call HplSam3uUartStatus.isFramingError()) {
			signal HalSam3uUart.framingError();
		}
		if (call HplSam3uUartStatus.isParityError()) {
			signal HalSam3uUart.parityError();
		}
		if (call HplSam3uUartStatus.isTransmitterEmpty()) {
			signal HalSam3uUart.transmitterEmpty();
		}
		if (call HplSam3uUartStatus.isTransmissionBufferEmpty()) {
			signal HalSam3uUart.transmissionBufferEmpty();
		}
		if (call HplSam3uUartStatus.isReceiveBufferFull()) {
			signal HalSam3uUart.receiveBufferFull();
		}
	}

	command error_t Init.init()
	{
		// FIXME: init PIO, NVIC, PMC clock enable
		volatile uint32_t *PIOA_PDR = (volatile uint32_t *) 0x400e0c04;
		volatile uint32_t *PIOA_ABSR = (volatile uint32_t *) 0x400e0c70;
		volatile uint32_t *PMC_PCER = (volatile uint32_t *) 0x400e0410;

		// disable generation of UART IRQs
		call HalSam3uUart.disableAllUartInterrupts();

		// FIXME: init PIO, NVIC, PMC clock enable
		// setup PIOC: PA11, PA12 -> peripheral A
		// disable PIO driving
		*PIOA_PDR = 0x00001800;
		// select peripheral A
		*PIOA_ABSR = 0x00000000;
		// enable peripheral clock (ID 8; p. 41)
		*PMC_PCER = 0x00000100;

		// configure mode, parity, baud rate
		call HplSam3uUartConfig.setChannelMode(UART_MR_CHMODE_NORMAL);
		call HplSam3uUartConfig.setParityType(UART_MR_PAR_NONE);
		call HplSam3uUartConfig.setClockDivisor(312);

		// enable the units
		call HplSam3uUartControl.enableReceiver();
		call HplSam3uUartControl.enableTransmitter();

		// enable generation of UART IRQs
		//call HalSam3uUart.enableAllUartInterrupts();
		call HplSam3uUartInterrupts.enableRxrdyIrq();

		return SUCCESS;
	}

	command void HalSam3uUart.disableAllUartInterrupts()
	{
		call HplSam3uUartInterrupts.disableRxrdyIrq();
		call HplSam3uUartInterrupts.disableTxrdyIrq();
		call HplSam3uUartInterrupts.disableEndrxIrq();
		call HplSam3uUartInterrupts.disableEndtxIrq();
		call HplSam3uUartInterrupts.disableOvreIrq();
		call HplSam3uUartInterrupts.disableFrameIrq();
		call HplSam3uUartInterrupts.disablePareIrq();
		call HplSam3uUartInterrupts.disableTxemptyIrq();
		call HplSam3uUartInterrupts.disableTxbufeIrq();
		call HplSam3uUartInterrupts.disableRxbuffIrq();
	}

	command void HalSam3uUart.enableAllUartInterrupts()
	{
		call HplSam3uUartInterrupts.enableRxrdyIrq();
		call HplSam3uUartInterrupts.enableTxrdyIrq();
		call HplSam3uUartInterrupts.enableEndrxIrq();
		call HplSam3uUartInterrupts.enableEndtxIrq();
		call HplSam3uUartInterrupts.enableOvreIrq();
		call HplSam3uUartInterrupts.enableFrameIrq();
		call HplSam3uUartInterrupts.enablePareIrq();
		call HplSam3uUartInterrupts.enableTxemptyIrq();
		call HplSam3uUartInterrupts.enableTxbufeIrq();
		call HplSam3uUartInterrupts.enableRxbuffIrq();
	}

	command error_t HalSam3uUart.sendChar(uint8_t letter)
	{
		if (call HplSam3uUartStatus.isTransmitterReady()) {
			call HplSam3uUartStatus.setCharToTransmit(letter);
			return SUCCESS;
		} else {
			return FAIL;
		}
	}

	command uint8_t HalSam3uUart.receiveChar()
	{
		return (call HplSam3uUartStatus.getReceivedChar());
	}

	default async event void HalSam3uUart.receiverReady() {}
	default async event void HalSam3uUart.transmitterReady() {}
	default async event void HalSam3uUart.endOfReceiverTransfer() {}
	default async event void HalSam3uUart.endOfTransmitterTransfer() {}
	default async event void HalSam3uUart.overrunError() {}
	default async event void HalSam3uUart.framingError() {}
	default async event void HalSam3uUart.parityError() {}
	default async event void HalSam3uUart.transmitterEmpty() {}
	default async event void HalSam3uUart.transmissionBufferEmpty() {}
	default async event void HalSam3uUart.receiveBufferFull() {}
}
