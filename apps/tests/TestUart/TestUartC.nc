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

module TestUartC
{
	uses interface Leds;
	uses interface Boot;
	uses interface HplNVICInterruptCntl as UartIrqControl;
	uses interface StdControl as UartControl;
	uses interface UartByte;
	uses interface UartStream;
}
implementation
{
	// ` comes before a in the ASCII table
	uint8_t letter = '`';

	//task void sendTask();
	//task void receiveTask();

	void blinkRed()
	{
		while (TRUE) {
			volatile int i = 0;
			for (i = 0; i < 100000; i++);

			call Leds.led2Toggle();
		}
	}

	event void Boot.booted()
	{
		// call UartInit.init(); // should be called by SW init

		call UartIrqControl.configure(0xff);
		call UartIrqControl.enable();
		call UartControl.start();
		//call UartIrqControl.disable();
//		__nesc_enable_interrupt();

//		post sendTask();
//	}
//
//	task void sendTask()
//	{
while(TRUE) {
		volatile int i = 0;
		for (i = 0; i < 100000; i++);

		letter++;
		// { comes after z in the ASCII table
		if (letter == '{') { letter = 'a'; }
		//blinkRed();


		{
			uint8_t buffer[6] = {'H', 'e', 'l', 'l', 'o', '\n'};

			call UartStream.send(buffer, 6);

			while (TRUE);
		}

#if 0
		while (TRUE) {
			uint8_t got = 0;

			// blocking call to receive()
			error_t result = call UartByte.receive(&got, 42);
			if (result == SUCCESS) {
				call Leds.led0Toggle(); // Led 0 (green) = got something
			} else {
				call Leds.led2Toggle(); // Led 2 (red) = error
			}

			// send back received char
			result = call UartByte.send(got);
			if (result == SUCCESS) {
				call Leds.led1Toggle(); // Led 1 (green) = sent something
			} else {
				call Leds.led2Toggle(); // Led 2 (red) = error
			}
		}
#endif
}

		//post sendTask();
	}

	async event void UartStream.sendDone(uint8_t* buf, uint16_t len, error_t error)
	{
		blinkRed();
	}

	async event void UartStream.receiveDone(uint8_t* buf, uint16_t len, error_t error)
	{
		blinkRed();
	}

	async event void UartStream.receivedByte(uint8_t byte)
	{
		blinkRed();
	}

/*
	async event void HalSam3uUart.receiverReady()
	{
		post receiveTask();
	}

	task void receiveTask()
	{
		uint8_t receivedLetter;
		call Leds.led2Toggle(); // Led 2 (red) = received something
		receivedLetter = call HalSam3uUart.receiveChar();
	}

	async event void HalSam3uUart.transmitterReady() {}
	async event void HalSam3uUart.endOfReceiverTransfer() {}
	async event void HalSam3uUart.endOfTransmitterTransfer() {}
	async event void HalSam3uUart.overrunError() {}
	async event void HalSam3uUart.framingError() {}
	async event void HalSam3uUart.parityError() {}
	async event void HalSam3uUart.transmitterEmpty() {}
	async event void HalSam3uUart.transmissionBufferEmpty() {}
	async event void HalSam3uUart.receiveBufferFull() {}
	*/
}
