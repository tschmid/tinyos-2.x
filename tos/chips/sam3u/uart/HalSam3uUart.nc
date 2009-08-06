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
 * The interface definition for the hardware abstraction layer
 * for the SAM3U UART, grouping functionality.
 *
 * @author wanja@cs.fau.de
 */

interface HalSam3uUart
{
	/**
	 * Initializes the UART subsystem. This includes:
	 * <ul>
	 * <li>Configuring mode, parity, baud rate</li>
	 * <li>Enabling the receiver and transmitter</li>
	 * </ul>
	 */
	//command void Init.init();

	/**
	 * Disables generation of all UART interrupts in the unit.
	 */
	command void disableAllUartInterrupts();

	/**
	 * Enables generation of all UART interrupts in the unit.
	 */
	command void enableAllUartInterrupts();

	/**
	 * Sends a character asynchronously; that is, the send call
	 * can fail if the hardware buffer is full.
	 */
	command error_t sendChar(uint8_t letter);

	/**
	 * Reads the receiver buffer. That doesn't mean that the
	 * read character has to be valid.
	 */
	command uint8_t receiveChar();

	async event void receiverReady();
	async event void transmitterReady();
	async event void endOfReceiverTransfer();
	async event void endOfTransmitterTransfer();
	async event void overrunError();
	async event void framingError();
	async event void parityError();
	async event void transmitterEmpty();
	async event void transmissionBufferEmpty();
	async event void receiveBufferFull();
}
