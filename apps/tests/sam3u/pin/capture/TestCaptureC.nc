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

module TestCaptureC
{
	uses 
    {
        interface Leds;
        interface Boot;
        interface Lcd;
        interface Draw;

        interface GpioCapture as Capture;
        interface GeneralIO as SFD;

        interface Init as InitAlarm;
        interface Alarm<T32khz,uint32_t> as Alarm32;
    } 
}
implementation
{
    bool falling;
    uint32_t lastTime;

	event void Boot.booted()
	{
        atomic lastTime = 0;

        call InitAlarm.init();

        call Lcd.initialize();
    }

    event void Lcd.initializeDone(error_t result)
    {
        if(result != SUCCESS)
        {
            call Leds.led0On();
        } else {
            call Draw.fill(COLOR_WHITE);
            call Lcd.start();
        }
    }

    event void Lcd.startDone()
    {
        atomic falling = TRUE;
        call SFD.makeInput();
        call Capture.captureRisingEdge();
        call Draw.drawString(10, 10, "Rising on PA0", COLOR_BLACK);
	}

    async event void Capture.captured(uint16_t time)
    {
        uint32_t now = (call Alarm32.getNow() & 0xFFFF0000L) + time;
        call Draw.fill(COLOR_WHITE);
        call Leds.led0Toggle();

        atomic
        {
            if(falling)
            {
                call Draw.drawString(10, 10, "Rising at:", COLOR_BLACK);
                call Draw.drawInt(BOARD_LCD_WIDTH - 10, 30, now, 1, COLOR_BLACK);
                call Draw.drawString(10, 50, "Since last:", COLOR_BLACK);
                call Draw.drawInt(BOARD_LCD_WIDTH - 10, 70, now-lastTime, 1, COLOR_BLACK);

                falling = FALSE;
                call Capture.captureFallingEdge();
            } else {
                call Draw.drawString(10, 10, "Falling at:", COLOR_BLACK);
                call Draw.drawInt(BOARD_LCD_WIDTH - 10, 30, now, 1, COLOR_BLACK);
                call Draw.drawString(10, 50, "Since last:", COLOR_BLACK);
                call Draw.drawInt(BOARD_LCD_WIDTH - 10, 70, now-lastTime, 1, COLOR_BLACK);

                falling = TRUE;
                call Capture.captureRisingEdge();
            }
            lastTime = now;
        }
    }


    async event void Alarm32.fired() {}


}
