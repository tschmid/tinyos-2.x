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
module HplSam3uTwiImplP {
  provides {
    interface HplSam3uTwi;
    interface HplSam3uTwiInterrupt as Interrupt;
  }
  uses {
    interface HplNVICInterruptCntl as Twi0Interrupt;
    interface HplNVICInterruptCntl as Twi1Interrupt;
    interface HplSam3uGeneralIOPin as Twd0Pin;
    interface HplSam3uGeneralIOPin as Twd1Pin;
    interface HplSam3uGeneralIOPin as Twck0Pin;
    interface HplSam3uGeneralIOPin as Twck1Pin;
    interface HplSam3uPeripheralClockCntl as Twi0ClockControl;
    interface HplSam3uPeripheralClockCntl as Twi1ClockControl;
    interface HplSam3uClock as Twi0ClockConfig;
    interface HplSam3uClock as Twi1ClockConfig;
    interface Leds;
  }
}
implementation{

  norace uint8_t Interrupt_ID;

  void Twi0IrqHandler() @C() @spontaneous() {
    signal Interrupt.fired0();
  }

  void Twi1IrqHandler() @C() @spontaneous() {
    signal Interrupt.fired1();
  }

  void clearAllInterrupts0(){
    call HplSam3uTwi.disIntTxComp0();
    call HplSam3uTwi.disIntRxReady0();
    call HplSam3uTwi.disIntTxReady0();
    call HplSam3uTwi.disIntSlaveAccess0();
    call HplSam3uTwi.disIntGenCallAccess0();
    call HplSam3uTwi.disIntORErr0();
    call HplSam3uTwi.disIntNack0();
    call HplSam3uTwi.disIntArbLost0();
    call HplSam3uTwi.disIntClockWaitState0();
    call HplSam3uTwi.disIntEOSAccess0();
    call HplSam3uTwi.disIntEndRx0();
    call HplSam3uTwi.disIntEndTx0();
    call HplSam3uTwi.disIntRxBufFull0();
    call HplSam3uTwi.disIntTxBufEmpty0();
  }
  void clearAllInterrupts1(){
    call HplSam3uTwi.disIntTxComp1();
    call HplSam3uTwi.disIntRxReady1();
    call HplSam3uTwi.disIntTxReady1();
    call HplSam3uTwi.disIntSlaveAccess1();
    call HplSam3uTwi.disIntGenCallAccess1();
    call HplSam3uTwi.disIntORErr1();
    call HplSam3uTwi.disIntNack1();
    call HplSam3uTwi.disIntArbLost1();
    call HplSam3uTwi.disIntClockWaitState1();
    call HplSam3uTwi.disIntEOSAccess1();
    call HplSam3uTwi.disIntEndRx1();
    call HplSam3uTwi.disIntEndTx1();
    call HplSam3uTwi.disIntRxBufFull1();
    call HplSam3uTwi.disIntTxBufEmpty1();
  }

  async command void HplSam3uTwi.setInterruptID(uint8_t id){
    atomic Interrupt_ID = id;
  }

  async command void HplSam3uTwi.configureTwi0(const sam3u_twi_union_config_t *config){

    call Twi0Interrupt.configure(IRQ_PRIO_TWI0);
    call Twi0Interrupt.enable();

    call Twi0ClockControl.enable();

    call Twd0Pin.disablePioControl();
    call Twd0Pin.selectPeripheralA();
    call Twck0Pin.disablePioControl();
    call Twck0Pin.selectPeripheralA();

    call HplSam3uTwi.setClockLowDiv0((uint8_t)config->cldiv);
    call HplSam3uTwi.setClockHighDiv0((uint8_t)config->chdiv);
    call HplSam3uTwi.setClockDiv0((uint8_t)config->ckdiv);

    clearAllInterrupts0();

  }

  async command void HplSam3uTwi.configureTwi1(const sam3u_twi_union_config_t *config){

    call Twi1Interrupt.configure(IRQ_PRIO_TWI1);
    call Twi1Interrupt.enable();

    call Twi1ClockControl.enable();

    call Twd1Pin.disablePioControl();
    call Twd1Pin.selectPeripheralA();
    call Twck1Pin.disablePioControl();
    call Twck1Pin.selectPeripheralA();

    clearAllInterrupts1();

    call HplSam3uTwi.setClockLowDiv1((uint8_t)config->cldiv);
    call HplSam3uTwi.setClockHighDiv1((uint8_t)config->chdiv);
    call HplSam3uTwi.setClockDiv1((uint8_t)config->ckdiv);
  }

  async command void HplSam3uTwi.init0(){
    clearAllInterrupts0();
  }

  async command void HplSam3uTwi.init1(){
    clearAllInterrupts1();
  }

  async command void HplSam3uTwi.setStart0(){
    volatile twi_cr_t* CR = (volatile twi_cr_t *) (TWI0_BASE_ADDR + 0x0);
    twi_cr_t cr;
    cr.bits.start = 1;
    *CR = cr;
  }

  async command void HplSam3uTwi.setStop0(){
    volatile twi_cr_t* CR = (volatile twi_cr_t *) (TWI0_BASE_ADDR + 0x0);
    twi_cr_t cr;
    cr.bits.stop = 1;
    *CR = cr;
  }

  async command void HplSam3uTwi.setStart1(){
    volatile twi_cr_t* CR = (volatile twi_cr_t *) (TWI1_BASE_ADDR + 0x0);
    twi_cr_t cr;
    cr.bits.start = 1;
    *CR = cr;
  }

  async command void HplSam3uTwi.setStop1(){
    volatile twi_cr_t* CR = (volatile twi_cr_t *) (TWI1_BASE_ADDR + 0x0);
    twi_cr_t cr;
    cr.bits.stop = 1;
    *CR = cr;
  }

  async command void HplSam3uTwi.setMaster0(){
    volatile twi_cr_t* CR = (volatile twi_cr_t *) (TWI0_BASE_ADDR + 0x0);
    twi_cr_t cr;
    cr.bits.msen = 1;
    *CR = cr;
  }

  async command void HplSam3uTwi.disMaster0(){
    volatile twi_cr_t* CR = (volatile twi_cr_t *) (TWI0_BASE_ADDR + 0x0);
    twi_cr_t cr;
    cr.bits.msdis = 1;
    *CR = cr;
  }

  async command void HplSam3uTwi.setMaster1(){
    volatile twi_cr_t* CR = (volatile twi_cr_t *) (TWI1_BASE_ADDR + 0x0);
    twi_cr_t cr;
    cr.bits.msen = 1;
    *CR = cr;
  }

  async command void HplSam3uTwi.disMaster1(){
    volatile twi_cr_t* CR = (volatile twi_cr_t *) (TWI1_BASE_ADDR + 0x0);
    twi_cr_t cr;
    cr.bits.msdis = 1;
    *CR = cr;
  }

  async command void HplSam3uTwi.setSlave0(){
    volatile twi_cr_t* CR = (volatile twi_cr_t *) (TWI0_BASE_ADDR + 0x0);
    twi_cr_t cr;
    cr.bits.sven = 1;
    *CR = cr;
  }

  async command void HplSam3uTwi.disSlave0(){
    volatile twi_cr_t* CR = (volatile twi_cr_t *) (TWI0_BASE_ADDR + 0x0);
    twi_cr_t cr;
    cr.bits.svdis = 1;
    *CR = cr;
  }

  async command void HplSam3uTwi.setSlave1(){
    volatile twi_cr_t* CR = (volatile twi_cr_t *) (TWI1_BASE_ADDR + 0x0);
    twi_cr_t cr;
    cr.bits.sven = 1;
    *CR = cr;
  }

  async command void HplSam3uTwi.disSlave1(){
    volatile twi_cr_t* CR = (volatile twi_cr_t *) (TWI1_BASE_ADDR + 0x0);
    twi_cr_t cr;
    cr.bits.svdis = 1;
    *CR = cr;
  }

  async command void HplSam3uTwi.setQuick0(){
    volatile twi_cr_t* CR = (volatile twi_cr_t *) (TWI0_BASE_ADDR + 0x0);
    twi_cr_t cr;
    cr.bits.quick = 1;
    *CR = cr;
  }

  async command void HplSam3uTwi.setQuick1(){
    volatile twi_cr_t* CR = (volatile twi_cr_t *) (TWI1_BASE_ADDR + 0x0);
    twi_cr_t cr;
    cr.bits.quick = 1;
    *CR = cr;
  }

  async command void HplSam3uTwi.swReset0(){
    volatile twi_cr_t* CR = (volatile twi_cr_t *) (TWI0_BASE_ADDR + 0x0);
    twi_cr_t cr;
    cr.bits.swrst = 1;
    *CR = cr;
  }

  async command void HplSam3uTwi.swReset1(){
    volatile twi_cr_t* CR = (volatile twi_cr_t *) (TWI1_BASE_ADDR + 0x0);
    twi_cr_t cr;
    cr.bits.swrst = 1;
    *CR = cr;
  }

  async command void HplSam3uTwi.setDeviceAddr0(uint8_t dadr){
    volatile twi_mmr_t* MMR = (volatile twi_mmr_t *) (TWI0_BASE_ADDR + 0x4);
    twi_mmr_t mmr = *MMR;
    mmr.bits.dadr = dadr;
    *MMR = mmr;
  }
  async command void HplSam3uTwi.setDeviceAddr1(uint8_t dadr){
    volatile twi_mmr_t* MMR = (volatile twi_mmr_t *) (TWI1_BASE_ADDR + 0x4);
    twi_mmr_t mmr = *MMR;
    mmr.bits.dadr = dadr;
    *MMR = mmr;
  }
  async command void HplSam3uTwi.setDirection0(uint8_t mread){
    volatile twi_mmr_t* MMR = (volatile twi_mmr_t *) (TWI0_BASE_ADDR + 0x4);
    twi_mmr_t mmr = *MMR;
    mmr.bits.mread = mread;
    *MMR = mmr;
  }
  async command void HplSam3uTwi.setDirection1(uint8_t mread){
    volatile twi_mmr_t* MMR = (volatile twi_mmr_t *) (TWI0_BASE_ADDR + 0x4);
    twi_mmr_t mmr = *MMR;
    mmr.bits.mread = mread;
    *MMR = mmr;
  }
  async command void HplSam3uTwi.addrSize0(uint8_t iadrsz){
    volatile twi_mmr_t* MMR = (volatile twi_mmr_t *) (TWI0_BASE_ADDR + 0x4);
    twi_mmr_t mmr = *MMR;
    mmr.bits.iadrsz = iadrsz;
    *MMR = mmr;
  }
  async command void HplSam3uTwi.addrSize1(uint8_t iadrsz){
    volatile twi_mmr_t* MMR = (volatile twi_mmr_t *) (TWI1_BASE_ADDR + 0x4);
    twi_mmr_t mmr = *MMR;
    mmr.bits.iadrsz = iadrsz;
    *MMR = mmr;
  }

  async command void HplSam3uTwi.setSlaveAddr0(uint8_t sadr){
    volatile twi_smr_t* SMR = (volatile twi_smr_t *) (TWI0_BASE_ADDR + 0x8);
    twi_smr_t smr = *SMR;
    smr.bits.sadr = sadr;
    *SMR = smr;
  }
  async command void HplSam3uTwi.setSlaveAddr1(uint8_t sadr){
    volatile twi_smr_t* SMR = (volatile twi_smr_t *) (TWI1_BASE_ADDR + 0x8);
    twi_smr_t smr = *SMR;
    smr.bits.sadr = sadr;
    *SMR = smr;
  }

  async command void HplSam3uTwi.setInternalAddr0(uint32_t iadr){
    volatile twi_iadr_t* IADR = (volatile twi_iadr_t *) (TWI0_BASE_ADDR + 0xC);
    twi_iadr_t iadr_r = *IADR;
    iadr_r.bits.iadr = iadr;
    *IADR = iadr_r;
  }
  async command void HplSam3uTwi.setInternalAddr1(uint32_t iadr){
    volatile twi_iadr_t* IADR = (volatile twi_iadr_t *) (TWI1_BASE_ADDR + 0xC);
    twi_iadr_t iadr_r = *IADR;
    iadr_r.bits.iadr = iadr;
    *IADR = iadr_r;
  }

  async command void HplSam3uTwi.setClockLowDiv0(uint8_t cldiv){
    volatile twi_cwgr_t* CWGR = (volatile twi_cwgr_t *) (TWI0_BASE_ADDR + 0x10);
    twi_cwgr_t cwgr = *CWGR;
    cwgr.bits.cldiv = cldiv;
    *CWGR = cwgr;
  }
  async command void HplSam3uTwi.setClockLowDiv1(uint8_t cldiv){
    volatile twi_cwgr_t* CWGR = (volatile twi_cwgr_t *) (TWI1_BASE_ADDR + 0x10);
    twi_cwgr_t cwgr = *CWGR;
    cwgr.bits.cldiv = cldiv;
    *CWGR = cwgr;
  }
  async command void HplSam3uTwi.setClockHighDiv0(uint8_t chdiv){
    volatile twi_cwgr_t* CWGR = (volatile twi_cwgr_t *) (TWI0_BASE_ADDR + 0x10);
    twi_cwgr_t cwgr = *CWGR;
    cwgr.bits.chdiv = chdiv;
    *CWGR = cwgr;
  }
  async command void HplSam3uTwi.setClockHighDiv1(uint8_t chdiv){
    volatile twi_cwgr_t* CWGR = (volatile twi_cwgr_t *) (TWI1_BASE_ADDR + 0x10);
    twi_cwgr_t cwgr = *CWGR;
    cwgr.bits.chdiv = chdiv;
    *CWGR = cwgr;
  }
  async command void HplSam3uTwi.setClockDiv0(uint8_t ckdiv){
    volatile twi_cwgr_t* CWGR = (volatile twi_cwgr_t *) (TWI0_BASE_ADDR + 0x10);
    twi_cwgr_t cwgr = *CWGR;
    cwgr.bits.ckdiv = ckdiv;
    *CWGR = cwgr;
  }
  async command void HplSam3uTwi.setClockDiv1(uint8_t ckdiv){
    volatile twi_cwgr_t* CWGR = (volatile twi_cwgr_t *) (TWI1_BASE_ADDR + 0x10);
    twi_cwgr_t cwgr = *CWGR;
    cwgr.bits.ckdiv = ckdiv;
    *CWGR = cwgr;
  }

  async command uint8_t HplSam3uTwi.getTxCompleted0(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI0_BASE_ADDR + 0x20);
    return SR->bits.txcomp;
  }
  async command uint8_t HplSam3uTwi.getRxReady0(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI0_BASE_ADDR + 0x20);
    return SR->bits.rxrdy;
  }
  async command uint8_t HplSam3uTwi.getTxReady0(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI0_BASE_ADDR + 0x20);
    return SR->bits.txrdy;
  }
  async command uint8_t HplSam3uTwi.getSlaveRead0(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI0_BASE_ADDR + 0x20);
    return SR->bits.svread;
  }
  async command uint8_t HplSam3uTwi.getSlaveAccess0(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI0_BASE_ADDR + 0x20);
    return SR->bits.svacc;
  }
  async command uint8_t HplSam3uTwi.getGenCallAccess0(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI0_BASE_ADDR + 0x20);
    return SR->bits.gacc;
  }
  async command uint8_t HplSam3uTwi.getORErr0(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI0_BASE_ADDR + 0x20);
    return SR->bits.ovre;
  }
  async command uint8_t HplSam3uTwi.getNack0(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI0_BASE_ADDR + 0x20);
    return SR->bits.nack;
  }
  async command uint8_t HplSam3uTwi.getArbLost0(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI0_BASE_ADDR + 0x20);
    return SR->bits.arblst;
  }
  async command uint8_t HplSam3uTwi.getClockWaitState0(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI0_BASE_ADDR + 0x20);
    return SR->bits.sclws;
  }
  async command uint8_t HplSam3uTwi.getEOSAccess0(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI0_BASE_ADDR + 0x20);
    return SR->bits.eosacc;
  }
  async command uint8_t HplSam3uTwi.getEndRx0(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI0_BASE_ADDR + 0x20);
    return SR->bits.endrx;
  }
  async command uint8_t HplSam3uTwi.getEndTx0(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI0_BASE_ADDR + 0x20);
    return SR->bits.endtx;
  }
  async command uint8_t HplSam3uTwi.getRxBufFull0(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI0_BASE_ADDR + 0x20);
    return SR->bits.rxbuff;
  }
  async command uint8_t HplSam3uTwi.getTxBufEmpty0(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI0_BASE_ADDR + 0x20);
    return SR->bits.txbufe;
  }

  async command uint8_t HplSam3uTwi.getTxCompleted1(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI1_BASE_ADDR + 0x20);
    return SR->bits.txcomp;
  }
  async command uint8_t HplSam3uTwi.getRxReady1(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI1_BASE_ADDR + 0x20);
    return SR->bits.rxrdy;
  }
  async command uint8_t HplSam3uTwi.getTxReady1(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI1_BASE_ADDR + 0x20);
    return SR->bits.txrdy;
  }
  async command uint8_t HplSam3uTwi.getSlaveRead1(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI1_BASE_ADDR + 0x20);
    return SR->bits.svread;
  }
  async command uint8_t HplSam3uTwi.getSlaveAccess1(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI1_BASE_ADDR + 0x20);
    return SR->bits.svacc;
  }
  async command uint8_t HplSam3uTwi.getGenCallAccess1(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI1_BASE_ADDR + 0x20);
    return SR->bits.gacc;
  }
  async command uint8_t HplSam3uTwi.getORErr1(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI1_BASE_ADDR + 0x20);
    return SR->bits.ovre;
  }
  async command uint8_t HplSam3uTwi.getNack1(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI1_BASE_ADDR + 0x20);
    return SR->bits.nack;
  }
  async command uint8_t HplSam3uTwi.getArbLost1(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI1_BASE_ADDR + 0x20);
    return SR->bits.arblst;
  }
  async command uint8_t HplSam3uTwi.getClockWaitState1(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI1_BASE_ADDR + 0x20);
    return SR->bits.sclws;
  }
  async command uint8_t HplSam3uTwi.getEOSAccess1(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI1_BASE_ADDR + 0x20);
    return SR->bits.eosacc;
  }
  async command uint8_t HplSam3uTwi.getEndRx1(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI1_BASE_ADDR + 0x20);
    return SR->bits.endrx;
  }
  async command uint8_t HplSam3uTwi.getEndTx1(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI1_BASE_ADDR + 0x20);
    return SR->bits.endtx;
  }
  async command uint8_t HplSam3uTwi.getRxBufFull1(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI1_BASE_ADDR + 0x20);
    return SR->bits.rxbuff;
  }
  async command uint8_t HplSam3uTwi.getTxBufEmpty1(){
    volatile twi_sr_t* SR = (volatile twi_sr_t *) (TWI1_BASE_ADDR + 0x20);
    return SR->bits.txbufe;
  }

  async command void HplSam3uTwi.setIntTxComp0(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI0_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.txcomp = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntRxReady0(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI0_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.rxrdy = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntTxReady0(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI0_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.txrdy = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntSlaveAccess0(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI0_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.svacc = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntGenCallAccess0(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI0_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.gacc = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntORErr0(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI0_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.ovre = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntNack0(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI0_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.nack = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntArbLost0(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI0_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.arblst = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntClockWaitState0(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI0_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.sclws = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntEOSAccess0(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI0_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.eosacc = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntEndRx0(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI0_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.endrx = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntEndTx0(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI0_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.endtx = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntRxBufFull0(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI0_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.rxbuff = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntTxBufEmpty0(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI0_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.txbufe = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntTxComp1(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI1_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.txcomp = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntRxReady1(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI1_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.rxrdy = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntTxReady1(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI1_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.txrdy = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntSlaveAccess1(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI1_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.svacc = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntGenCallAccess1(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI1_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.gacc = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntORErr1(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI1_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.ovre = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntNack1(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI1_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.nack = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntArbLost1(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI1_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.arblst = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntClockWaitState1(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI1_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.sclws = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntEOSAccess1(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI1_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.eosacc = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntEndRx1(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI1_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.endrx = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntEndTx1(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI1_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.endtx = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntRxBufFull1(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI1_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.rxbuff = 1;
    *IER = ier;
  }
  async command void HplSam3uTwi.setIntTxBufEmpty1(){
    volatile twi_ier_t* IER = (volatile twi_ier_t *) (TWI1_BASE_ADDR + 0x24);
    twi_ier_t ier;
    ier.bits.txbufe = 1;
    *IER = ier;
  }

  async command void HplSam3uTwi.disIntTxComp0(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI0_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.txcomp = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntRxReady0(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI0_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.rxrdy = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntTxReady0(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI0_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.txrdy = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntSlaveAccess0(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI0_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.svacc = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntGenCallAccess0(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI0_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.gacc = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntORErr0(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI0_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.ovre = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntNack0(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI0_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.nack = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntArbLost0(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI0_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.arblst = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntClockWaitState0(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI0_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.sclws = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntEOSAccess0(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI0_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.eosacc = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntEndRx0(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI0_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.endrx = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntEndTx0(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI0_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.endtx = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntRxBufFull0(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI0_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.rxbuff = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntTxBufEmpty0(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI0_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.txbufe = 1;
    *IDR = idr;
  }

  async command void HplSam3uTwi.disIntTxComp1(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI1_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.txcomp = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntRxReady1(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI1_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.rxrdy = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntTxReady1(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI1_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.txrdy = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntSlaveAccess1(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI1_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.svacc = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntGenCallAccess1(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI1_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.gacc = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntORErr1(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI1_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.ovre = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntNack1(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI1_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.nack = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntArbLost1(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI1_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.arblst = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntClockWaitState1(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI1_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.sclws = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntEOSAccess1(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI1_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.eosacc = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntEndRx1(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI1_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.endrx = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntEndTx1(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI1_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.endtx = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntRxBufFull1(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI1_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.rxbuff = 1;
    *IDR = idr;
  }
  async command void HplSam3uTwi.disIntTxBufEmpty1(){
    volatile twi_idr_t* IDR = (volatile twi_idr_t *) (TWI1_BASE_ADDR + 0x28);
    twi_idr_t idr;
    idr.bits.txbufe = 1;
    *IDR = idr;
  }

  async command uint8_t HplSam3uTwi.maskIntTxComp0(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI0_BASE_ADDR + 0x2C);
    return IMR->bits.txcomp;
  }
  async command uint8_t HplSam3uTwi.maskIntRxReady0(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI0_BASE_ADDR + 0x2C);
    return IMR->bits.rxrdy;
  }
  async command uint8_t HplSam3uTwi.maskIntTxReady0(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI0_BASE_ADDR + 0x2C);
    return IMR->bits.txrdy;
  }
  async command uint8_t HplSam3uTwi.maskIntSlaveAccess0(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI0_BASE_ADDR + 0x2C);
    return IMR->bits.svacc;
  }
  async command uint8_t HplSam3uTwi.maskIntGenCallAccess0(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI0_BASE_ADDR + 0x2C);
    return IMR->bits.gacc;
  }
  async command uint8_t HplSam3uTwi.maskIntORErr0(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI0_BASE_ADDR + 0x2C);
    return IMR->bits.ovre;
  }
  async command uint8_t HplSam3uTwi.maskIntNack0(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI0_BASE_ADDR + 0x2C);
    return IMR->bits.nack;
  }
  async command uint8_t HplSam3uTwi.maskIntArbLost0(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI0_BASE_ADDR + 0x2C);
    return IMR->bits.arblst;
  }
  async command uint8_t HplSam3uTwi.maskIntClockWaitState0(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI0_BASE_ADDR + 0x2C);
    return IMR->bits.sclws;
  }
  async command uint8_t HplSam3uTwi.maskIntEOSAccess0(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI0_BASE_ADDR + 0x2C);
    return IMR->bits.eosacc;
  }
  async command uint8_t HplSam3uTwi.maskIntEndRx0(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI0_BASE_ADDR + 0x2C);
    return IMR->bits.endrx;
  }
  async command uint8_t HplSam3uTwi.maskIntEndTx0(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI0_BASE_ADDR + 0x2C);
    return IMR->bits.endtx;
  }
  async command uint8_t HplSam3uTwi.maskIntRxBufFull0(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI0_BASE_ADDR + 0x2C);
    return IMR->bits.rxbuff;
  }
  async command uint8_t HplSam3uTwi.maskIntTxBufEmpty0(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI0_BASE_ADDR + 0x2C);
    return IMR->bits.txbufe;
  }
  async command uint8_t HplSam3uTwi.maskIntTxComp1(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI1_BASE_ADDR + 0x2C);
    return IMR->bits.txcomp;
  }
  async command uint8_t HplSam3uTwi.maskIntRxReady1(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI1_BASE_ADDR + 0x2C);
    return IMR->bits.rxrdy;
  }
  async command uint8_t HplSam3uTwi.maskIntTxReady1(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI1_BASE_ADDR + 0x2C);
    return IMR->bits.txrdy;
  }
  async command uint8_t HplSam3uTwi.maskIntSlaveAccess1(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI1_BASE_ADDR + 0x2C);
    return IMR->bits.svacc;
  }
  async command uint8_t HplSam3uTwi.maskIntGenCallAccess1(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI1_BASE_ADDR + 0x2C);
    return IMR->bits.gacc;
  }
  async command uint8_t HplSam3uTwi.maskIntORErr1(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI1_BASE_ADDR + 0x2C);
    return IMR->bits.ovre;
  }
  async command uint8_t HplSam3uTwi.maskIntNack1(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI1_BASE_ADDR + 0x2C);
    return IMR->bits.nack;
  }
  async command uint8_t HplSam3uTwi.maskIntArbLost1(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI1_BASE_ADDR + 0x2C);
    return IMR->bits.arblst;
  }
  async command uint8_t HplSam3uTwi.maskIntClockWaitState1(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI1_BASE_ADDR + 0x2C);
    return IMR->bits.sclws;
  }
  async command uint8_t HplSam3uTwi.maskIntEOSAccess1(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI1_BASE_ADDR + 0x2C);
    return IMR->bits.eosacc;
  }
  async command uint8_t HplSam3uTwi.maskIntEndRx1(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI1_BASE_ADDR + 0x2C);
    return IMR->bits.endrx;
  }
  async command uint8_t HplSam3uTwi.maskIntEndTx1(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI1_BASE_ADDR + 0x2C);
    return IMR->bits.endtx;
  }
  async command uint8_t HplSam3uTwi.maskIntRxBufFull1(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI1_BASE_ADDR + 0x2C);
    return IMR->bits.rxbuff;
  }
  async command uint8_t HplSam3uTwi.maskIntTxBufEmpty1(){
    volatile twi_imr_t* IMR = (volatile twi_imr_t *) (TWI1_BASE_ADDR + 0x2C);
    return IMR->bits.txbufe;
  }

  async command uint8_t HplSam3uTwi.readRxReg0(){
    volatile twi_rhr_t* RHR = (volatile twi_rhr_t *) (TWI0_BASE_ADDR + 0x30);
    return RHR->bits.rxdata;
  }
  async command uint8_t HplSam3uTwi.readRxReg1(){
    volatile twi_rhr_t* RHR = (volatile twi_rhr_t *) (TWI1_BASE_ADDR + 0x30);
    return RHR->bits.rxdata;
  }

  async command void HplSam3uTwi.setTxReg0(uint8_t buffer){
    volatile twi_thr_t* THR = (volatile twi_thr_t *) (TWI0_BASE_ADDR + 0x34);
    twi_thr_t thr = *THR;
    thr.bits.txdata = buffer;
    *THR = thr;
  }

  async command void HplSam3uTwi.setTxReg1(uint8_t buffer){
    volatile twi_thr_t* THR = (volatile twi_thr_t *) (TWI1_BASE_ADDR + 0x34);
    twi_thr_t thr = *THR;
    thr.bits.txdata = buffer;
    *THR = thr;
  }

  async event void Twi0ClockConfig.mainClockChanged(){}
  async event void Twi1ClockConfig.mainClockChanged(){}

 default async event void Interrupt.fired0(){}
 default async event void Interrupt.fired1(){}

}
