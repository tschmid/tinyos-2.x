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
 * Simple app to test RESTORE_TCB macro by letting threads terminate
 * by returning from their run() event.
 *
 * @author Wanja Hofer <wanja@cs.fau.de>
 */

module TestRestoreTcbC
{
	uses {
		interface Boot;
		interface Thread as Thread0;
		interface Thread as Thread1;
		interface Thread as Thread2;
		interface Leds;
	}
}
implementation
{
	event void Boot.booted() {
		call Thread0.start(NULL);
		call Thread1.start(NULL);
		call Thread2.start(NULL);
	}

	event void Thread0.run(void* arg) {
		call Leds.led0On();
		// exit, calling RESTORE_TCB() internally
		// should then schedule and dispatch thread 1
	}

	event void Thread1.run(void* arg) {
		call Leds.led1On();
		// exit, calling RESTORE_TCB() internally
		// should then schedule and dispatch thread 2
	}

	event void Thread2.run(void* arg) {
		call Leds.led2On();
		while (1);
	}
}
