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

module TestLcdC
{
	uses
    {
        interface Timer<TMilli> as ChangeTimer;
        interface Leds;
        interface Boot;

        interface Random;

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
        STRING,
        RAND,
    };
    uint8_t state;
    uint8_t backgrnd;

	event void Boot.booted()
	{
        state = RED;
        backgrnd = 0;

        call Lcd.initialize();
	}

    event void Lcd.initializeDone(error_t err)
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

    event void Lcd.startDone()
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
                state = STRING;
                break;
            case STRING: 
                {
                    const char *hi = "Hello World";
                    const char *l1 = "I am running";
                    const char *l2 = "the SAM3U port";
                    const char *l3 = "of TinyOS!";
                    const char *l4 = "wiki.github.com/";
                    const char *l5 = "tschmid/tinyos-2.x";

                    call ChangeTimer.stop();
                    call Draw.fill(COLOR_WHITE);
                
                    call Draw.drawString(10, 50, hi, COLOR_RED);
                    call Draw.drawString(10, 70, l1, COLOR_ORANGE);
                    call Draw.drawString(10, 90, l2, COLOR_BLUE);
                    call Draw.drawString(10, 110, l3, COLOR_NAVY);
                    call Draw.drawString(10, 170, l4, COLOR_BLACK);
                    call Draw.drawString(10, 190, l5, COLOR_BLACK);
                    call Draw.drawInt(BOARD_LCD_WIDTH-20, 210, 123456789L, 1, COLOR_BLACK);
                    call Draw.drawInt(BOARD_LCD_WIDTH-20, 230, 987654321L, -1, COLOR_BLACK);

                    call ChangeTimer.startOneShot(10000);

                    state = RAND;
                    break;
                }
            case RAND:
                {
                    uint32_t x;


                    for (x=0; x<10*BOARD_LCD_WIDTH*BOARD_LCD_HEIGHT; x++)
                    {
                        uint32_t r = call Random.rand32();

                        call Draw.drawPixel((r & 0x0000FFFF)%BOARD_LCD_WIDTH, ((r >> 16) & 0x0000FFFF)%BOARD_LCD_HEIGHT, r%COLOR_WHITE);
                    }
                    call ChangeTimer.startPeriodic(1024);

                    state = RED;
                    break;

                }
        }

    }
}
