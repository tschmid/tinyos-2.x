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

#include "sa3uadc12bhardware.h"
module Sam3uAdc12bImplP
{
  provides {
    interface Init;
    interface Sam3uGetAdc12b as Sam3uAdc12b[uint8_t id];
  }

  uses {
    interface HplNVICInterruptCntl as ADC12BInterrupt;
    interface HplSam3uGeneralIOPin as Adc12bPin;
    interface HplSam3uPeripheralClockCntl as Adc12bClockControl;
    interface HplSam3uClock as ClockConfig;
  }
}

implementation
{

  norace uint8_t clientID;

  norace uint8_t state;

  enum{
    S_ADC,
    S_IDLE,
  };

  command error_t Init.init(){

    /* Enable interrupts */
    call ADC12BInterrupt.configure(IRQ_PRIO_ADC12B); // Peripheral ID 26 for ADC12B
    call ADC12BInterrupt.enable();

    /* Enable clock */
    call Adc12bClockControl.enable();

    /* Set IO line */
    call Adc12bPin.disablePioControl(); // Disable whatever is set currently
    call Adc12bPin.selectPeripheralB(); // set to peripheral B

    state = S_IDLE;

    return SUCCESS;
  }

  async command error_t Sam3uAdc12b.configureAdc[uint8_t id](const sam3u_adc12_channel_config_t *config){
    // channel
    switch(config->channel) {
    case 0:
      ADC12B->cher.bits.ch0 = 1;
      ADC12B->ier.bits.eoc0 = 1;
      break;
    case 1:
      ADC12B->cher.bits.ch1 = 1;
      ADC12B->ier.bits.eoc1 = 1;
      break;
    case 2:
      ADC12B->cher.bits.ch2 = 1;
      ADC12B->ier.bits.eoc2 = 1;
      break;
    case 3:
      ADC12B->cher.bits.ch3 = 1;
      ADC12B->ier.bits.eoc3 = 1;
      break;
    case 4:
      ADC12B->cher.bits.ch4 = 1;
      ADC12B->ier.bits.eoc4 = 1;
      break;
    case 5:
      ADC12B->cher.bits.ch5 = 1;
      ADC12B->ier.bits.eoc5 = 1;
      break;
    case 6:
      ADC12B->cher.bits.ch6 = 1;
      ADC12B->ier.bits.eoc6 = 1;
      break;
    case 7:
      ADC12B->cher.bits.ch7 = 1;
      ADC12B->ier.bits.eoc7 = 1;
      break;
    default:
      ADC12B->cher.bits.ch0 = 0;
      ADC12B->ier.bits.eoc0 = 0;
      break;
    }

    ADC12B->cr.bits.swrst = 0;
    ADC12B->cr.bits.start = 0; // disable start bit for the configuration stage

    ADC12B->mr.bits.prescal = config->prescal;
    ADC12B->mr.bits.shtim = config->shtim;
    ADC12B->mr.bits.lowres = config->lowres;
    ADC12B->mr.bits.trgen = config->trgen;
    ADC12B->mr.bits.trgsel = config->trgsel;
    ADC12B->mr.bits.sleep = config->sleep;
    ADC12B->mr.bits.startup = config->startup;

    ADC12B->acr.bits.ibctl = config->ibctl;
    ADC12B->acr.bits.gain = 0;
    ADC12B->acr.bits.diff = config->diff;
    ADC12B->acr.bits.offset = 0;

    ADC12B->emr.bits.offmodes = 0;
    ADC12B->emr.bits.off_mode_startup_time = config->startup;

    return SUCCESS;
  }

  async command error_t Sam3uAdc12b.getData[uint8_t id](){
    atomic clientID = id;
    if(state != S_IDLE){
      return EBUSY;
    }else{
      ADC12B->cr.bits.start = 1; // enable software trigger
      atomic state = S_ADC;
      return SUCCESS;
    }
  }

  async event void ClockConfig.mainClockChanged(){}

  /* Get events (signals) from chips here! */
  void Adc12BIrqHandler() @C() @spontaneous() {
    uint16_t data = 0;
    if(ADC12B->sr.bits.drdy){
      data = ADC12B->lcdr.bits.ldata;
      ADC12B->cr.bits.start = 0; // disable software trigger
      //get data from register
      atomic state = S_IDLE;
      signal Sam3uAdc12b.dataReady[clientID](data);
    }
  }

  /* Default functions */
 default async event error_t Sam3uAdc12b.dataReady[uint8_t id](uint16_t data){
   return SUCCESS;
 }

}
