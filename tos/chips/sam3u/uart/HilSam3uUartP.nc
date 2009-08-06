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
 */

module HilSam3uUartP
{
	provides
	{
		interface Init;
		interface StdControl;
		interface UartByte;
		interface UartStream;
	}
	uses
	{
		interface HplSam3uControl;
		interface HplSam3uInterrupts;
		interface HplSam3uStatus;
		interface HplSam3uConfig;
	}
}
implementation
{
	uint8_t *receiveBuffer; // pointer to current receive buffer or 0 if none
	uint16_t receiveBufferLength; // length of the current receive buffer
	uint16_t receiveBufferPosition; // position of the next character to receive in the buffer

	command error_t Init.init()
	{
		// FIXME
	}

	command error_t StdControl.start()
	{
		// turn off all UART IRQs
		call HplSam3uInterrupts.disableAllUartIrqs();

		// enable receiver and transmitter
		call HplSam3uControl.enableReceiver();
		call HplSam3uControl.enableTransmitter();

		// enable receive IRQ
		call HplSam3uInterrupts.enableRxrdyIrq();

		return SUCCESS;
	}

	command error_t StdControl.stop()
	{
		// will finish any ongoing receptions and transmissions
		call HplSam3uControl.disableReceiver();
		call HplSam3uControl.disableTransmitter();
	}

	async command error_t UartStream.enableReceiveInterrupt()
	{
		call HplSam3uInterrupts.enableRxrdyIrq();
		return SUCCESS;
	}

	async command error_t UartStream.disableReceiveInterrupt()
	{
		call HplSam3uInterrupts.disableRxrdyIrq();
		return SUCCESS;
	}

	async command error_t UartStream.receive(uint8_t* buffer, uint16_t length)
	{
		if (length == 0) {
			return FAIL;
		}
		atomic {
			if (receiveBuffer != NULL) {
				return EBUSY; // in the middle of a reception
			}

			receiveBuffer = buffer;
			receiveBufferLength = length;
			receiveBufferPosition = 0;

			call HplSam3uInterrupts.enableRxrdyIrq();
		}
		return SUCCESS;
	}

	async event void HplSam3uInterrupts.receivedByte(uint8_t data)
	{
		if (receiveBuffer != NULL) {
			// receive into buffer
			receiveBuffer[receiveBufferPosition] = data;
			receiveBufferPosition++;

			if (receiveBufferPosition >= receiveBufferLength) {
				// buffer is full
				uint8_t *bufferToSignal = receiveBuffer;
				atomic {
					receiveBuffer = NULL;
					call HplSam3uInterrupts.disableRxrdyIrq();
				}

				// signal reception of complete buffer
				signal UartStream.receiveDone(bufferToSignal, bufferLength, SUCCESS);
			}
		} else {
			// signal single byte reception
			signal UartStream.receivedByte(data);
		}
	}

	async command error_t UartStream.send(uint8_t *buffer, uint16_t length)
	{
		if (length == 0) {
			return FAIL;
		}
		if (transmitBuffer != NULL) {
			return EBUSY;
		}

		transmitBufferLength = length;
		transmitBuffer = buffer;
		transmitBufferPosition = 0;

		// enable ready-to-transmit IRQ
		call HplSam3uInterrupts.enableTxrdyIrq();
	}

	async event void HplSam3uInterrupts.transmitterReady()
	{
		if (transmitBufferPosition < transmitBufferLength) {
			// characters to transfer in the buffer
			call HplSam3uStatus.setCharToTransmit(transmitBuffer[transmitBufferPosition]);
			transmitBufferPosition++;
		} else {
			// all characters transmitted
			uint8_t *bufferToSignal = transmitBuffer;

			transmitBuffer = NULL;
			call HplSam3uInterrupts.disableTxrdyIrq();
			signal UartStream.sendDone(bufferToSignal, transmitBufferLength, SUCCESS);
		}
	}

	async command error_t UartByte.send(uint8_t byte)
	{
		if (call HplSam3uInterrupts.isEnabledTxrdyIrq() == TRUE) {
			return FAIL; // in the middle of a stream transmission
		}

		// transmit synchronously
		call HplSam3uStatus.setCharToTransmit(byte);
		while (call HplSam3uStatus.isTransmitterReady() == FALSE);

		return SUCCESS:
	}

	async command error_t UartByte.receive(uint8_t *byte, uint8_t timeout)
	{
		// FIXME timeout currently ignored
		if (call HplSam3uInterrupts.isEnabledRxrdyIrq() == TRUE) {
			return FAIL; // in the middle of a stream reception
		}

		// receive synchronously
		while (call HplSam3uStatus.isReceiverReady() == FALSE);
		*byte = HplSam3uStatus.getReceivedChar();

		return SUCCESS;
	}

	default async event void UartStream.sendDone(uint8_t *buffer, uint16_t length, error_t error) {}
	default async event void UartStream.receivedByte(uint8_t byte) {}
	default async event void UartStream.receiveDone(uint8_t *buffer, uint16_t length, error_t error) {}
}
