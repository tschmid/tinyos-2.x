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

configuration TestRestoreTcbAppC
{
}
implementation
{
	components MainC, TestRestoreTcbC, LedsC;
#ifdef PLATFORM_SAM3U_EK
	components new ThreadC(0x200) as Thread0;
	components new ThreadC(0x200) as Thread1;
	components new ThreadC(0x200) as Thread2;
#else
	components new ThreadC(100) as Thread0;
	components new ThreadC(100) as Thread1;
	components new ThreadC(100) as Thread2;
#endif

	TestRestoreTcbC -> MainC.Boot;
	TestRestoreTcbC.Leds -> LedsC;
	TestRestoreTcbC.Thread0 -> Thread0;
	TestRestoreTcbC.Thread1 -> Thread1;
	TestRestoreTcbC.Thread2 -> Thread2;
}
