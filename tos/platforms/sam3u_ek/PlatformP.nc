/*
 * Copyright (c) 2009 Stanford University.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Stanford University nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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
        interface Init as MoteClockInit;
	}
}

implementation
{
	command error_t Init.init()
	{
		/* I/O pin configuration, clock calibration, and LED configuration
		 * (see TEP 107)
		 */
        // Stop UTMI
        AT91C_BASE_CKGR->CKGR_UCKR &= ~AT91C_CKGR_UPLLEN;

        // Configure all PIO as input
        // Set PIO as Input
        AT91C_BASE_PIOA->PIO_ODR = 0xFFFFFFFF;
        AT91C_BASE_PIOB->PIO_ODR = 0xFFFFFFFF;
        AT91C_BASE_PIOC->PIO_ODR = 0xFFFFFFFF;
        // Enable PIO
        AT91C_BASE_PIOA->PIO_PER = 0xFFFFFFFF;
        AT91C_BASE_PIOB->PIO_PER = 0xFFFFFFFF;
        AT91C_BASE_PIOC->PIO_PER = 0xFFFFFFFF;
        // stop all peripheral clocks
        AT91C_BASE_PMC->PMC_PCDR = MASK_STATUS;
        while((AT91C_BASE_PMC->PMC_PCSR & MASK_STATUS) != 0);


        call MoteClockInit.init();
		call LedsInit.init();

		return SUCCESS;
	}

	default command error_t LedsInit.init()
	{
		return SUCCESS;
	}
}
