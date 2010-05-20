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
 * Basic application that tests the SAM3U Interrupts. It toggles LED0 and LED1
 * by pushing the "left" and "right" button on the SAM3U EK devkit.
 *
 * @author Thomas Schmid
 **/

configuration TestInterruptAppC
{
}
implementation
{
	components MainC, TestInterruptC, LedsC;

	TestInterruptC -> MainC.Boot;
	TestInterruptC.Leds -> LedsC;

    components HplSam3uGeneralIOC;
    TestInterruptC.GpioInterruptLeft -> HplSam3uGeneralIOC.InterruptPioA18;
    TestInterruptC.ButtonLeft -> HplSam3uGeneralIOC.HplPioA18;
    TestInterruptC.GpioInterruptRight -> HplSam3uGeneralIOC.InterruptPioA19;
    TestInterruptC.ButtonRight -> HplSam3uGeneralIOC.HplPioA19;
}
