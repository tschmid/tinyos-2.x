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
configuration HplSam3uTCC
{

    provides
    {
        interface HplSam3uTCChannel  as TC0;
        interface HplSam3uTCChannel  as TC1;
        interface HplSam3uTCChannel  as TC2;

        interface HplSam3uTCCapture  as TC0CaptureA;
        interface HplSam3uTCCapture  as TC0CaptureB;
        interface HplSam3uTCCcompare as TC0CCompareA;
        interface HplSam3uTCCcompare as TC0CCompareB;
        interface HplSam3uTCCcompare as TC0CCompareC;

        interface HplSam3uTCCapture  as TC1CaptureA;
        interface HplSam3uTCCapture  as TC1CaptureB;
        interface HplSam3uTCCcompare as TC1CCompareA;
        interface HplSam3uTCCcompare as TC1CCompareB;
        interface HplSam3uTCCcompare as TC1CCompareC;
        
        interface HplSam3uTCCapture  as TC2CaptureA;
        interface HplSam3uTCCapture  as TC2CaptureB;
        interface HplSam3uTCCcompare as TC2CCompareA;
        interface HplSam3uTCCcompare as TC2CCompareB;
        interface HplSam3uTCCcompare as TC2CCompareC;
    }
}

implementation
{
    components 
        new HplSam3uTCChannelP(TC_CH0_BASE) as TCCH0,
        new HplSam3uTCChannelP(TC_CH1_BASE) as TCCH1,
        new HplSam3uTCChannelP(TC_CH2_BASE) as TCCH2,
        new HplNVICC;

    TC0 = TCCH0;
    TC1 = TCCH1;
    TC2 = TCCH2;

    TCCH0.NVICTCInterrupt -> HplNVICC.TC0Interrupt;

    TCCH1.NVICTCInterrupt -> HplNVICC.TC1Interrupt;

    TCCH2.NVICTCInterrupt -> HplNVICC.TC2Interrupt;

    TC0CaptureA  = TCCH0.CaptureA; 
    TC0CaptureB  = TCCH0.CaptureB;
    TC0CCompareA = TCCH0.CompareA;
    TC0CCompareB = TCCH0.CompareB;
    TC0CCompareC = TCCH0.CompareC;

    TC1CaptureA  = TCCH1.CaptureA; 
    TC1CaptureB  = TCCH1.CaptureB;
    TC1CCompareA = TCCH1.CompareA;
    TC1CCompareB = TCCH1.CompareB;
    TC1CCompareC = TCCH1.CompareC;

    TC2CaptureA  = TCCH2.CaptureA; 
    TC2CaptureB  = TCCH2.CaptureB;
    TC2CCompareA = TCCH2.CompareA;
    TC2CCompareB = TCCH2.CompareB;
    TC2CCompareC = TCCH2.CompareC;
}
