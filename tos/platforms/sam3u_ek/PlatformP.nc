#include "hardware.h"

module PlatformP
{
    provides
	{
        interface Init;
    }
	uses
	{
		interface Init as LedsInit;
	}
}

implementation
{
	command error_t Init.init()
	{
		/* I/O pin configuration, clock calibration, and LED configuration
		 * (see TEP 107)
		 */
		call LedsInit.init();

		return SUCCESS;
	}

	default command error_t LedsInit.init()
	{
		return SUCCESS;
	}
}
