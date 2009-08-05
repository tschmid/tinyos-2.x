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
	async event void uartInterrupt()
	{
		// decode and dispatch the actual interrupt cause
		if (call HplSam3uUartInterrupts.isReceiverReady()) {
			signal receiverReady();
		}
		if (call HplSam3uUartInterrupts.isTransmitterReady()) {
			signal transmitterReady();
		}
		if (call HplSam3uUartInterrupts.isEndOfReceiverTransfer()) {
			signal endOfReceiverTransfer();
		}
		if (call HplSam3uUartInterrupts.isEndOfTransmitterTransfer()) {
			signal endOfTransmitterTransfer();
		}
		if (call HplSam3uUartInterrupts.isOverrunError()) {
			signal overrunError();
		}
		if (call HplSam3uUartInterrupts.isFramingError()) {
			signal framingError();
		}
		if (call HplSam3uUartInterrupts.isParityError()) {
			signal parityError();
		}
		if (call HplSam3uUartInterrupts.isTransmitterEmpty()) {
			signal transmitterEmpty();
		}
		if (call HplSam3uUartInterrupts.isTransmissionBufferEmpty()) {
			signal transmissionBufferEmpty();
		}
		if (call HplSam3uUartInterrupts.isReceiveBufferFull()) {
			signal receiveBufferFull();
		}
	}

	command void Init.init()
	{
		// FIXME: init PIO, NVIC, PMC clock enable

		// configure mode, parity, baud rate
		call HplSam3uUartConfig.setChannelMode(UART_MR_CHMODE_NORMAL);
		call HplSam3uUartConfig.setParity(UART_MR_NONE);
		call HplSam3uUartConfig.setClockDivisor(312);

		// enable the units
		call HplSam3uUartControl.enableReceiver();
		call HplSam3uUartControl.enableTransmitter();
	}

	command error_t sendChar(uint8_t letter)
	{
		if (call HplSam3uUartStatus.isTransmitterReady()) {
			call HplSam3uUartStatus.setCharToTransmit(letter);
			return SUCCESS;
		} else {
			return FAIL;
		}
	}
}
