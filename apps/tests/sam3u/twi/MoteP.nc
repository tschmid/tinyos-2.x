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
 * @author JeongGil Ko
 */

#include "sam3utwihardware.h"
#include <color.h>
#include <lcd.h>

module MoteP
{
  uses {
    interface Boot;
    interface Leds;
    //interface ReadNow<uint16_t>;
    interface I2CPacket<TI2CBasicAddr> as TWI;
    interface Resource;
    interface SplitControl as SerialSplitControl;
    interface Packet;
    interface Timer<TMilli>;
    interface Lcd;
    interface Draw;
    interface ResourceConfigure;
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

  task void sample()
  {
    const char *start = "Resource Request!";
    call Draw.fill(COLOR_BLUE);
    call Draw.drawString(10,50,start,COLOR_BLACK);
    call Resource.request();
  }

  event void Lcd.startDone(){
    post sample();
    call Timer.startPeriodic(1024);
  }


  event void SerialSplitControl.startDone(error_t error)
  {
    if (error != SUCCESS) {
      while (call SerialSplitControl.start() != SUCCESS);
    }
  }
  
  event void SerialSplitControl.stopDone(error_t error) {}
  
  volatile twi_mmr_t* MMR = (volatile twi_mmr_t *) (TWI0_BASE_ADDR + 0x4);
  volatile twi_cwgr_t* CWGR = (volatile twi_cwgr_t *) (TWI0_BASE_ADDR + 0x10);

  uint8_t temp;

  task void read(){
    const char *start = "Read!!";
    //call Leds.led0Toggle();

    call Draw.fill(COLOR_WHITE);
    call Draw.drawString(10,50,start,COLOR_BLACK);

    call ResourceConfigure.configure();
    call TWI.read(0, 0x48, 1, &temp);

    call Draw.drawInt(180,70,MMR->bits.dadr,1,COLOR_BLUE);
    call Draw.drawInt(180,90,MMR->bits.mread,1,COLOR_BLUE);
    call Draw.drawInt(180,110,CWGR->bits.cldiv,1,COLOR_BLUE);
  }

  event void Resource.granted(){
    post read();
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

  async event void TWI.writeDone(error_t error, uint16_t addr, uint8_t length, uint8_t* data){}

  //async event void TWI.readDone(error_t error, uint16_t value)
  async event void TWI.readDone(error_t error, uint16_t addr, uint8_t length, uint8_t* data)
  {
    post drawResult();
  }
  
  event void Timer.fired() {
    post read();
  }
}
