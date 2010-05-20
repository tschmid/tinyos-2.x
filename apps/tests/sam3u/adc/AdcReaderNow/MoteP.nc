/*
* Copyright (c) 2009 Johns Hopkins University.
* All rights reserved.
*
* Permission to use, copy, modify, and distribute this software and its
* documentation for any purpose, without fee, and without written
* agreement is hereby granted, provided that the above copyright
* notice, the (updated) modification history and the author appear in
* all copies of this source code.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS  `AS IS'
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED  TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR  PURPOSE
* ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR  CONTRIBUTORS
* BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE,  DATA,
* OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR  OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
* THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * Simple test program for SAM3U's 12 bit ADC ReadNow with LCD
 * @author Chieh-Jan Mike Liang
 * @author JeongGil Ko
 */

#include "sam3uDmahardware.h"
#include <color.h>
#include <lcd.h>

module MoteP
{
  uses {
    interface Boot;
    interface Leds;
    interface ReadNow<uint16_t>;
    interface Resource;
    interface SplitControl as SerialSplitControl;
    interface Packet;
    interface Timer<TMilli>;
    interface Lcd;
    interface Draw;
  }
}

implementation
{
  norace error_t resultError;
  norace uint16_t resultValue;

  event void Boot.booted()
  {
    while (call SerialSplitControl.start() != SUCCESS);
    call Lcd.initialize();
  }

  event void Lcd.initializeDone(error_t err)
  {
    if(err != SUCCESS)
      {
      }
    else
      {
        call Draw.fill(COLOR_RED);
        call Lcd.start();
      }
  }

  event void Lcd.startDone(){
    call Timer.startPeriodic(512);
  }


  event void SerialSplitControl.startDone(error_t error)
  {
    if (error != SUCCESS) {
      while (call SerialSplitControl.start() != SUCCESS);
    }
  }
  
  event void SerialSplitControl.stopDone(error_t error) {}
  
  task void sample()
  {
    const char *start = "Start Sampling";
    //call Draw.fill(COLOR_BLUE);
    call Draw.drawString(10,50,start,COLOR_BLACK);
    call Resource.request();
  }

  event void Resource.granted(){
    /* FOR dma testing ONLY*//*
    DMAC->saddr0.bits.saddrx = (uint32_t) 0x20180000;
    call Draw.fill(COLOR_GREEN);
    call Draw.drawInt(100, 100, DMAC->saddr0.bits.saddrx, 1, COLOR_BLACK);
    */
    call ReadNow.read();
  }

  task void drawResult(){
    const char *fail = "Read done error";
    const char *good = "Read done success";
    call Draw.fill(COLOR_GREEN);
    if (resultError != SUCCESS) {
      atomic call Draw.drawString(10,70,fail,COLOR_BLACK);
    }else{
      call Draw.drawString(10,70,good,COLOR_BLACK);
      call Draw.drawInt(100,100,resultValue,1,COLOR_BLACK);
    }
  }

  async event void ReadNow.readDone(error_t error, uint16_t value)
  {
    atomic resultError = error;
    atomic resultValue = value;
    post drawResult();
  }
  
  event void Timer.fired() {
    post sample();
  }
}
