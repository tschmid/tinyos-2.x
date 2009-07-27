#include "hardware.h"

module PlatformP
{
    provides
	{
        interface Init;
    }
}

implementation
{
	command error_t Init.init()
	{
		/* I/O pin configuration, clock calibration, and LED configuration
		 * (see TEP 107)
		 */

        return SUCCESS;
    }
}
