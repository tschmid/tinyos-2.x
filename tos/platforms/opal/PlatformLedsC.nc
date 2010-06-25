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

/*
 * Connection of LEDs to the GPIO pins on the opal platform.
 *
 * @author Kevin Klues <Kevin.Klues@csiro.au>
 */

configuration PlatformLedsC
{
	provides
	{
		interface GeneralIO as Led0;
		interface GeneralIO as Led1;
		interface GeneralIO as Led2;
	}
	uses
	{
		interface Init;
	}
}
implementation
{
	components HplSam3uGeneralIOC as IO;
	components PlatformP;

	Init = PlatformP.LedsInit;

	// Flip the IO pins so they are active High
	components new FlippedGeneralIOC() as Led0Pin;
	components new FlippedGeneralIOC() as Led1Pin;
	components new FlippedGeneralIOC() as Led2Pin;
	Led0Pin.In -> IO.PioC6; // Pin C6 = Red LED, active high
	Led1Pin.In -> IO.PioC7; // Pin C7 = Green LED, active high
	Led2Pin.In -> IO.PioC8; // Pin C8 = Yellow LED, active high

	Led0 = Led0Pin.Out;
	Led1 = Led1Pin.Out;
	Led2 = Led2Pin.Out;
}

