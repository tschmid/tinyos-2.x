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

module TestAlarmTMicroP
{
	uses
    {
        interface Leds;
        interface Boot;

        interface Lcd;
        interface Draw;

        interface Alarm<TMicro,uint32_t>;

        interface HplSam3uTCChannel as HilCounter;
    }
}
implementation
{
    uint32_t delta = 1e6;

	event void Boot.booted()
	{
        call Lcd.initialize();
	}

    event void Lcd.initializeDone(error_t err)
    {
        if(err != SUCCESS)
        {
            call Leds.led0On();
            call Leds.led1On();
            call Leds.led2On();
        }
        else
        {
            call Draw.fill(COLOR_WHITE);
            call Lcd.start();
        }
    }

    event void Lcd.startDone()
    {
        uint32_t now = call Alarm.getNow();

        call Leds.led0Off();
        call Leds.led1Off();
        call Leds.led2Off();


        call Draw.fill(COLOR_WHITE);
        call Draw.drawString(10, 10, "AlarmTest:", COLOR_BLACK);
        call Draw.drawString(10, 50, "Now: ", COLOR_BLACK);
        call Draw.drawInt(BOARD_LCD_WIDTH-20, 50, now, 1, COLOR_BLACK);
        call Draw.drawString(10, 70, "Alarm: ", COLOR_BLACK);
        call Draw.drawInt(BOARD_LCD_WIDTH-20, 70, now+delta, 1, COLOR_BLACK);

        call Draw.drawString(10, 110, "Frequency kHz:", COLOR_BLACK);
        call Draw.drawInt(BOARD_LCD_WIDTH-20, 130, call HilCounter.getTimerFrequency(), 1, COLOR_BLACK);
   
        call Alarm.startAt(now, delta);
    }


    async event void Alarm.fired()
    {
        uint32_t now = call Alarm.getNow();

        call Draw.fill(COLOR_WHITE);
        call Draw.drawString(10, 10, "AlarmTest:", COLOR_BLACK);
        call Draw.drawString(10, 50, "Now: ", COLOR_BLACK);
        call Draw.drawInt(BOARD_LCD_WIDTH-20, 50, now, 1, COLOR_BLACK);
        call Draw.drawString(10, 70, "Err: ", COLOR_BLACK);
        call Draw.drawInt(BOARD_LCD_WIDTH-20, 70, now - call Alarm.getAlarm(), 1, COLOR_BLACK);
        call Draw.drawString(10, 90, "Next: ", COLOR_BLACK);
        call Draw.drawInt(BOARD_LCD_WIDTH-20, 90, now+delta, 1, COLOR_BLACK);

        call Draw.drawString(10, 110, "Frequency kHz:", COLOR_BLACK);
        call Draw.drawInt(BOARD_LCD_WIDTH-20, 130, call HilCounter.getTimerFrequency(), 1, COLOR_BLACK);
   
        call Alarm.startAt(now, delta);
    }

    async event void HilCounter.overflow() {}

}
