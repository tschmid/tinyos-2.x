#include "hardware.h"

configuration PlatformC
{
	provides
	{
		/* Called after platform_bootstrap() and Scheduler.init() (see TEP 107)
		 * I/O pin configuration, clock calibration, and LED configuration */
		interface Init;
	}
}

implementation
{
	components PlatformP;

	Init = PlatformP;
}
