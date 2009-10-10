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
module TestLcdC
{
	uses
    {
        interface Timer<TMilli> as ChangeTimer;
        interface Leds;
        interface Boot;

        interface Lcd;
        interface Draw;
    }
}
implementation
{
    enum {
        RED,
        GREEN,
        BLUE,
        WHITE,
    };
    uint8_t state;

	event void Boot.booted()
	{
        state = RED;

        call Lcd.initialize();
	}

    async event void Lcd.initializeDone(error_t err)
    {
        if(err != SUCCESS)
        {
            call Leds.led1On();
        }
        else
        {
            call Draw.fill(COLOR_RED);
            call Lcd.start();
        }
    }

    async event void Lcd.startDone()
    {
        call Leds.led0On();
        call ChangeTimer.startPeriodic(1024);
    }

    event void ChangeTimer.fired()
    {
        switch(state)
        {
            case RED:
                call Draw.fill(COLOR_RED);
                state = GREEN;
                break;
            case GREEN:
                call Draw.fill(COLOR_GREEN);
                state = BLUE;
                break;
            case BLUE:
                call Draw.fill(COLOR_BLUE);
                state = WHITE;
                break;
            case WHITE:
                call Draw.fill(COLOR_WHITE);
                state = RED;
                break;
        }

    }
}
