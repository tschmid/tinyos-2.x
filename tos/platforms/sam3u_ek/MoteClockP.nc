/**
 * "Copyright (c) 2009 The Regents of the University of California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement
 * is hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
 * OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 * Basic Clock Initialization.
 *
 * @author Thomas Schmid
 */

#include "AT91SAM3U4.h"
#include "sam3upmchardware.h"
#include "sam3usupchardware.h"
#include "sam3ueefchardware.h"

// Define clock timeout
#define CLOCK_TIMEOUT           0xFFFFFFFF

extern void SetDefaultMaster(unsigned char enable);
extern void SetFlashWaitState(unsigned char ws);


module MoteClockP
{
    provides {
        interface Init;
    }
}

implementation
{
    //------------------------------------------------------------------------------
    /// After POR, at91sam3u device is running on 4MHz internal RC
    /// At the end of the LowLevelInit procedure MCK = 48MHz PLLA = 96 CPU=48MHz
    /// Performs the low-level initialization of the chip. This includes EFC, master
    /// clock, IRQ & watchdog configuration.
    //------------------------------------------------------------------------------

    command error_t Init.init(){
        pmc_mor_t mor;
        pmc_pllar_t pllar;
        uint32_t timeout = 0;

        // Set 2 WS for Embedded Flash Access
        EEFC0->fmr.bits.fws = 2;
        EEFC1->fmr.bits.fws = 2;

        // Watchdog initialization
        AT91C_BASE_WDTC->WDTC_WDMR = AT91C_WDTC_WDDIS;

        // Select external slow clock
        if(SUPC->sr.bits.oscsel == 0) 
        {
            supc_cr_t cr;
            cr.flat = 0; // assure it is all zero!
            cr.bits.xtalsel = 1;
            cr.bits.key = SUPC_CR_KEY;

            SUPC->cr = cr;
            //AT91C_BASE_SUPC->SUPC_CR = AT91C_SUPC_CR_XTALSEL_CRYSTAL_SEL | (0xA5 << 24);
            timeout = 0;
            //while (!(AT91C_BASE_SUPC->SUPC_SR & AT91C_SUPC_SR_OSCSEL_CRYST) && (timeout++ < CLOCK_TIMEOUT));
            while (!(SUPC->sr.bits.oscsel) && (timeout++ < CLOCK_TIMEOUT));
        }

        /* Initialize main oscillator
         ****************************/
        if(PMC->mor.bits.moscsel == 0)
        {
            mor.flat = 0; // make sure it is zreoed out
            mor.bits.key = PMC_MOR_KEY;
            mor.bits.moscxtst = 0x3F; // main oscillator startup time
            mor.bits.moscrcen = 1;    // enable the on-chip rc oscillator
            mor.bits.moscxten = 1;    // main crystal oscillator enable
            PMC->mor = mor;

            timeout = 0;
            while (!(PMC->sr.bits.moscxts) && (timeout++ < CLOCK_TIMEOUT));
        }

        // Switch to moscsel
        mor.flat = 0; // make sure it is zeroed
        mor.bits.key = PMC_MOR_KEY;
        mor.bits.moscxtst = 0x3F;
        mor.bits.moscrcen = 1;
        mor.bits.moscxten = 1;
        mor.bits.moscsel = 1;
        PMC->mor = mor;
        timeout = 0;
        while (!(PMC->sr.bits.moscsels) && (timeout++ < CLOCK_TIMEOUT));
        PMC->mckr.bits.css = PMC_MCKR_CSS_MAIN_CLOCK;
        timeout = 0;
        while (!(PMC->sr.bits.mckrdy) && (timeout++ < CLOCK_TIMEOUT));

        // Initialize PLLA
        pllar.flat = 0; // make sure it is zeroed out
        pllar.bits.bit29 = 1; // we always have to do this!
        pllar.bits.mula = 0x7;
        pllar.bits.pllacount = 0x3F;
        pllar.bits.diva = 0x1;
        pllar.bits.stmode = PMC_PLLAR_STMODE_FAST_STARTUP;
        PMC->pllar = pllar;
        timeout = 0;
        while (!(PMC->sr.bits.locka) && (timeout++ < CLOCK_TIMEOUT));

        // Switch to fast clock
        PMC->mckr.bits.css = PMC_MCKR_CSS_MAIN_CLOCK;
        timeout = 0;
        while (!(PMC->sr.bits.mckrdy) && (timeout++ < CLOCK_TIMEOUT));

        PMC->mckr.bits.pres = PMC_MCKR_PRES_DIV_2;
        PMC->mckr.bits.css = PMC_MCKR_CSS_PLLA_CLOCK;
        timeout = 0;
        while (!(PMC->sr.bits.mckrdy) && (timeout++ < CLOCK_TIMEOUT));

        // Enable clock for UART
        // FIXME: this should go into the UART start/stop!
        PMC->pcer.bits.dbgu = 1;

        /* Optimize CPU setting for speed */
        SetDefaultMaster(1);

        return SUCCESS;

    }

    //------------------------------------------------------------------------------
    /// Enable or disable default master access
    /// \param enable 1 enable defaultMaster settings, 0 disable it.
    //------------------------------------------------------------------------------
    void SetDefaultMaster(unsigned char enable) @C() @spontaneous()
    {
        AT91PS_HMATRIX2 pMatrix = AT91C_BASE_MATRIX;

        // Set default master
        if (enable == 1) {

            // Set default master: SRAM0 -> Cortex-M3 System
            pMatrix->HMATRIX2_SCFG0 |= AT91C_MATRIX_FIXED_DEFMSTR_SCFG0_ARMS |
                AT91C_MATRIX_DEFMSTR_TYPE_FIXED_DEFMSTR;

            // Set default master: SRAM1 -> Cortex-M3 System
            pMatrix->HMATRIX2_SCFG1 |= AT91C_MATRIX_FIXED_DEFMSTR_SCFG1_ARMS |
                AT91C_MATRIX_DEFMSTR_TYPE_FIXED_DEFMSTR;

            // Set default master: Internal flash0 -> Cortex-M3 Instruction/Data
            pMatrix->HMATRIX2_SCFG3 |= AT91C_MATRIX_FIXED_DEFMSTR_SCFG3_ARMC |
                AT91C_MATRIX_DEFMSTR_TYPE_FIXED_DEFMSTR;
        } else {

            // Clear default master: SRAM0 -> Cortex-M3 System
            pMatrix->HMATRIX2_SCFG0 &= (~AT91C_MATRIX_DEFMSTR_TYPE);

            // Clear default master: SRAM1 -> Cortex-M3 System
            pMatrix->HMATRIX2_SCFG1 &= (~AT91C_MATRIX_DEFMSTR_TYPE);

            // Clear default master: Internal flash0 -> Cortex-M3 Instruction/Data
            pMatrix->HMATRIX2_SCFG3 &= (~AT91C_MATRIX_DEFMSTR_TYPE);
        }
    }

    //------------------------------------------------------------------------------
    /// Set flash wait state
    /// \param ws    Value of flash wait state
    //------------------------------------------------------------------------------
    void SetFlashWaitState(unsigned char ws) @C() @spontaneous()
    {
        // Set Wait State for Embedded Flash Access
        AT91C_BASE_EFC0->EFC_FMR = ((ws << 8) & AT91C_EFC_FWS);
        AT91C_BASE_EFC1->EFC_FMR = ((ws << 8) & AT91C_EFC_FWS);
    }


}

