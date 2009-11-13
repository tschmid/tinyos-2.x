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
 * Simple test program for SAM3U's 12 bit ADC ReadStream with LCD
 * @author Chieh-Jan Mike Liang
 * @author JeongGil Ko
 */

#include <color.h>
#include <lcd.h>

#define SAMPLE_BUFFER_SIZE 10000
#define NUM_SAMPLES_PER_PACKET (TOSH_DATA_LENGTH / sizeof(uint16_t))

module MoteP
{
  uses {
    interface Boot;
    interface Leds;
    interface ReadStream<uint16_t>;
    interface SplitControl as SerialSplitControl;
    interface Packet;
    interface Timer<TMilli>;
    interface Lcd;
    interface Draw;
  }
}

implementation
{
  uint16_t buf[SAMPLE_BUFFER_SIZE];

  task void clear(){
    /* Reset the target buffer for the ReadStream interface */
    uint32_t i;
    for (i = 0; i < SAMPLE_BUFFER_SIZE; i++) {
      buf[i] = 0xFFFF;
    }
  }

  event void Boot.booted()
  {
    post clear();
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
  }

  event void SerialSplitControl.startDone(error_t error)
  {
    if (error != SUCCESS) {
      while (call SerialSplitControl.start() != SUCCESS);
    }else{
      call Timer.startPeriodic(5*1024U);
    }
  }
  
  event void SerialSplitControl.stopDone(error_t error) {}

  task void sample()
  {
    const char *start = "Start Sampling";
    call Draw.fill(COLOR_BLUE);
    call Draw.drawString(10,50,start,COLOR_RED);
 
    call ReadStream.postBuffer(buf, SAMPLE_BUFFER_SIZE);
    call ReadStream.read(100);
  }

  event void ReadStream.readDone(error_t result, uint32_t usActualPeriod)
  {
    if (result != SUCCESS) {
    }else{
    }
  }

  event void ReadStream.bufferDone(error_t result, uint16_t* buffer, uint16_t count) {
    const char *fail = "Read done error";
    const char *good = "Read done success";
    call Leds.led1Toggle();
    call Draw.fill(COLOR_GREEN);
    if (result != SUCCESS) {
      call Draw.drawString(10,70,fail,COLOR_BLACK);
    }else{
      call Draw.drawString(10,70,good,COLOR_BLACK);
      call Draw.drawInt(100,100,buffer[0],1,COLOR_BLACK);
      call Draw.drawInt(100,160,count,1,COLOR_BLACK);
    }
  }

  event void Timer.fired() {
    call Leds.led0Toggle();
    post clear();
    post sample();
  }
}
