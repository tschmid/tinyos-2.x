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
 * Top level configuration of the timer counter peripheral.
 *
 * @author Thomas Schmid
 */

#include <sam3utchardware.h>

configuration HplSam3uTCC
{

    provides
    {
        interface Init;

        interface HplSam3uTCChannel as TC0;
        interface HplSam3uTCChannel as TC1;
        interface HplSam3uTCChannel as TC2;

        interface HplSam3uTCCapture as TC0Capture;
        interface HplSam3uTCCompare as TC0CompareA;
        interface HplSam3uTCCompare as TC0CompareB;
        interface HplSam3uTCCompare as TC0CompareC;

        interface HplSam3uTCCapture as TC1Capture;
        interface HplSam3uTCCompare as TC1CompareA;
        interface HplSam3uTCCompare as TC1CompareB;
        interface HplSam3uTCCompare as TC1CompareC;
        
        interface HplSam3uTCCapture as TC2Capture;
        interface HplSam3uTCCompare as TC2CompareA;
        interface HplSam3uTCCompare as TC2CompareB;
        interface HplSam3uTCCompare as TC2CompareC;
    }
}

implementation
{
    components HplNVICC,
               HplSam3uTCEventP,
               HplSam3uClockC,
               new HplSam3uTCChannelP( TC_CH0_BASE ) as TCCH0,
               new HplSam3uTCChannelP( TC_CH1_BASE ) as TCCH1,
               new HplSam3uTCChannelP( TC_CH2_BASE ) as TCCH2;

    TC0 = TCCH0;
    TC1 = TCCH1;
    TC2 = TCCH2;

    TCCH0.NVICTCInterrupt -> HplNVICC.TC0Interrupt;
    TCCH0.TimerEvent -> HplSam3uTCEventP.TC0Event;
    TCCH0.TCPClockCntl -> HplSam3uClockC.TC0PPCntl;
    TCCH0.ClockConfig -> HplSam3uClockC;

    TCCH1.NVICTCInterrupt -> HplNVICC.TC1Interrupt;
    TCCH1.TimerEvent -> HplSam3uTCEventP.TC1Event;
    TCCH1.TCPClockCntl -> HplSam3uClockC.TC1PPCntl;
    TCCH1.ClockConfig -> HplSam3uClockC;

    TCCH2.NVICTCInterrupt -> HplNVICC.TC2Interrupt;
    TCCH2.TimerEvent -> HplSam3uTCEventP.TC2Event;
    TCCH2.TCPClockCntl -> HplSam3uClockC.TC2PPCntl;
    TCCH2.ClockConfig -> HplSam3uClockC;

    TC0Capture = TCCH0.Capture; 
    TC0CompareA = TCCH0.CompareA;
    TC0CompareB = TCCH0.CompareB;
    TC0CompareC = TCCH0.CompareC;

    TC1Capture = TCCH1.Capture; 
    TC1CompareA = TCCH1.CompareA;
    TC1CompareB = TCCH1.CompareB;
    TC1CompareC = TCCH1.CompareC;

    TC2Capture = TCCH2.Capture; 
    TC2CompareA = TCCH2.CompareA;
    TC2CompareB = TCCH2.CompareB;
    TC2CompareC = TCCH2.CompareC;

    components HplSam3uTCP;
    Init = HplSam3uTCP;
    HplSam3uTCP.ClockConfig -> HplSam3uClockC;
    HplSam3uTCP.TC0 -> TCCH0;
    HplSam3uTCP.TC2 -> TCCH2;
}
