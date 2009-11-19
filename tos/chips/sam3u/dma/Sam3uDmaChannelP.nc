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

generic module Sam3uDmaChannelP() {

  provides interface Sam3uDmaChannel as Channel;
  uses interface HplSam3uDmaChannel as DmaChannel;
}

implementation {

  async command error_t Channel.setupTransfer( /*dma_transfer_mode_t transfer_mode,*/
					       uint8_t channel,
					       void *src_addr,
					       void *dst_addr,
					       uint16_t btsize,
					       dmac_chunk_t scsize,
					       dmac_chunk_t dcsize,
					       dmac_width_t src_width,
					       dmac_width_t dst_width,
					       dmac_fc_t fc,
					       dmac_dscr_t src_dscr,
					       dmac_dscr_t dst_dscr,
					       dmac_inc_t src_inc,
					       dmac_inc_t dst_inc,
					       uint8_t src_per,
					       uint8_t dst_per,
					       bool srcSwHandshake,
					       bool dstSwHandshake,
					       bool stopOnDone,
					       bool lockIF,
					       bool lockB,
					       dmac_IFL_t lockIFL,
					       dmac_ahbprot_t ahbprot,
					       dmac_fifocfg_t fifocfg)
  {
    call DmaChannel.setSrcAddr(src_addr);
    call DmaChannel.setDstAddr(dst_addr);
    call DmaChannel.setBtsize(btsize);
    call DmaChannel.setScsize(scsize);
    call DmaChannel.setDcsize(dcsize);
    call DmaChannel.setSrcWidth(src_width);
    call DmaChannel.setDstWidth(dst_width);
    call DmaChannel.setFc(fc);
    call DmaChannel.setSrcDscr(src_dscr);
    call DmaChannel.setDstDscr(dst_dscr);
    call DmaChannel.setSrcInc(src_inc);
    call DmaChannel.setDstInc(dst_inc);
    call DmaChannel.setSrcPer(src_per);
    call DmaChannel.setDstPer(dst_per);

    if(srcSwHandshake){
      call DmaChannel.setSrcHandshake(0);
    }else{
      call DmaChannel.setSrcHandshake(1);
    }

    if(dstSwHandshake){
      call DmaChannel.setDstHandshake(0);
    }else{
      call DmaChannel.setDstHandshake(1);
    }

    if(stopOnDone){
      call DmaChannel.setSOD();
    }else{
      call DmaChannel.clrSOD();
    }

    if(lockIF){
      call DmaChannel.setLockIF();
    }else{
      call DmaChannel.clrLockIF();
    }

    if(lockB){
      call DmaChannel.setLockB();
    }else{
      call DmaChannel.clrLockB();
    }

    call DmaChannel.setLockIFL(lockIFL);
    call DmaChannel.setAhbprot(ahbprot);
    call DmaChannel.setFifoCfg(fifocfg);

    return SUCCESS;

  }

  async command error_t Channel.startTransfer(uint8_t channel)
  {
    call DmaChannel.enableChannelInterrupt(channel);
    call Channel.swTrigger(channel);
    call DmaChannel.enable();
    return SUCCESS;
  }

  async command error_t Channel.repeatTransfer( void *src_addr, void *dst_addr, uint16_t size, uint8_t channel)
  {
    call DmaChannel.setSrcAddr(src_addr);
    call DmaChannel.setDstAddr(dst_addr);
    call DmaChannel.setBtsize(size);    
    return call Channel.startTransfer(channel);
  }

  async command error_t Channel.swTrigger(uint8_t channel)
  {
    call DmaChannel.enableChannel(channel); // start tx!
    return SUCCESS;
  }

  async command error_t Channel.stopTransfer(uint8_t channel)
  {
    /* Check Chapter 40.3.6 */
    //call DmaChannel.readChsrEnable()

  }

  async command error_t Channel.resetAll()
  {
    call DmaChannel.setSrcAddr(0);
    call DmaChannel.setDstAddr(0);
    call DmaChannel.setBtsize(0);
    call DmaChannel.setScsize(0);
    call DmaChannel.setDcsize(0);
    call DmaChannel.setSrcWidth(0);
    call DmaChannel.setDstWidth(0);
    call DmaChannel.setFc(0);
    call DmaChannel.setSrcDscr(1);
    call DmaChannel.setDstDscr(1);
    call DmaChannel.setSrcInc(0);
    call DmaChannel.setDstInc(0);
    call DmaChannel.setSrcPer(0);
    call DmaChannel.setDstPer(0);
    call DmaChannel.setSrcHandshake(0);
    call DmaChannel.setDstHandshake(0);
    call DmaChannel.clrSOD();
    call DmaChannel.setLockIF();
    call DmaChannel.setLockB();
    call DmaChannel.setLockIFL(0);
    call DmaChannel.setAhbprot(1);
    call DmaChannel.setFifoCfg(0);

    return SUCCESS;
  }


  async event void DmaChannel.transferDone(error_t success){
    signal Channel.transferDone(success);
  }

  default async event void Channel.transferDone(error_t success){
  }

}
