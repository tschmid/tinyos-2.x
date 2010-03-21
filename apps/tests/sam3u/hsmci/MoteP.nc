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

#include "sam3uhsmcihardware.h"
#include <color.h>
#include <lcd.h>

module MoteP
{
  uses {
    interface Boot;
    interface Leds;
    //interface Resource;
    interface SplitControl as SerialSplitControl;
    interface Packet;
    interface Timer<TMilli>;
    interface Lcd;
    interface Draw;
    interface Sam3uHsmci as HSMC;
    interface HplSam3uPeripheralClockCntl as HSMCIClockControl;
  }
}

implementation
{
  norace error_t resultError;
  norace uint32_t resultValue;
  uint8_t temp[4];
  uint8_t tempWrite[2];// = 0x60606060; // for 12bit resolution on temp sensor
  uint16_t tempWriteLimit = 0x4680;

  uint32_t READBUFF[128];
  uint32_t WRITEBUFF[128];
  uint8_t state;

  volatile hsmci_rdr_t *RDR = (volatile hsmci_rdr_t *) 0x40000030;
  hsmci_rdr_t rdr;
    volatile hsmci_sr_t *SR = (volatile hsmci_sr_t *) 0x40000040;

  event void Boot.booted()
  {
    uint8_t i;
    for (i=0;i<128;i++){
      READBUFF[i] = 0xF;
      WRITEBUFF[i] = 20000+(i+1)*30;
    }
    state = 1;
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

  task void plotInitResults(){
    volatile hsmci_wpmr_t *WPMR = (volatile hsmci_wpmr_t *) 0x400000E4;
    volatile hsmci_ier_t *IER = (volatile hsmci_ier_t *) 0x40000044;
    volatile hsmci_imr_t *IMR = (volatile hsmci_imr_t *) 0x4000004C;
    volatile hsmci_argr_t *ARGR = (volatile hsmci_argr_t *) 0x40000010;
    volatile hsmci_cr_t *CR = (volatile hsmci_cr_t *) 0x40000000;
    volatile hsmci_mr_t *MR = (volatile hsmci_mr_t *) 0x40000004;
    volatile hsmci_dtor_t *DTOR = (volatile hsmci_dtor_t *) 0x40000008;
    volatile hsmci_cmdr_t *CMDR = (volatile hsmci_cmdr_t *) 0x40000014;

    call Draw.drawInt(50,90,ARGR->bits.arg,1,COLOR_BLACK);
    call Draw.drawInt(50,110,IMR->bits.cmdrdy,1,COLOR_BLACK);

    call Draw.drawInt(30,170,SR->bits.cmdrdy,1,COLOR_BLACK);
    call Draw.drawInt(50,170,SR->bits.rinde,1,COLOR_BLACK);
    call Draw.drawInt(70,170,SR->bits.rdire,1,COLOR_BLACK);
    call Draw.drawInt(90,170,SR->bits.rcrce,1,COLOR_BLACK);
    call Draw.drawInt(110,170,SR->bits.rende,1,COLOR_BLACK);
    call Draw.drawInt(130,170,SR->bits.rtoe,1,COLOR_BLACK);
    /*
    call Draw.drawInt(100,190,RESPONSE_PTR[0],1,COLOR_BLACK);
    call Draw.drawInt(100,210,RESPONSE_PTR[1],1,COLOR_BLACK);
    call Draw.drawInt(100,230,RESPONSE_PTR[2],1,COLOR_BLACK);
    call Draw.drawInt(100,250,RESPONSE_PTR[3],1,COLOR_BLACK);
    */
    call Draw.drawInt(130,190,HSMCI->rspr[0].bits.rsp,1,COLOR_BLACK);
    //call Draw.drawInt(130,210,HSMCI->rspr[1].bits.rsp,1,COLOR_BLACK);
    //call Draw.drawInt(130,230,HSMCI->rspr[2].bits.rsp,1,COLOR_BLACK);
    //call Draw.drawInt(130,250,HSMCI->rspr[3].bits.rsp,1,COLOR_BLACK);
    
    call Draw.drawInt(180,190,DEBUG[0],1,COLOR_BLACK);
    call Draw.drawInt(150,210,DEBUG[1],1,COLOR_BLACK);
    call Draw.drawInt(150,230,DEBUG[2],1,COLOR_BLACK);
    call Draw.drawInt(150,250,DEBUG[3],1,COLOR_BLACK);
    call Draw.drawInt(150,270,DEBUG[4],1,COLOR_BLACK);
    call Draw.drawInt(150,290,DEBUG[5],1,COLOR_BLACK);

    call Draw.drawInt(200,190,DEBUG[6],1,COLOR_BLACK);
    call Draw.drawInt(200,170,DEBUG[7],1,COLOR_BLACK);
    call Draw.drawInt(200,150,DEBUG[8],1,COLOR_BLACK);
    call Draw.drawInt(200,130,DEBUG[9],1,COLOR_BLACK);

    call Draw.drawInt(30,270,DTOR->bits.dtocyc,1,COLOR_BLACK);
    call Draw.drawInt(70,270,DTOR->bits.dtomul,1,COLOR_BLACK);
  }

  task void sample()
  {
    error_t err;

    const char *start = "Test HSMCI!";
    call Draw.fill(COLOR_BLUE);
    call Draw.drawString(10,50,start,COLOR_BLACK);

    DEBUG[5] = 0xFF;
    DEBUG[4] = 0xFF;
    DEBUG[3] = 0xFF;
    DEBUG[1] = 0xFF;

    err = call HSMC.init();

    if(err == SUCCESS){
      //err = call HSMC.setBlockSize(512);
    }

  }

  event void Lcd.startDone(){
    post sample();
    call Timer.startPeriodic(1024U);
  }

  event void SerialSplitControl.startDone(error_t error)
  {
    if (error != SUCCESS) {
      while (call SerialSplitControl.start() != SUCCESS);
    }
  }
  
  event void SerialSplitControl.stopDone(error_t error) {}
  
  task void read(){
  }

  task void drawResult(){
  }

  task void callRead(){
    call HSMC.readBlock(0, READBUFF);
  }


  event void HSMC.writeBlockDone(uint32_t *writebuffer){
    //call Leds.led0Toggle();
    //DEBUG[9] = READBUFF[0];
    //DEBUG[8] = READBUFF[1];
    call Leds.led2Toggle();
    state = 0;
    //call HSMC.readBlock(0, READBUFF);
    call HSMC.init();
    //post plotInitResults();
    //post callRead();
  }

  event void HSMC.readBlockDone(uint32_t *readbuffer){
    call Leds.led2Toggle();
    memcpy(READBUFF, readbuffer, 128);
    DEBUG[9] = READBUFF[100];
    DEBUG[8] = READBUFF[101];
    DEBUG[5] = RDR->bits.data;
    post plotInitResults();
  }

  uint8_t count = 0;

  event void HSMC.initDone(error_t error){
    //DEBUG[3] = RDR->bits.data;
    if(error == SUCCESS){
      count ++;
      if(count > 1){
	DEBUG[5] = 112;
	call HSMC.setBlockSize(512);
      }else{
	call HSMC.init();
      }
    }else{
      DEBUG[4] = 111;
      call HSMC.init();      
      DEBUG[8] = 0xFF;
    }
  }

  event void HSMC.lengthConfigDone(error_t error){
    //post plotInitResults();
    //call HSMC.readBlock(0, READBUFF);
    //call HSMC.writeBlock(0, WRITEBUFF);
    if(state){
      call HSMC.writeBlock(0, WRITEBUFF);
    }else{
      call HSMC.readBlock(0, READBUFF);
    }
  }
  
  event void Timer.fired() {
    //post read();
  }
}
