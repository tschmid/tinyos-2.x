configuration HplSam3uTwiP {
  provides interface HplSam3uTwi;
  provides interface HplSam3uTwiInterrupt;
}

implementation {

  components HplSam3uTwiImplP as HplTwiP;
  HplSam3uTwi = HplTwiP;
  HplSam3uTwiInterrupt = HplTwiP;

  // make and connect pins/clock/interrupt for this dude
  components HplNVICC, HplSam3uClockC, HplSam3uGeneralIOC, LedsC, NoLedsC;
  HplTwiP.Twi0Interrupt -> HplNVICC.TWI0Interrupt;
  HplTwiP.Twi1Interrupt -> HplNVICC.TWI1Interrupt;
  HplTwiP.Twi0ClockControl -> HplSam3uClockC.TWI0PPCntl;
  HplTwiP.Twi1ClockControl -> HplSam3uClockC.TWI1PPCntl;
  HplTwiP.Twd0Pin -> HplSam3uGeneralIOC.HplPioA9;
  HplTwiP.Twd1Pin -> HplSam3uGeneralIOC.HplPioA24;
  HplTwiP.Twck0Pin -> HplSam3uGeneralIOC.HplPioA10;
  HplTwiP.Twck1Pin -> HplSam3uGeneralIOC.HplPioA25;
  HplTwiP.Leds -> NoLedsC;  
}
