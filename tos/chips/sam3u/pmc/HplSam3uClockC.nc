/**
 * "Copyright (c) 2009 The Regents of the University of California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreemen
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
 * This is the main configuration for the low-layer clock module.
 *
 * @author Thomas Schmid
 */

configuration HplSam3uClockC
{
    provides
    {
        interface HplSam3uClock;

        interface HplSam3uPeripheralClockCntl as RTCPCCntl   ;
        interface HplSam3uPeripheralClockCntl as RTTPPCntl   ;
        interface HplSam3uPeripheralClockCntl as WDGPPCntl   ;
        interface HplSam3uPeripheralClockCntl as PMCPPCntl   ;
        interface HplSam3uPeripheralClockCntl as EFC0PPCntl  ;
        interface HplSam3uPeripheralClockCntl as EFC1PPCntl  ;
        interface HplSam3uPeripheralClockCntl as DBGUPPCntl  ;
        interface HplSam3uPeripheralClockCntl as HSMC4PPCntl ;
        interface HplSam3uPeripheralClockCntl as PIOAPPCntl  ;
        interface HplSam3uPeripheralClockCntl as PIOBPPCntl  ;
        interface HplSam3uPeripheralClockCntl as PIOCPPCntl  ;
        interface HplSam3uPeripheralClockCntl as US0PPCntl   ;
        interface HplSam3uPeripheralClockCntl as US1PPCntl   ;
        interface HplSam3uPeripheralClockCntl as US2PPCntl   ;
        interface HplSam3uPeripheralClockCntl as US3PPCntl   ;
        interface HplSam3uPeripheralClockCntl as MCI0PPCntl  ;
        interface HplSam3uPeripheralClockCntl as TWI0PPCntl  ;
        interface HplSam3uPeripheralClockCntl as TWI1PPCntl  ;
        interface HplSam3uPeripheralClockCntl as SPI0PPCntl  ;
        interface HplSam3uPeripheralClockCntl as SSC0PPCntl  ;
        interface HplSam3uPeripheralClockCntl as TC0PPCntl   ;
        interface HplSam3uPeripheralClockCntl as TC1PPCntl   ;
        interface HplSam3uPeripheralClockCntl as TC2PPCntl   ;
        interface HplSam3uPeripheralClockCntl as PWMCPPCntl  ;
        interface HplSam3uPeripheralClockCntl as ADC12BPPCntl;
        interface HplSam3uPeripheralClockCntl as ADCPPCntl   ;
        interface HplSam3uPeripheralClockCntl as HDMAPPCntl  ;
        interface HplSam3uPeripheralClockCntl as UDPHSPPCntl ;
    }
}
implementation
{
    components HplSam3uClockP,
               new HplSam3uPeripheralClockP(AT91C_ID_RTC   ) as RTC,
               new HplSam3uPeripheralClockP(AT91C_ID_RTT   ) as RTT,
               new HplSam3uPeripheralClockP(AT91C_ID_WDG   ) as WDG,
               new HplSam3uPeripheralClockP(AT91C_ID_PMC   ) as PMC,
               new HplSam3uPeripheralClockP(AT91C_ID_EFC0  ) as EFC0,
               new HplSam3uPeripheralClockP(AT91C_ID_EFC1  ) as EFC1,
               new HplSam3uPeripheralClockP(AT91C_ID_DBGU  ) as DBGU,
               new HplSam3uPeripheralClockP(AT91C_ID_HSMC4 ) as HSMC4,
               new HplSam3uPeripheralClockP(AT91C_ID_PIOA  ) as PIOA,
               new HplSam3uPeripheralClockP(AT91C_ID_PIOB  ) as PIOB,
               new HplSam3uPeripheralClockP(AT91C_ID_PIOC  ) as PIOC,
               new HplSam3uPeripheralClockP(AT91C_ID_US0   ) as US0,
               new HplSam3uPeripheralClockP(AT91C_ID_US1   ) as US1,
               new HplSam3uPeripheralClockP(AT91C_ID_US2   ) as US2,
               new HplSam3uPeripheralClockP(AT91C_ID_US3   ) as US3,
               new HplSam3uPeripheralClockP(AT91C_ID_MCI0  ) as MCI0,
               new HplSam3uPeripheralClockP(AT91C_ID_TWI0  ) as TWI0,
               new HplSam3uPeripheralClockP(AT91C_ID_TWI1  ) as TWI1,
               new HplSam3uPeripheralClockP(AT91C_ID_SPI0  ) as SPI0,
               new HplSam3uPeripheralClockP(AT91C_ID_SSC0  ) as SSC0,
               new HplSam3uPeripheralClockP(AT91C_ID_TC0   ) as TC0,
               new HplSam3uPeripheralClockP(AT91C_ID_TC1   ) as TC1,
               new HplSam3uPeripheralClockP(AT91C_ID_TC2   ) as TC2,
               new HplSam3uPeripheralClockP(AT91C_ID_PWMC  ) as PWMC,
               new HplSam3uPeripheralClockP(AT91C_ID_ADC12B) as ADC12B,
               new HplSam3uPeripheralClockP(AT91C_ID_ADC   ) as ADC,
               new HplSam3uPeripheralClockP(AT91C_ID_HDMA  ) as HDMA,
               new HplSam3uPeripheralClockP(AT91C_ID_UDPHS ) as UDPHS;

    HplSam3uClock = HplSam3uClockP;

    RTCPCCntl   = RTC.Cntl;
    RTTPPCntl   = RTT.Cntl;
    WDGPPCntl   = WDG.Cntl;
    PMCPPCntl   = PMC.Cntl;
    EFC0PPCntl  = EFC0.Cntl;
    EFC1PPCntl  = EFC1.Cntl;
    DBGUPPCntl  = DBGU.Cntl;
    HSMC4PPCntl = HSMC4.Cntl;
    PIOAPPCntl  = PIOA.Cntl;
    PIOBPPCntl  = PIOB.Cntl;
    PIOCPPCntl  = PIOC.Cntl;
    US0PPCntl   = US0.Cntl;
    US1PPCntl   = US1.Cntl;
    US2PPCntl   = US2.Cntl;
    US3PPCntl   = US3.Cntl;
    MCI0PPCntl  = MCI0.Cntl;
    TWI0PPCntl  = TWI0.Cntl;
    TWI1PPCntl  = TWI1.Cntl;
    SPI0PPCntl  = SPI0.Cntl;
    SSC0PPCntl  = SSC0.Cntl;
    TC0PPCntl   = TC0.Cntl;
    TC1PPCntl   = TC1.Cntl;
    TC2PPCntl   = TC2.Cntl;
    PWMCPPCntl  = PWMC.Cntl;
    ADC12BPPCntl= ADC12B.Cntl;
    ADCPPCntl   = ADC.Cntl;
    HDMAPPCntl  = HDMA.Cntl;
    UDPHSPPCntl = UDPHS.Cntl;
}
