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
 * Basic application that displays the current clock speed on the LCD.
 *
 * @author Thomas Schmid
 **/

configuration ClockSpeedAppC
{
}
implementation
{
	components MainC, ClockSpeedC, LedsC;

	ClockSpeedC -> MainC.Boot;
	ClockSpeedC.Leds -> LedsC;

    components LcdC;
    ClockSpeedC.Lcd -> LcdC;
    ClockSpeedC.Draw -> LcdC;

    components HplSam3uClockC;

    ClockSpeedC.HplSam3uClock -> HplSam3uClockC;

    components HplSam3uGeneralIOC;
    ClockSpeedC.Pck0Pin -> HplSam3uGeneralIOC.HplPioA21;

    components new TimerMilliC() as T1;
    ClockSpeedC.ChangeTimer -> T1;
}
