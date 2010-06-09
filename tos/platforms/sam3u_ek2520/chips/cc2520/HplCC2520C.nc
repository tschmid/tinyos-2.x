/*
 * Copyright (c) 2010, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Janos Sallai
 * Author: Thomas Schmid (adapted for CC2520)
 */ 

configuration HplCC2520C {
	provides {
		interface Resource as SpiResource;
		interface SpiByte;
		interface SpiPacket;
		interface GeneralIO as CCA;
		interface GeneralIO as CSN;
		interface GeneralIO as FIFO;
		interface GeneralIO as FIFOP;
		interface GeneralIO as RSTN;
		interface GeneralIO as SFD;
		interface GeneralIO as VREN; 
		interface GpioCapture as SfdCapture;	
		interface GpioInterrupt as FifopInterrupt;
		interface LocalTime<TRadio> as LocalTimeRadio;
		//interface Init;		
		interface Alarm<TRadio,uint16_t>;
	}
}
implementation {

	components HilSam3uSpiC as SpiC, HplSam3uGeneralIOC as IO;
	
	//Init = SpiC; 

	SpiResource = SpiC.Resource;
    SpiByte = SpiC;
    SpiPacket = SpiC;
	
	CCA    = IO.PioA17;
	CSN    = IO.PioA19;
	FIFO   = IO.PioA2;
	FIFOP  = IO.PioA0;
	RSTN   = IO.PioC27;
	SFD    = IO.PioA1;
	VREN   = IO.PioC26;	 	
	 	
	components new GpioCaptureC() as SfdCaptureC;
    components HplSam3uTCC;
	SfdCapture = SfdCaptureC;
	SfdCaptureC.TCCapture -> HplSam3uTCC.TC0Capture; 
    SfdCaptureC.GeneralIO -> IO.HplPioA1;

  	FifopInterrupt = IO.InterruptPioA0;

	components LocalTimeMicroC;
	LocalTimeRadio = LocalTimeMicroC.LocalTime; 			 	

	components new AlarmTMicro16C() as AlarmC;
	Alarm = AlarmC; 
	
}
