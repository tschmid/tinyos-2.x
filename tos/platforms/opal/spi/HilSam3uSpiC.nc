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
        interface Resource[uint8_t];
        interface SpiByte[uint8_t];
	interface FastSpiByte[uint8_t];
        interface SpiPacket[uint8_t];
	interface HplSam3uSpiChipSelConfig[uint8_t];
    }
    uses {
        interface Init as SpiChipInit[uint8_t];
    }
}
implementation
{
    components MainC;
    components HilSam3uSpiP;
    components HplSam3uSpiC;
    MainC.SoftwareInit -> HilSam3uSpiP.Init;
    StdControl = HilSam3uSpiP;
    HilSam3uSpiP.ArbiterInfo -> HplSam3uSpiC;
    MainC.SoftwareInit = SpiChipInit[0];
    MainC.SoftwareInit = SpiChipInit[1];
    MainC.SoftwareInit = SpiChipInit[2];
    MainC.SoftwareInit = SpiChipInit[3];

    Resource[0] = HplSam3uSpiC.ResourceCS0;
    Resource[1] = HplSam3uSpiC.ResourceCS1;
    Resource[2] = HplSam3uSpiC.ResourceCS2;
    Resource[3] = HplSam3uSpiC.ResourceCS3;

    SpiByte[0] = HilSam3uSpiP.SpiByte[0];
    SpiByte[1] = HilSam3uSpiP.SpiByte[1];
    SpiByte[2] = HilSam3uSpiP.SpiByte[2];
    SpiByte[3] = HilSam3uSpiP.SpiByte[3];

    // the simulated FastSpiByte
    components new FastSpiSam3uC() as FSpi0;
    components new FastSpiSam3uC() as FSpi1;
    components new FastSpiSam3uC() as FSpi2;
    components new FastSpiSam3uC() as FSpi3;
    FSpi0.SpiByte -> HilSam3uSpiP.SpiByte[0];
    FSpi1.SpiByte -> HilSam3uSpiP.SpiByte[1];
    FSpi2.SpiByte -> HilSam3uSpiP.SpiByte[2];
    FSpi3.SpiByte -> HilSam3uSpiP.SpiByte[3];
    FastSpiByte[0] = FSpi0;
    FastSpiByte[1] = FSpi1;
    FastSpiByte[2] = FSpi2;
    FastSpiByte[3] = FSpi3;

    SpiPacket[0] = HilSam3uSpiP.SpiPacket[0];
    SpiPacket[1] = HilSam3uSpiP.SpiPacket[1];
    SpiPacket[2] = HilSam3uSpiP.SpiPacket[2];
    SpiPacket[3] = HilSam3uSpiP.SpiPacket[3];

    HplSam3uSpiChipSelConfig[0] =  HplSam3uSpiC.HplSam3uSpiChipSelConfig0;
    HplSam3uSpiChipSelConfig[1] =  HplSam3uSpiC.HplSam3uSpiChipSelConfig1;
    HplSam3uSpiChipSelConfig[2] =  HplSam3uSpiC.HplSam3uSpiChipSelConfig2;
    HplSam3uSpiChipSelConfig[3] =  HplSam3uSpiC.HplSam3uSpiChipSelConfig3;
    
    HilSam3uSpiP.HplSam3uSpiConfig -> HplSam3uSpiC;
    HilSam3uSpiP.HplSam3uSpiControl -> HplSam3uSpiC;
    HilSam3uSpiP.HplSam3uSpiStatus -> HplSam3uSpiC;
    HilSam3uSpiP.HplSam3uSpiInterrupts -> HplSam3uSpiC;

    components HplSam3uGeneralIOC;
    HilSam3uSpiP.SpiPinMiso -> HplSam3uGeneralIOC.HplPioA13;
    HilSam3uSpiP.SpiPinMosi -> HplSam3uGeneralIOC.HplPioA14;
    HilSam3uSpiP.SpiPinSpck -> HplSam3uGeneralIOC.HplPioA15;

    components HplNVICC;
    HilSam3uSpiP.SpiIrqControl -> HplNVICC.SPI0Interrupt;

    components HplSam3uClockC;
    HilSam3uSpiP.SpiClockControl -> HplSam3uClockC.SPI0PPCntl;
    HilSam3uSpiP.ClockConfig -> HplSam3uClockC;
}
