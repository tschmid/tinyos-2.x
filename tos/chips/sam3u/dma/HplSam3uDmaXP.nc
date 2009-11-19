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

generic module HplSam3uDmaXP(uint8_t DMACHANNEL) {

  provides interface HplSam3uDmaChannel as Dma;
  uses interface HplSam3uDmaInterrupt as Interrupt;
  uses interface Leds;
}

implementation {

  uint32_t CHANNEL_OFFSET = 0x3C + (DMACHANNEL * 0x28);

  async event void Interrupt.fired(){
    // Disable channel and send signal up
    signal Dma.transferDone(SUCCESS);
  }

  async command void Dma.setSrcAddr(void* src_addr){
    volatile dmac_saddrx_t *SADDRX = (volatile dmac_saddrx_t *)(0x400B0000 + CHANNEL_OFFSET);
    dmac_saddrx_t saddrx = *SADDRX;
    saddrx.bits.saddrx = (uint32_t) src_addr;
    *SADDRX = saddrx;
  }

  async command void Dma.setDstAddr(void* dst_addr){
    volatile dmac_daddrx_t *DADDRX = (volatile dmac_daddrx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x4);
    dmac_daddrx_t daddrx = *DADDRX;
    daddrx.bits.daddrx = (uint32_t) dst_addr;
    *DADDRX = daddrx;
  }

  async command void Dma.setBtsize(uint16_t btsize){
    /*Done*/
    volatile dmac_ctrlax_t *CTRLAX = (volatile dmac_ctrlax_t *)(0x400B0000 + CHANNEL_OFFSET + 0xC);
    dmac_ctrlax_t ctrlax = *CTRLAX;
    ctrlax.bits.btsize = btsize;
    *CTRLAX = ctrlax;
  }

  async command void Dma.setScsize(dmac_chunk_t scsize){
    /*Done*/
    volatile dmac_ctrlax_t *CTRLAX = (volatile dmac_ctrlax_t *)(0x400B0000 + CHANNEL_OFFSET + 0xC);
    dmac_ctrlax_t ctrlax = *CTRLAX;
    ctrlax.bits.scsize = scsize;
    *CTRLAX = ctrlax;
  }

  async command void Dma.setDcsize(dmac_chunk_t dcsize){
    /*Done*/
    volatile dmac_ctrlax_t *CTRLAX = (volatile dmac_ctrlax_t *)(0x400B0000 + CHANNEL_OFFSET + 0xC);
    dmac_ctrlax_t ctrlax = *CTRLAX;
    ctrlax.bits.dcsize = dcsize;
    *CTRLAX = ctrlax;
  }

  async command void Dma.setSrcWidth(dmac_width_t src_width){
    /*Done*/
    volatile dmac_ctrlax_t *CTRLAX = (volatile dmac_ctrlax_t *)(0x400B0000 + CHANNEL_OFFSET + 0xC);
    dmac_ctrlax_t ctrlax = *CTRLAX;
    ctrlax.bits.src_width = src_width;
    *CTRLAX = ctrlax;
  }

  async command void Dma.setDstWidth(dmac_width_t dst_width){
    /*Done*/
    volatile dmac_ctrlax_t *CTRLAX = (volatile dmac_ctrlax_t *)(0x400B0000 + CHANNEL_OFFSET + 0xC);
    dmac_ctrlax_t ctrlax = *CTRLAX;
    ctrlax.bits.dst_width = dst_width;
    *CTRLAX = ctrlax;
  }

  async command void Dma.setFc(dmac_fc_t fc){
    /*Done*/
    volatile dmac_ctrlbx_t *CTRLBX = (volatile dmac_ctrlbx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x10);
    dmac_ctrlbx_t ctrlbx = *CTRLBX;
    ctrlbx.bits.fc = fc;
    *CTRLBX = ctrlbx;
  }

  async command void Dma.setSrcDscr(dmac_dscr_t src_dscr){
    /*Done*/
    volatile dmac_ctrlbx_t *CTRLBX = (volatile dmac_ctrlbx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x10);
    dmac_ctrlbx_t ctrlbx = *CTRLBX;
    ctrlbx.bits.src_dscr = src_dscr;
    *CTRLBX = ctrlbx;
  }

  async command void Dma.setDstDscr(dmac_dscr_t dst_dscr){
    /*Done*/
    volatile dmac_ctrlbx_t *CTRLBX = (volatile dmac_ctrlbx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x10);
    dmac_ctrlbx_t ctrlbx = *CTRLBX;
    ctrlbx.bits.dst_dscr = dst_dscr;
    *CTRLBX = ctrlbx;
  }

  async command void Dma.setSrcInc(dmac_inc_t src_inc){
    /*Done*/
    volatile dmac_ctrlbx_t *CTRLBX = (volatile dmac_ctrlbx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x10);
    dmac_ctrlbx_t ctrlbx = *CTRLBX;
    ctrlbx.bits.src_incr = src_inc;
    *CTRLBX = ctrlbx;
  }

  async command void Dma.setDstInc(dmac_inc_t dst_inc){
    /*Done*/
    volatile dmac_ctrlbx_t *CTRLBX = (volatile dmac_ctrlbx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x10);
    dmac_ctrlbx_t ctrlbx = *CTRLBX;
    ctrlbx.bits.dst_incr = dst_inc;
    *CTRLBX = ctrlbx;
  }

  async command void Dma.setSrcPer(uint8_t src_per){
    /*Done*/
    volatile dmac_cfgx_t *CFGX = (volatile dmac_cfgx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x14);
    dmac_cfgx_t cfgx = *CFGX;
    cfgx.bits.src_per = src_per;
    *CFGX = cfgx;
  }

  async command void Dma.setDstPer(uint8_t dst_per){
    /*Done*/
    volatile dmac_cfgx_t *CFGX = (volatile dmac_cfgx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x14);
    dmac_cfgx_t cfgx = *CFGX;
    cfgx.bits.dst_per = dst_per;
    *CFGX = cfgx;
  }

  async command void Dma.setSrcHandshake(bool swhandshake){
    /*Done*/
    volatile dmac_cfgx_t *CFGX = (volatile dmac_cfgx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x14);
    dmac_cfgx_t cfgx = *CFGX;
    if(swhandshake == TRUE){
      cfgx.bits.src_h2sel = 0;
    }else{
      cfgx.bits.src_h2sel = 1;
    }
    *CFGX = cfgx;
  }

  async command void Dma.setDstHandshake(bool swhandshake){
    /*Done*/
    volatile dmac_cfgx_t *CFGX = (volatile dmac_cfgx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x14);
    dmac_cfgx_t cfgx = *CFGX;
    if(swhandshake == TRUE){
      cfgx.bits.src_h2sel = 0;
    }else{
      cfgx.bits.src_h2sel = 1;
    }
    *CFGX = cfgx;
  }

  async command void Dma.setSOD(){
    /*Done*/
    volatile dmac_cfgx_t *CFGX = (volatile dmac_cfgx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x14);
    dmac_cfgx_t cfgx = *CFGX;
    cfgx.bits.lock_b = 1;
    *CFGX = cfgx;
  }

  async command void Dma.clrSOD(){
    /*Done*/
    volatile dmac_cfgx_t *CFGX = (volatile dmac_cfgx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x14);
    dmac_cfgx_t cfgx = *CFGX;
    cfgx.bits.sod = 0;
    *CFGX = cfgx;
  }

  async command void Dma.setLockIF(){
    /*Done*/
    volatile dmac_cfgx_t *CFGX = (volatile dmac_cfgx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x14);
    dmac_cfgx_t cfgx = *CFGX;
    cfgx.bits.lock_if = 1;
    *CFGX = cfgx;
  }

  async command void Dma.clrLockIF(){
    /*Done*/
    volatile dmac_cfgx_t *CFGX = (volatile dmac_cfgx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x14);
    dmac_cfgx_t cfgx = *CFGX;
    cfgx.bits.lock_if = 0;
    *CFGX = cfgx;
  }

  async command void Dma.setLockB(){    
    /*Done*/
    volatile dmac_cfgx_t *CFGX = (volatile dmac_cfgx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x14);
    dmac_cfgx_t cfgx = *CFGX;
    cfgx.bits.lock_b = 1;
    *CFGX = cfgx;
  }

  async command void Dma.clrLockB(){
    /*Done*/
    volatile dmac_cfgx_t *CFGX = (volatile dmac_cfgx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x14);
    dmac_cfgx_t cfgx = *CFGX;
    cfgx.bits.lock_b = 0;
    *CFGX = cfgx;
  }

  async command void Dma.setLockIFL(dmac_IFL_t lockIFL){
    /*Done*/
    volatile dmac_cfgx_t *CFGX = (volatile dmac_cfgx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x14);
    dmac_cfgx_t cfgx = *CFGX;
    cfgx.bits.lock_if_l = lockIFL;
    *CFGX = cfgx;
  }

  async command void Dma.setAhbprot(dmac_ahbprot_t ahbprot){
    /*DONE*/
    volatile dmac_cfgx_t *CFGX = (volatile dmac_cfgx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x14);
    dmac_cfgx_t cfgx = *CFGX;
    cfgx.bits.ahb_prot = ahbprot;
    *CFGX = cfgx;
  }

  async command void Dma.setFifoCfg(dmac_fifocfg_t fifocfg){
    /*DONE*/
    volatile dmac_cfgx_t *CFGX = (volatile dmac_cfgx_t *)(0x400B0000 + CHANNEL_OFFSET + 0x14);
    dmac_cfgx_t cfgx = *CFGX;
    cfgx.bits.fifocfg = fifocfg;
    *CFGX = cfgx;
  }
  
  async command void Dma.enable(){
    /*DONE!*/
    volatile dmac_en_t *EN = (volatile dmac_en_t *) 0x400B0004;
    dmac_en_t en = *EN;
    en.bits.enable = 1;
    call Leds.led1Toggle();
    *EN = en;
  }

  async command void Dma.disable(uint8_t channel){
    volatile dmac_en_t *EN = (volatile dmac_en_t *) 0x400B0004;
    dmac_en_t en = *EN;
    volatile dmac_chdr_t *CHDR = (volatile dmac_chdr_t *) 0x400B002C;
    dmac_chdr_t chdr = *CHDR;
    switch(DMACHANNEL){
    case 0:
      chdr.bits.dis0 = 0;
    case 1:
      chdr.bits.dis1 = 0;
    case 2:
      chdr.bits.dis2 = 0;
    case 3:
      chdr.bits.dis3 = 0;
    default:
      chdr.bits.dis0 = 0;      
    }

    en.bits.enable = 0;

    *CHDR = chdr;
    *EN = en;
  }

  async command void Dma.enableChannel(uint8_t channel){
    /*DONE!*/
    volatile dmac_sreq_t *SREQ = (volatile dmac_sreq_t *) 0x400B0008;
    dmac_sreq_t sreq = *SREQ;
    volatile dmac_creq_t *CREQ = (volatile dmac_creq_t *) 0x400B000C;
    dmac_creq_t creq = *CREQ;
    volatile dmac_cher_t *CHER = (volatile dmac_cher_t *) 0x400B0028;
    dmac_cher_t cher = *CHER;
    switch(DMACHANNEL){
    case 0:
      //sreq.bits.ssreq0 = 1;
      //sreq.bits.dsreq0 = 1;
      creq.bits.screq0 = 1;
      creq.bits.dcreq0 = 1;
      cher.bits.ena0 = 1;
    case 1:
      //sreq.bits.ssreq1 = 1;
      //sreq.bits.dsreq1 = 1;
      creq.bits.screq1 = 1;
      creq.bits.dcreq1 = 1;
      cher.bits.ena1 = 1;
    case 2:
      //sreq.bits.ssreq2dash = 1;
      //sreq.bits.dsreq2dash = 1;
      creq.bits.screq2dash = 1;
      creq.bits.dcreq2dash = 1;
      cher.bits.ena2 = 1;
    case 3:
      //sreq.bits.ssreq3 = 1;
      //sreq.bits.dsreq3 = 1;
      creq.bits.screq3 = 1;
      creq.bits.dcreq3 = 1;
      cher.bits.ena3 = 1;
    default:
      //sreq.bits.ssreq0 = 1;
      //sreq.bits.dsreq0 = 1;
      creq.bits.screq0 = 1;
      creq.bits.dcreq0 = 1;
      cher.bits.ena0 = 1;      
    }
    *CHER = cher;
    *SREQ = sreq;
  }

  async command void Dma.enableChannelInterrupt(uint8_t channel){
    volatile dmac_ebcier_t *EBCIER = (volatile dmac_ebcier_t *) 0x400B0018;
    dmac_ebcier_t ebcier = *EBCIER;
    switch(DMACHANNEL){
    case 0:    
      ebcier.bits.btc0 = 1;
      ebcier.bits.err0 = 1;
    case 1:    
      ebcier.bits.btc1 = 1;
      ebcier.bits.err1 = 1;
    case 2:    
      ebcier.bits.btc2 = 1;
      ebcier.bits.err2 = 1;
    case 3:    
      ebcier.bits.btc3 = 1;
      ebcier.bits.err3 = 1;
    }
    *EBCIER = ebcier;
  }

  async command void Dma.reset(){
  }
}