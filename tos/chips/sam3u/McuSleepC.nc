#include "hardware.h"

module McuSleepC {
	provides interface McuSleep;
	provides interface McuPowerState;
} implementation {
	async command void McuSleep.sleep() {
		__nesc_enable_interrupt();
		// Enter sleep here
		__nesc_disable_interrupt();
	}
	async command void McuPowerState.update() { }
}
