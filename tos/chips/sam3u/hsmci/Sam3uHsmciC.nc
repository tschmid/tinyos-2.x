// configuration file

#include <sam3uhsmcihardware.h>

configuration Sam3uHsmciC {
  provides interface Sam3uHsmci;
}
implementation {
  components Sam3uHsmciP;
  components HplSam3uHsmciC;
  components LedsC;

  Sam3uHsmci = Sam3uHsmciP;

  Sam3uHsmciP.HplHsmci -> HplSam3uHsmciC;
  Sam3uHsmciP.HplHsmciInterrupt -> HplSam3uHsmciC;
  Sam3uHsmciP.Leds -> LedsC;
}
