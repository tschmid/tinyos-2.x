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

#include "sam3uDmahardware.h"
#include <color.h>
#include <lcd.h>

module HplSam3uDmaP {

  provides interface HplSam3uDmaControl as DmaControl;
  provides interface HplSam3uDmaInterrupt as Interrupt;
  uses interface HplNVICInterruptCntl as HDMAInterrupt;
  uses interface Leds;
  uses interface Lcd;
  uses interface Draw;
}

implementation {

  event void Lcd.initializeDone(error_t err)
  {
    /*
    call Draw.fill(COLOR_GREEN);
    call Lcd.start();
    */
  }

  event void Lcd.startDone(){}

  task void draw(){
    volatile uint32_t *temp = (volatile uint32_t *) 0x400B0000;
    call Draw.fill(COLOR_BLUE);
    call Draw.drawInt(100,100,*temp,1,COLOR_BLACK);
  }

  async command error_t DmaControl.init(){
    call HDMAInterrupt.disable();
    call HDMAInterrupt.configure(IRQ_PRIO_DMAC);
    call HDMAInterrupt.enable();
    return SUCCESS;
  }

  async command error_t DmaControl.setRoundRobin(){
    volatile dmac_gcfg_t *GCFG = (volatile dmac_gcfg_t *) 0x400B0000;
    dmac_gcfg_t gcfg = *GCFG;
    gcfg.bits.arb_cfg = 1;
    *GCFG = gcfg;
    //post draw();
    return SUCCESS;
  }

  async command error_t DmaControl.setFixedPriority(){
    volatile dmac_gcfg_t *GCFG = (volatile dmac_gcfg_t *) 0x400B0000;
    dmac_gcfg_t gcfg = *GCFG;
    gcfg.bits.arb_cfg = 0;
    *GCFG = gcfg;
    //post draw();
    return SUCCESS;
  }

  async command void DmaControl.reset(){
    
  }

  void DmacIrqHandler() @C() @spontaneous() {
    call Leds.led0Toggle();
    signal Interrupt.fired();
  }

}
