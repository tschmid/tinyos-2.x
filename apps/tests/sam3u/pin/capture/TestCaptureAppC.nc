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
 * Basic application that tests the SAM3U Captures. Connect a switch to PA1
 * and watch the LCD for rising/falling time measurements. 
 *
 * @author Thomas Schmid
 **/

configuration TestCaptureAppC
{
}
implementation
{
	components MainC, TestCaptureC, LedsC, LcdC;

	TestCaptureC -> MainC.Boot;
	TestCaptureC.Leds -> LedsC;
    TestCaptureC.Lcd -> LcdC;
    TestCaptureC.Draw -> LcdC;

    components HplSam3uGeneralIOC as GeneralIOC;
    components HplSam3uTCC;
    components new GpioCaptureC() as CaptureSFDC;

    CaptureSFDC.TCCapture -> HplSam3uTCC.TC0Capture;
    CaptureSFDC.GeneralIO -> GeneralIOC.HplPioA1;

    TestCaptureC.Capture -> CaptureSFDC;
    TestCaptureC.SFD -> GeneralIOC.PioA1;

    components new Alarm32khz32C();

    TestCaptureC.InitAlarm -> Alarm32khz32C;
    TestCaptureC.Alarm32 -> Alarm32khz32C;

}
