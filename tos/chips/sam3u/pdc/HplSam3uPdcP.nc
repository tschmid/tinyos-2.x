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

#include "sam3updchardware.h"

generic module HplSam3uPdcP(uint32_t BASE_ADDR){
  provides interface HplSam3uPdc as Pdc;
}

implementation{

  uint32_t PDC_BASE_ADDR = (BASE_ADDR + 0x100);

  command void Pdc.setRxPtr(void* addr){
    volatile periph_rpr_t* RPR = (volatile periph_rpr_t*) (PDC_BASE_ADDR + 0x0);
    periph_rpr_t rpr;
    rpr.bits.rxptr = (uint32_t)addr;
    *RPR = rpr;
  }

  command void Pdc.setTxPtr(void* addr){
    volatile periph_tpr_t* TPR = (volatile periph_tpr_t*) (PDC_BASE_ADDR + 0x8);
    periph_tpr_t tpr;
    tpr.bits.txptr = (uint32_t)addr;
    *TPR = tpr;
  }

  command void Pdc.setNextRxPtr(void* addr){
    volatile periph_rnpr_t* RNPR = (volatile periph_rnpr_t*) (PDC_BASE_ADDR + 0x10);
    periph_rnpr_t rnpr;
    rnpr.bits.rxnptr = (uint32_t)addr;
    *RNPR = rnpr;
  }

  command void Pdc.setNextTxPtr(void* addr){
    volatile periph_tnpr_t* TNPR = (volatile periph_tnpr_t*) (PDC_BASE_ADDR + 0x18);
    periph_tnpr_t tnpr;
    tnpr.bits.txnptr = (uint32_t)addr;
    *TNPR = tnpr;
  }

  command void Pdc.setRxCounter(uint16_t counter){
    volatile periph_rcr_t* RCR = (volatile periph_rcr_t*) (PDC_BASE_ADDR + 0x4);
    periph_rcr_t rcr;
    rcr.bits.rxctr = counter;
    *RCR = rcr;
  }
  command void Pdc.setTxCounter(uint16_t counter){
    volatile periph_tcr_t* TCR = (volatile periph_tcr_t*) (PDC_BASE_ADDR + 0xC);
    periph_tcr_t tcr;
    tcr.bits.txctr = counter;
    *TCR = tcr;
  }

  command void Pdc.setNextRxCounter(uint16_t counter){
    volatile periph_rncr_t* RNCR = (volatile periph_rncr_t*) (PDC_BASE_ADDR + 0x14);
    periph_rncr_t rncr;
    rncr.bits.rxnctr = counter;
    *RNCR = rncr;
  }

  command void Pdc.setNextTxCounter(uint16_t counter){
    volatile periph_tncr_t* TNCR = (volatile periph_tncr_t*) (PDC_BASE_ADDR + 0x1C);
    periph_tncr_t tncr;
    tncr.bits.txnctr = counter;
    *TNCR = tncr;
  }

  command void Pdc.enablePdcRx(){
    volatile periph_ptcr_t* PTCR = (volatile periph_ptcr_t*) (PDC_BASE_ADDR + 0x20);
    periph_ptcr_t ptcr;
    ptcr.bits.rxten = 1;
    *PTCR = ptcr;
  }

  command void Pdc.enablePdcTx(){
    volatile periph_ptcr_t* PTCR = (volatile periph_ptcr_t*) (PDC_BASE_ADDR + 0x20);
    periph_ptcr_t ptcr;
    ptcr.bits.txten = 1;
    *PTCR = ptcr;
  }
  command void Pdc.disablePdcRx(){
    volatile periph_ptcr_t* PTCR = (volatile periph_ptcr_t*) (PDC_BASE_ADDR + 0x20);
    periph_ptcr_t ptcr;
    ptcr.bits.rxtdis = 1;
    *PTCR = ptcr;
  }
  command void Pdc.disablePdcTx(){
    volatile periph_ptcr_t* PTCR = (volatile periph_ptcr_t*) (PDC_BASE_ADDR + 0x20);
    periph_ptcr_t ptcr;
    ptcr.bits.txtdis = 1;
    *PTCR = ptcr;
  }

  command bool Pdc.rxEnabled(){
    volatile periph_ptsr_t* PTSR = (volatile periph_ptsr_t*) (PDC_BASE_ADDR + 0x24);
    periph_ptsr_t ptsr = *PTSR;
    if(ptsr.bits.rxten){
      return TRUE;
    }else{
      return FALSE;
    }
  }

  command bool Pdc.txEnabled(){
    volatile periph_ptsr_t* PTSR = (volatile periph_ptsr_t*) (PDC_BASE_ADDR + 0x24);
    periph_ptsr_t ptsr = *PTSR;
    if(ptsr.bits.txten){
      return TRUE;
    }else{
      return FALSE;
    }
  }

}