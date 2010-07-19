// configuration file
#include <sam3uhsmcihardware.h>

configuration HplSam3uHsmciC {
  provides interface HplSam3uHsmciInterrupt;
  provides interface HplSam3uHsmci;
}
implementation {
  components HplSam3uHsmciP, LedsC,
    HplNVICC, HplSam3uClockC, HplSam3uGeneralIOC;

  HplSam3uHsmci = HplSam3uHsmciP;
  HplSam3uHsmciInterrupt = HplSam3uHsmciP;



  HplSam3uHsmciP.HSMCIInterrupt -> HplNVICC.MCI0Interrupt;

  HplSam3uHsmciP.HSMCIPinMCCDA -> HplSam3uGeneralIOC.HplPioA4;
  HplSam3uHsmciP.HSMCIPinMCCK -> HplSam3uGeneralIOC.HplPioA3;
  HplSam3uHsmciP.HSMCIPinMCDA0 -> HplSam3uGeneralIOC.HplPioA5;
  HplSam3uHsmciP.HSMCIPinMCDA1 -> HplSam3uGeneralIOC.HplPioA6;
  HplSam3uHsmciP.HSMCIPinMCDA2 -> HplSam3uGeneralIOC.HplPioA7;
  HplSam3uHsmciP.HSMCIPinMCDA3 -> HplSam3uGeneralIOC.HplPioA8;
  HplSam3uHsmciP.HSMCIPinMCDA4 -> HplSam3uGeneralIOC.HplPioC28;
  HplSam3uHsmciP.HSMCIPinMCDA5 -> HplSam3uGeneralIOC.HplPioC29;
  HplSam3uHsmciP.HSMCIPinMCDA6 -> HplSam3uGeneralIOC.HplPioC30;
  HplSam3uHsmciP.HSMCIPinMCDA7 -> HplSam3uGeneralIOC.HplPioC31;

  HplSam3uHsmciP.HSMCIClockControl -> HplSam3uClockC.MCI0PPCntl;
  //HplSam3uHsmciP.HSMCIClockControl -> HplSam3uClockC.HSMC4PPCntl;

  HplSam3uHsmciP.Leds -> LedsC;
}
