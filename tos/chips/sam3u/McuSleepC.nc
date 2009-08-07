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
#include "AT91SAM3U4.h"

#define FAST_RC_OSC_4MHZ    ((0x0 << 4) & AT91C_CKGR_MOSCRCF)
#define MASK_STATUS 0x3FFFFFFC

module McuSleepC
{
	provides
	{
		interface McuSleep;
		interface McuPowerState;
	}
}
implementation
{
void SaveWorkingClock(unsigned int *pOldPll, unsigned int *pOldMck) @C() @spontaneous()
{
    // Save previous values for PLL A and Master Clock configuration
    *pOldPll = AT91C_BASE_CKGR->CKGR_PLLAR;
    *pOldMck = AT91C_BASE_PMC->PMC_MCKR;
}
void RestoreWorkingClock(unsigned int oldPll, unsigned int oldMck) @C() @spontaneous()
{
    // Switch to slow clock first
    AT91C_BASE_PMC->PMC_MCKR = (AT91C_BASE_PMC->PMC_MCKR & ~AT91C_PMC_CSS)
        | AT91C_PMC_CSS_SLOW_CLK;
    while (!(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_MCKRDY));

    AT91C_BASE_PMC->PMC_MCKR = (AT91C_BASE_PMC->PMC_MCKR & ~AT91C_PMC_PRES)
        | AT91C_PMC_PRES_CLK;
    while (!(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_MCKRDY));

    // Restart Main Oscillator
    AT91C_BASE_PMC->PMC_MOR = (0x37 << 16) | (0x3F<<8) | AT91C_CKGR_MOSCRCEN | AT91C_CKGR_MOSCXTEN;
    while (!(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_MOSCXTS));
    // Switch to moscsel
    AT91C_BASE_PMC->PMC_MOR = (0x37 << 16) | (0x3F<<8) | AT91C_CKGR_MOSCRCEN | AT91C_CKGR_MOSCXTEN | AT91C_CKGR_MOSCSEL;
    while (!(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_MOSCSELS));

    // Switch to main oscillator
    AT91C_BASE_PMC->PMC_MCKR = (AT91C_BASE_PMC->PMC_MCKR & ~AT91C_PMC_CSS) |
        AT91C_PMC_CSS_MAIN_CLK;
    while (!(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_MCKRDY));

    AT91C_BASE_PMC->PMC_MCKR = (AT91C_BASE_PMC->PMC_MCKR & ~AT91C_PMC_PRES)
        | AT91C_PMC_PRES_CLK;
    while (!(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_MCKRDY));

    // Restart PLL A
    AT91C_BASE_CKGR->CKGR_PLLAR = oldPll;
    while(!(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_LOCKA));

    // Switch to fast clock
    AT91C_BASE_PMC->PMC_MCKR = (oldMck & ~AT91C_PMC_CSS) | AT91C_PMC_CSS_MAIN_CLK;
    while (!(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_MCKRDY));

    AT91C_BASE_PMC->PMC_MCKR = oldMck;
    while (!(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_MCKRDY));
}
//------------------------------------------------------------------------------
/// Configure clock by using Main On-Chip RC Oscillator.
/// \param moscrcf Main On-Chip RC Oscillator Frequency Selection
/// \param pres    Processor Clock Prescaler
//------------------------------------------------------------------------------
void ConfigureClockUsingFastRcOsc(unsigned int moscrcf, unsigned int pres) @C() @spontaneous()
{
    // Enable Fast RC oscillator but DO NOT switch to RC now . Keep MOSCSEL to 1
    AT91C_BASE_PMC->PMC_MOR = AT91C_CKGR_MOSCSEL | (0x37 << 16)
        | AT91C_CKGR_MOSCXTEN | AT91C_CKGR_MOSCRCEN;
    // Wait the Fast RC to stabilize
    while (!(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_MOSCRCS));

    // Switch from Main Xtal osc to Fast RC
    AT91C_BASE_PMC->PMC_MOR = (0x37 << 16) | AT91C_CKGR_MOSCRCEN | AT91C_CKGR_MOSCXTEN ;
    // Wait for Main Oscillator Selection Status bit MOSCSELS
    while (!(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_MOSCSELS));

    // Disable Main XTAL Oscillator
    AT91C_BASE_PMC->PMC_MOR = (0x37 << 16) | AT91C_CKGR_MOSCRCEN;

    // Change frequency of Fast RC oscillator
    AT91C_BASE_PMC->PMC_MOR = (0x37 << 16) | AT91C_BASE_PMC->PMC_MOR | moscrcf;
    // Wait the Fast RC to stabilize
    while (!(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_MOSCRCS));

    // Switch to main clock
    AT91C_BASE_PMC->PMC_MCKR = (AT91C_BASE_PMC->PMC_MCKR & ~AT91C_PMC_CSS)
        | AT91C_PMC_CSS_MAIN_CLK;
    while (!(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_MCKRDY));
    AT91C_BASE_PMC->PMC_MCKR = (AT91C_BASE_PMC->PMC_MCKR & ~AT91C_PMC_PRES)
        | pres;
    while (!(AT91C_BASE_PMC->PMC_SR & AT91C_PMC_MCKRDY));

    // Stop PLL A
    // MULA: PLL A Multiplier 0 = The PLL A is deactivated.
    // STMODE must be set at 2 when the PLLA is Off
    AT91C_BASE_PMC->PMC_PLLAR = 0x2 << 14;
}
void SetWakeUpInputsForFastStartup(unsigned int inputs) @C() @spontaneous()
{
    AT91C_BASE_PMC->PMC_FSMR &= ~0xFFFF;
    AT91C_BASE_PMC->PMC_FSMR |= inputs;
}

	async command void McuSleep.sleep()
	{
        /* Strategy: 
         * - If any of the peripheral clocks is enabled, then go into sleep
         *   mode. Sleep only turns of the CPU clock, and lets the peripheral
         *   clocks untouched.
         * - If all peripheral clocks are disabled, then go into Sleep. This
         *   will also turn off the peripheral clocks.
         */
/*        if (AT91C_BASE_PMC->PMC_PCSR > 0)
        {
            // at least one peripheral clock is enabled
            AT91C_BASE_PMC->PMC_FSMR &= ~AT91C_PMC_LPM;
            AT91C_BASE_NVIC->NVIC_SCR &= ~AT91C_NVIC_SLEEPDEEP;

            asm volatile ("wfi");
        }
        else
        {*/
    unsigned int oldPll;
    unsigned int oldMck;
    unsigned int temp;

    // Save current working clock
    SaveWorkingClock(&oldPll, &oldMck);

    // Stop UTMI
    AT91C_BASE_CKGR->CKGR_UCKR &= ~AT91C_CKGR_UPLLEN;

    // Disable Brownout Detector
    AT91C_BASE_SUPC->SUPC_MR |= (0xA5 << 24) | (0x01 << 13);

    // Configure 4Mhz fast RC oscillator
    ConfigureClockUsingFastRcOsc(FAST_RC_OSC_4MHZ, AT91C_PMC_PRES_CLK);

    // Enter Wait Mode, fast startup from RTT Alarm
    SetWakeUpInputsForFastStartup(1<<16);

            AT91C_BASE_PMC->PMC_FSMR |= AT91C_PMC_LPM;
            AT91C_BASE_NVIC->NVIC_SCR &= ~AT91C_NVIC_SLEEPDEEP;

            asm volatile ("wfe");

    // Restore working clock
    RestoreWorkingClock(oldPll, oldMck);

    // Enable Brownout Detector
    temp = AT91C_BASE_SUPC->SUPC_MR & 0x00FFFFFF;
    AT91C_BASE_SUPC->SUPC_MR = (0xA5 << 24) | (temp & (~(0x01 << 13)));

        //}
	}
	async command void McuPowerState.update()
	{
		// FIXME: implementation
	}
}
