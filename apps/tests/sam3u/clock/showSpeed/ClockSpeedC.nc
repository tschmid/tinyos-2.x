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
 * @author Thomas Schmid
 **/

#include <color.h>
#include <lcd.h>
#include <sam3upmchardware.h>

module ClockSpeedC
{
	uses
    {
        interface Leds;
        interface Boot;

        interface HplSam3uClock;

        interface HplSam3uGeneralIOPin as Pck0Pin;

        interface Timer<TMilli> as ChangeTimer;

        interface Lcd;
        interface Draw;
    }
}
implementation
{
    uint8_t state;
    uint8_t speed;

    enum {
        SLOW = 0,
        MAIN = 1,
        PLLA = 2,
        MASTER = 4,
    };

    enum {
        RC12,
        MC48,
        MC84,
    };

	event void Boot.booted()
	{
        pmc_pck_t pck0 = PMC->pck0;
        pmc_scer_t scer = PMC->scer;

        state = SLOW;
        speed = RC12;

        // output slow clock on PCK0
        pck0.bits.css = SLOW;
        PMC->pck0 = pck0;

        scer.bits.pck0 = 1;
        PMC->scer = scer;

        call Lcd.initialize();

        call Pck0Pin.disablePioControl();
        call Pck0Pin.selectPeripheralB(); // output programmable clock 0 on pin
	}

    event void Lcd.initializeDone(error_t err)
    {
        if(err != SUCCESS)
        {
            call Leds.led1On();
        }
        else
        {
            call Draw.fill(COLOR_WHITE);
            call Lcd.start();
        }
    }

    event void Lcd.startDone()
    {
        call Leds.led0On();
        call Draw.drawString(10, 10, "Init Clock:", COLOR_BLACK);
        call Draw.drawInt(BOARD_LCD_WIDTH-20, 30, call HplSam3uClock.getMainClockSpeed(), 1, COLOR_BLACK);
        call HplSam3uClock.mckInit84();
        call ChangeTimer.startPeriodic(10000);
    }

    event void ChangeTimer.fired()
    {
        pmc_pck_t pck0 = PMC->pck0;
        call Draw.fill(COLOR_WHITE);

        call Draw.drawString(10, 50, "MCK Speed:", COLOR_BLACK);
        call Draw.drawInt(BOARD_LCD_WIDTH-20, 70, call HplSam3uClock.getMainClockSpeed(), 1, COLOR_BLACK);

        switch(state)
        {
            case SLOW:
                pck0.bits.css = state;
                PMC->pck0 = pck0;
                call Draw.drawString(10, 90, "Slow Clock on PA21", COLOR_BLACK);
                state = MAIN;
                break;
            case MAIN:
                pck0.bits.css = state;
                PMC->pck0 = pck0;
                call Draw.drawString(10, 90, "Main Clock on PA21", COLOR_BLACK);
                state = PLLA;
                break;
            case PLLA:
                pck0.bits.css = state;
                PMC->pck0 = pck0;
                call Draw.drawString(10, 90, "PLLA Clock on PA21", COLOR_BLACK);
                state = MASTER;
                break;
            case MASTER:
                pck0.bits.css = state;
                PMC->pck0 = pck0;
                call Draw.drawString(10, 90, "Master Clock on PA21", COLOR_BLACK);
                state = SLOW;
                switch(speed)
                {
                    case RC12:
                        call Draw.drawString(10, 10, "RC12 Clock:", COLOR_BLACK);
                        call HplSam3uClock.mckInit12RC();
                        speed = MC48;
                        break;
                    case MC48:
                        call Draw.drawString(10, 10, "MC48 Clock:", COLOR_BLACK);
                        call HplSam3uClock.mckInit84();
                        speed = MC84;
                        break;
                    case MC84:
                        call Draw.drawString(10, 10, "MC84 Clock:", COLOR_BLACK);
                        call HplSam3uClock.mckInit48();
                        speed = RC12;
                        break;
                }
                break;
        }
    }

    async event void HplSam3uClock.mainClockChanged()
    {
    }
}
