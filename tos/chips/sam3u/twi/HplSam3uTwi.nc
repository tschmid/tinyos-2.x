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

// This file shows the Hpl level commands.

interface HplSam3uTwi{

  async command void setInterruptID(uint8_t id);

  async command void configureTwi0(const sam3u_twi_union_config_t* config);
  async command void configureTwi1(const sam3u_twi_union_config_t* config);

  async command void init0();
  async command void init1();

  /*Control Register Functions*/
  async command void setStart0();
  async command void setStop0();
  async command void setStart1();
  async command void setStop1();
  async command void setMaster0();
  async command void disMaster0();
  async command void setMaster1();
  async command void disMaster1();
  async command void setSlave0();
  async command void disSlave0();
  async command void setSlave1();
  async command void disSlave1();
  async command void setQuick0();
  async command void setQuick1();
  async command void swReset0();
  async command void swReset1();

  /*Master Mode Register Functions*/
  async command void setDeviceAddr0(uint8_t dadr);
  async command void setDeviceAddr1(uint8_t dadr);
  async command void setDirection0(uint8_t mread);
  async command void setDirection1(uint8_t mread);
  async command void addrSize0(uint8_t iadrsz);
  async command void addrSize1(uint8_t iadrsz);

  /*Slave Mode Register Functions*/
  async command void setSlaveAddr0(uint8_t sadr);
  async command void setSlaveAddr1(uint8_t sadr);

  /*Internal Addr Register Functions*/
  async command void setInternalAddr0(uint32_t iadr);
  async command void setInternalAddr1(uint32_t iadr);

  /*Clock Waveform Generator Register Functions*/
  async command void setClockLowDiv0(uint8_t cldiv);
  async command void setClockLowDiv1(uint8_t cldiv);
  async command void setClockHighDiv0(uint8_t chdiv);
  async command void setClockHighDiv1(uint8_t chdiv);
  async command void setClockDiv0(uint8_t ckdiv);
  async command void setClockDiv1(uint8_t ckdiv);

  /*Status Register Functions*/
  async command uint8_t getTxCompleted0();
  async command uint8_t getRxReady0();
  async command uint8_t getTxReady0();
  async command uint8_t getSlaveRead0();
  async command uint8_t getSlaveAccess0();
  async command uint8_t getGenCallAccess0();
  async command uint8_t getORErr0();
  async command uint8_t getNack0();
  async command uint8_t getArbLost0();
  async command uint8_t getClockWaitState0();
  async command uint8_t getEOSAccess0();
  async command uint8_t getEndRx0();
  async command uint8_t getEndTx0();
  async command uint8_t getRxBufFull0();
  async command uint8_t getTxBufEmpty0();

  async command uint8_t getTxCompleted1();
  async command uint8_t getRxReady1();
  async command uint8_t getTxReady1();
  async command uint8_t getSlaveRead1();
  async command uint8_t getSlaveAccess1();
  async command uint8_t getGenCallAccess1();
  async command uint8_t getORErr1();
  async command uint8_t getNack1();
  async command uint8_t getArbLost1();
  async command uint8_t getClockWaitState1();
  async command uint8_t getEOSAccess1();
  async command uint8_t getEndRx1();
  async command uint8_t getEndTx1();
  async command uint8_t getRxBufFull1();
  async command uint8_t getTxBufEmpty1();

  /*Interrupt Enable Register Functions*/
  async command void setIntTxComp0();
  async command void setIntRxReady0();
  async command void setIntTxReady0();
  async command void setIntSlaveAccess0();
  async command void setIntGenCallAccess0();
  async command void setIntORErr0();
  async command void setIntNack0();
  async command void setIntArbLost0();
  async command void setIntClockWaitState0();
  async command void setIntEOSAccess0();
  async command void setIntEndRx0();
  async command void setIntEndTx0();
  async command void setIntRxBufFull0();
  async command void setIntTxBufEmpty0();

  async command void setIntTxComp1();
  async command void setIntRxReady1();
  async command void setIntTxReady1();
  async command void setIntSlaveAccess1();
  async command void setIntGenCallAccess1();
  async command void setIntORErr1();
  async command void setIntNack1();
  async command void setIntArbLost1();
  async command void setIntClockWaitState1();
  async command void setIntEOSAccess1();
  async command void setIntEndRx1();
  async command void setIntEndTx1();
  async command void setIntRxBufFull1();
  async command void setIntTxBufEmpty1();

  /*Interrupt Disable Register*/
  async command void disIntTxComp0();
  async command void disIntRxReady0();
  async command void disIntTxReady0();
  async command void disIntSlaveAccess0();
  async command void disIntGenCallAccess0();
  async command void disIntORErr0();
  async command void disIntNack0();
  async command void disIntArbLost0();
  async command void disIntClockWaitState0();
  async command void disIntEOSAccess0();
  async command void disIntEndRx0();
  async command void disIntEndTx0();
  async command void disIntRxBufFull0();
  async command void disIntTxBufEmpty0();

  async command void disIntTxComp1();
  async command void disIntRxReady1();
  async command void disIntTxReady1();
  async command void disIntSlaveAccess1();
  async command void disIntGenCallAccess1();
  async command void disIntORErr1();
  async command void disIntNack1();
  async command void disIntArbLost1();
  async command void disIntClockWaitState1();
  async command void disIntEOSAccess1();
  async command void disIntEndRx1();
  async command void disIntEndTx1();
  async command void disIntRxBufFull1();
  async command void disIntTxBufEmpty1();

  /*Interrupt Mask Register*/
  async command uint8_t maskIntTxComp0();
  async command uint8_t maskIntRxReady0();
  async command uint8_t maskIntTxReady0();
  async command uint8_t maskIntSlaveAccess0();
  async command uint8_t maskIntGenCallAccess0();
  async command uint8_t maskIntORErr0();
  async command uint8_t maskIntNack0();
  async command uint8_t maskIntArbLost0();
  async command uint8_t maskIntClockWaitState0();
  async command uint8_t maskIntEOSAccess0();
  async command uint8_t maskIntEndRx0();
  async command uint8_t maskIntEndTx0();
  async command uint8_t maskIntRxBufFull0();
  async command uint8_t maskIntTxBufEmpty0();

  async command uint8_t maskIntTxComp1();
  async command uint8_t maskIntRxReady1();
  async command uint8_t maskIntTxReady1();
  async command uint8_t maskIntSlaveAccess1();
  async command uint8_t maskIntGenCallAccess1();
  async command uint8_t maskIntORErr1();
  async command uint8_t maskIntNack1();
  async command uint8_t maskIntArbLost1();
  async command uint8_t maskIntClockWaitState1();
  async command uint8_t maskIntEOSAccess1();
  async command uint8_t maskIntEndRx1();
  async command uint8_t maskIntEndTx1();
  async command uint8_t maskIntRxBufFull1();
  async command uint8_t maskIntTxBufEmpty1();

  /*Receive Holding Register Function*/
  async command uint8_t readRxReg0();
  async command uint8_t readRxReg1();

  /*Transmit Holding Register Functions*/
  async command void setTxReg0(uint8_t buffer);
  async command void setTxReg1(uint8_t buffer);

}
