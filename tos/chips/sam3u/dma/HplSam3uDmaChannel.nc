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

interface HplSam3uDmaChannel {

  async command void setSrcAddr(void* src_addr);
  async command void setDstAddr(void* dst_addr);
  async command void setBtsize(uint16_t btsize);
  async command void setScsize(dma_chunk_t scsize);
  async command void setDcsize(dma_chunk_t dcsize);
  async command void setSrcWidth(dma_width_t src_width);
  async command void setDstWidth(dma_width_t dst_width);
  async command void setFc(dma_fc_t fc);
  async command void setSrcDscr(dma_dscr_t src_dscr);
  async command void setDstDscr(dma_dscr_t dst_dscr);
  async command void setSrcInc(dma_inc_t src_inc);
  async command void setDstInc(dma_inc_t dst_inc);
  async command void setSrcPer(uint8_t src_per);
  async command void setDstPer(uint8_t dst_per);
  async command void setSrcHandshake(bool handshake);
  async command void setDstHandshake(bool handshake);
  async command void setSOD();
  async command void clrSOD();
  async command void setLockIF();
  async command void clrLockIF();
  async command void setLockB();
  async command void clrLockB();
  async command void setLockIFL(dma_IFL_t lockIFL);
  async command void setAhbprot(dma_ahbprot_t ahbprot);
  async command void setFifoCfg(dma_fifocfg_t fifocfg);
  
  async command void enable();
  async command void disable();
  async command void enableChannel(uint8_t channel);
  async command void enableChannelInterrupt(uint8_t channel);

  async event void transferDone(error_t success);

}
