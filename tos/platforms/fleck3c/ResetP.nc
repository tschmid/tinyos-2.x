/**
 * @author  Brano Kusy
 */

#include <avr/wdt.h>

module ResetP {
	provides interface Init;
  provides interface Reset;
}

implementation {

  command error_t Init.init() {
    // disable watchdog (if accidentally left on)
#ifndef TOSSIM
		wdt_reset();
    MCUSR = 0;
    wdt_disable();
#endif
		return SUCCESS;
  }

  command void Reset.reset() {
#ifndef TOSSIM
		cli();
    // enable watchdog
    wdt_enable(WDTO_1S);
    // enter infinite loop
    while(1);
#endif
  }

}
