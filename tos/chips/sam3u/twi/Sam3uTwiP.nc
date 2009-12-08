#include <I2C.h>
#include "sam3utwihardware.h"

generic module Sam3uTwiP(uint8_t channel) {
  provides interface I2CPacket<TI2CBasicAddr> as TwiBasicAddr;
  provides interface ResourceConfigure[uint8_t id];
  provides interface Sam3uTwiInternalAddress as InternalAddr;
  uses interface Leds;
  uses interface Sam3uTwiConfigure[ uint8_t id ];
  uses interface HplSam3uTwiInterrupt as TwiInterrupt;  
  uses interface HplSam3uTwi as HplTwi;
}
implementation {

  typedef enum {
    RX_STATE,
    TX_STATE,
    IDLE_STATE,
  } sam3u_twi_action_state_t;

  norace sam3u_twi_action_state_t ACTION_STATE = IDLE_STATE;

  task void nextRead();
  task void nextWrite();

  norace uint16_t ADDR;
  norace uint8_t LEN;
  norace uint8_t* BUFFER;
  norace i2c_flags_t FLAGS;
  norace uint8_t* INIT_BUFFER;
  norace uint8_t INIT_LEN;
  norace uint8_t READ;
  norace uint8_t WRITE;

  norace uint8_t IASIZE;
  norace uint32_t INTADDR;

  error_t configureTwi(){
    return SUCCESS;
  }

  void initTwi(){
    //DONE
    switch(channel){
    case 0:
      call HplTwi.init0();
      break;
    case 1:
      call HplTwi.init1();
      break;
    }
  }

  async command void InternalAddr.setInternalAddrSize(uint8_t size){
    atomic IASIZE = size;
  }
  async command void InternalAddr.setInternalAddr(uint32_t intAddr){
    atomic INTADDR = intAddr;
  }


  async command void ResourceConfigure.configure[ uint8_t id ]() {
    //DONE
    const sam3u_twi_union_config_t* ONE config;
    config  = call Sam3uTwiConfigure.getConfig[id]();
    switch(channel){
    case 0:
      call HplTwi.configureTwi0(config);
      call HplTwi.setInterruptID(id);
      break;
    case 1:
      call HplTwi.configureTwi1(config);
      call HplTwi.setInterruptID(id);
      break;
    }
  }

  async command void ResourceConfigure.unconfigure[ uint8_t id ]() {
    // set a parameter CLEAR!
    switch(channel){
    case 0:
      //call HplTwi.configureTwi0(call Sam3uTwiConfigure.getConfig[id]());
      break;
    case 1:
      //call HplTwi.configureTwi1(call Sam3uTwiConfigure.getConfig[id]());
      break;
    }
  }

  async command error_t TwiBasicAddr.read(i2c_flags_t flags, uint16_t addr, uint8_t len, uint8_t* buf ) {
    //DONE
    if(ACTION_STATE != RX_STATE){
      if(ACTION_STATE != IDLE_STATE){
	return EBUSY;
      }
      atomic INIT_BUFFER = buf;
      atomic INIT_LEN = len;
      atomic ACTION_STATE = RX_STATE;
      atomic READ = 0;
      initTwi();
    }
    atomic FLAGS = flags;
    atomic ADDR = addr;
    atomic LEN = len;
    atomic BUFFER = buf;

    switch(channel){
    case 0:
      if(len == 1){
	call HplTwi.setStop0();
      }
      call HplTwi.disMaster0();
      call HplTwi.disSlave0();
      call HplTwi.setMaster0();
      call HplTwi.addrSize0(IASIZE);// There is no parameter in the read command for this 
      call HplTwi.setDeviceAddr0((uint8_t)addr);
      if(IASIZE > 0)
	call HplTwi.setInternalAddr0(INTADDR);
      call HplTwi.setIntRxReady0();
      call HplTwi.setDirection0(1); // read direction
      call HplTwi.setStart0();
      break;
    case 1:
      if(len == 1){
	call HplTwi.setStop1();
      }
      call HplTwi.disMaster1();
      call HplTwi.disSlave1();
      call HplTwi.setMaster1();
      call HplTwi.addrSize1(IASIZE);// There is no parameter in the read command for this 
      call HplTwi.setDeviceAddr1((uint8_t)addr);
      if(IASIZE > 0)
	call HplTwi.setInternalAddr0(INTADDR);
      call HplTwi.setIntRxReady1();
      call HplTwi.setDirection1(1); // read direction
      call HplTwi.setStart1();
      break;
    }

    return SUCCESS;
  }

  async command error_t TwiBasicAddr.write(i2c_flags_t flags, uint16_t addr, uint8_t len, uint8_t* buf ) {
    //DONE
    if(ACTION_STATE != TX_STATE){
      if(ACTION_STATE != IDLE_STATE){
	return EBUSY;
      }
      atomic INIT_BUFFER = buf;
      atomic INIT_LEN = len;
      atomic ACTION_STATE = TX_STATE;
      atomic WRITE = 0;
      initTwi();
    }

    atomic FLAGS = flags;
    atomic ADDR = addr;
    atomic LEN = len;
    atomic BUFFER = buf;

    configureTwi();

    switch(channel){
    case 0:
      call HplTwi.setMaster0();
      call HplTwi.disSlave0();
      call HplTwi.addrSize0(IASIZE);
      call HplTwi.setDeviceAddr0((uint8_t)addr);
      if(IASIZE > 0)
	call HplTwi.setInternalAddr0(INTADDR);
      call HplTwi.setDirection0(0);
      call HplTwi.setIntTxReady0();
      call HplTwi.setTxReg0((uint8_t)INIT_BUFFER[WRITE]);
      if(INIT_LEN == 1){
	call HplTwi.setIntTxComp0();
	call HplTwi.setStop0();
      }
      break;
    case 1:
      call HplTwi.setMaster1();
      call HplTwi.disSlave1();
      call HplTwi.addrSize1(IASIZE);
      call HplTwi.setDeviceAddr1((uint8_t)addr);
      if(IASIZE > 0)
	call HplTwi.setInternalAddr1(INTADDR);
      call HplTwi.setDirection1(0);
      call HplTwi.setIntTxReady1();
      call HplTwi.setTxReg1((uint8_t)INIT_BUFFER[WRITE]);
      if(INIT_LEN == 1){
	call HplTwi.setIntTxComp1();
	call HplTwi.setStop1();
      }
      break;
    }

    //LEN --; // done with one, change length
    //BUFFER ++; // point to next element
    return SUCCESS;
  }

  async event void TwiInterrupt.fired0(){
    //DONE
    if(call HplTwi.getRxReady0()){
      atomic INIT_BUFFER[READ] = call HplTwi.readRxReg0(); // read out rx buffer
      LEN --;
      READ ++;
      if(LEN == 1){
	call HplTwi.setStop0();
      }else if(LEN > 1){
	return;
      }else{
	call HplTwi.disIntRxReady0();
	atomic ACTION_STATE = IDLE_STATE;
	signal TwiBasicAddr.readDone(SUCCESS, ADDR, INIT_LEN, INIT_BUFFER);
      }
    }else if(call HplTwi.getTxReady0()){
      if(INIT_LEN != 1){
	WRITE ++;
	if(WRITE < INIT_LEN){	  
	  if(WRITE+1 == INIT_LEN){	    
	    call HplTwi.disIntTxReady0();
	    call HplTwi.setTxReg0((uint8_t)INIT_BUFFER[WRITE]);
	    call HplTwi.setIntTxComp0();
	    call HplTwi.setStop0();
	  }else{
	    call HplTwi.setTxReg0((uint8_t)INIT_BUFFER[WRITE]);
	  }
	}else if(WRITE == INIT_LEN){
	  atomic ACTION_STATE = IDLE_STATE;
	  call Leds.led1Toggle();
	  call HplTwi.disIntTxReady0();
	  call HplTwi.disIntTxComp0();
	  signal TwiBasicAddr.writeDone(SUCCESS, ADDR, INIT_LEN, INIT_BUFFER);
	}
      }else if(INIT_LEN == 1 && call HplTwi.getTxCompleted0()){
	atomic ACTION_STATE = IDLE_STATE;
	call Leds.led0Toggle();
	call HplTwi.disIntTxReady0();
	call HplTwi.disIntTxComp0();
	signal TwiBasicAddr.writeDone(SUCCESS, ADDR, INIT_LEN, INIT_BUFFER);
      }
    }else if(call HplTwi.getTxCompleted0() && ACTION_STATE == TX_STATE){
      atomic ACTION_STATE = IDLE_STATE;
      call Leds.led0Toggle();
      call HplTwi.disIntTxComp0();
      signal TwiBasicAddr.writeDone(SUCCESS, ADDR, WRITE, INIT_BUFFER);
    }
  }

  async event void TwiInterrupt.fired1(){
    //DONE
    switch (ACTION_STATE){
    case RX_STATE:
      post nextRead();
      break;
    case TX_STATE:
      post nextWrite();
      break;
    case IDLE_STATE:
      break;
    }      
  }

  task void nextWrite(){
    //DONE
    call TwiBasicAddr.write(FLAGS, ADDR, LEN, BUFFER ); // proceed with next item in the buffer
  }

  task void nextRead(){
    //DONE
    call TwiBasicAddr.read(FLAGS, ADDR, LEN, BUFFER ); // read next data
  }

  const sam3u_twi_union_config_t sam3u_twi_default_config = {};

  default async command const sam3u_twi_union_config_t* Sam3uTwiConfigure.getConfig[uint8_t id]() {
    //DONE
    return &sam3u_twi_default_config;
  }

 default async event void TwiBasicAddr.readDone(error_t error, uint16_t addr, uint8_t length, uint8_t* data){}
 default async event void TwiBasicAddr.writeDone(error_t error, uint16_t addr, uint8_t length, uint8_t* data){}

}