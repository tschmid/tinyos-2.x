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
 * SPI Configuration for the SAM3U-EK devkit. Does not use DMA (PDC) at this
 * point. Byte interface performs busy wait!
 *
 * @author Thomas Schmid
 */

configuration HilSam3uSpiC
{
    provides
    {
        interface StdControl;
        interface Resource;
        interface SpiByte;
        interface SpiPacket;
	interface FastSpiByte;
        interface GeneralIO as CSN;
    }
}
implementation
{
    components HilSam3uSpiP;
    StdControl = HilSam3uSpiP;
    SpiByte = HilSam3uSpiP;
    SpiPacket = HilSam3uSpiP;
    
    // the simulated FastSpiByte
    components FastSpiSam3uC;
    FastSpiSam3uC.SpiByte -> HilSam3uSpiP.SpiByte;
    FastSpiByte = FastSpiSam3uC;

    components HplSam3uSpiC;
    HilSam3uSpiP.HplSam3uSpiConfig -> HplSam3uSpiC;
    HilSam3uSpiP.HplSam3uSpiControl -> HplSam3uSpiC;
    HilSam3uSpiP.HplSam3uSpiInterrupts -> HplSam3uSpiC;
    HilSam3uSpiP.HplSam3uSpiStatus -> HplSam3uSpiC;
    HilSam3uSpiP.HplSam3uSpiChipSelConfig -> HplSam3uSpiC.HplSam3uSpiChipSelConfig1;
    Resource = HplSam3uSpiC.ResourceCS1;
    CSN = HplSam3uSpiC.CSN1;

    components MainC;
    MainC.SoftwareInit -> HilSam3uSpiP.Init;

    components HplNVICC;
    HilSam3uSpiP.SpiIrqControl -> HplNVICC.SPI0Interrupt;

    components HplSam3uGeneralIOC;
    HilSam3uSpiP.SpiPinMiso -> HplSam3uGeneralIOC.HplPioA13;
    HilSam3uSpiP.SpiPinMosi -> HplSam3uGeneralIOC.HplPioA14;
    HilSam3uSpiP.SpiPinSpck -> HplSam3uGeneralIOC.HplPioA15;
    HilSam3uSpiP.SpiPinNPCS -> HplSam3uGeneralIOC.HplPioC3;

    components HplSam3uClockC;
    HilSam3uSpiP.SpiClockControl -> HplSam3uClockC.SPI0PPCntl;
    HilSam3uSpiP.ClockConfig -> HplSam3uClockC;
}
