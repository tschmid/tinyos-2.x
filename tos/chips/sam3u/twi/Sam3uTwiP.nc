#include <I2C.h>
#include "sam3utwihardware.h"

generic module Sam3uTwiP(uint8_t channel) {
  provides interface I2CPacket<TI2CBasicAddr> as TwiBasicAddr;
  provides interface ResourceConfigure[uint8_t id];
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

  norace sam3u_twi_action_state_t ACTION_STATE;

  task void nextRead();
  task void nextWrite();
  void sendDone(error_t error);

  norace uint16_t ADDR;
  norace uint8_t LEN;
  norace uint8_t* BUFFER;
  norace i2c_flags_t FLAGS;
  norace uint8_t* INIT_BUFFER;
  norace uint8_t INIT_LEN;

  error_t configureTwi(){
    return SUCCESS;
  }

  void initTwi(){
    //DONE
    switch(channel){
    case 0:
      call HplTwi.swReset0();
      call HplTwi.init0();
      break;
    case 1:
      call HplTwi.swReset1();
      call HplTwi.init1();
      break;
    }
  }

  async command void ResourceConfigure.configure[ uint8_t id ]() {
    //DONE
    const sam3u_twi_union_config_t* ONE config;
    config  = call Sam3uTwiConfigure.getConfig[id]();
    switch(channel){
    case 0:
      //call Leds.led1Toggle();
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
    call Leds.led1Toggle();

    if(ACTION_STATE != RX_STATE){
      if(ACTION_STATE != IDLE_STATE){
	return EBUSY;
      }
      atomic INIT_BUFFER = buf;
      atomic INIT_LEN = len;
      atomic ACTION_STATE = RX_STATE;
      initTwi();
    }
    configureTwi();


    atomic FLAGS = flags;
    atomic ADDR = addr;
    atomic LEN = len;
    atomic BUFFER = buf;

    switch(channel){
    case 0:
      call HplTwi.setMaster0();
      call HplTwi.disSlave0();
      call HplTwi.addrSize0(1);// There is no parameter in the read command for this 
      call HplTwi.setDeviceAddr0((uint8_t)addr);
      call HplTwi.setInternalAddr0(0);
      call HplTwi.setIntRxReady0();
      call HplTwi.setDirection0(1); // read direction
      call HplTwi.setStart0();
      if(len == 1){
	call HplTwi.setStop0();
      }
      break;
    case 1:
      call HplTwi.setMaster1();
      call HplTwi.disSlave1();
      call HplTwi.addrSize1(0);// There is no parameter in the read command for this 
      call HplTwi.setDeviceAddr1((uint8_t)addr);
      call HplTwi.setIntRxReady1();
      call HplTwi.setDirection1(1); // read direction
      call HplTwi.setStart1();
      if(len == 1){
	call HplTwi.setStop1();
      }
      break;
    }

    LEN --; // done with one, change length
    BUFFER ++; // point to next element
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
      initTwi(); // inits pio / clock / interrupt
    }

    atomic FLAGS = flags;
    atomic ADDR = addr;
    atomic LEN = len;
    atomic BUFFER = buf;

    configureTwi(); // w.r.t configuration format
    // no need for explicit start in TX;
    switch(channel){
    case 0:
      //master enable
      //disable slave
      //master mode register (slave addr / internal addr size / tx direction )
      //set twi_iadr?
      //load data
      call HplTwi.setMaster0();
      call HplTwi.disSlave0();
      call HplTwi.addrSize0(0); // There is no parameter in the read command for this 
      call HplTwi.setDeviceAddr0((uint8_t)addr);
      call HplTwi.setIntTxComp0();
      call HplTwi.setDirection0(0);
      call HplTwi.setTxReg0(BUFFER[0]);
      break;
    case 1:
      call HplTwi.setMaster1();
      call HplTwi.disSlave1();
      call HplTwi.addrSize1(0); // There is no parameter in the read command for this 
      call HplTwi.setDeviceAddr1((uint8_t)addr);
      call HplTwi.setIntTxComp1();
      call HplTwi.setDirection1(0);
      call HplTwi.setTxReg1(BUFFER[0]);
      break;
    }

    LEN --; // done with one, change length
    BUFFER ++; // point to next element
    return SUCCESS;
  }

  async event void TwiInterrupt.fired0(){
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
    if(LEN > 0){
      call TwiBasicAddr.write(FLAGS, ADDR, LEN, BUFFER ); // proceed with next item in the buffer
    }else{
      if(INIT_LEN != 1){
	call HplTwi.setStop0();
      }
      sendDone(SUCCESS);
    }
  }

  task void nextRead(){
    //DONE
    uint8_t* tempBuffer = BUFFER - 1; // the buffer moved at the end of the read command above.
    
    switch(channel){ // save received data to buffer
      case 0:
	tempBuffer[0] = call HplTwi.readRxReg0();
	break;
      case 1:
	tempBuffer[0] = call HplTwi.readRxReg1();
	break;
    }
    if(LEN > 0){
      call TwiBasicAddr.read(FLAGS, ADDR, LEN, BUFFER ); // read next data
    }else{
      call Leds.led0Toggle();
      if(INIT_LEN != 1){
	call HplTwi.setStop0();
      }
      sendDone(SUCCESS);
    }
  }

  void sendDone(error_t error){
    //DONE
    switch (ACTION_STATE){
    case RX_STATE:
      atomic ACTION_STATE = IDLE_STATE; // clear state
      signal TwiBasicAddr.readDone(error, ADDR, INIT_LEN, INIT_BUFFER);
      break;
    case TX_STATE:
      atomic ACTION_STATE = IDLE_STATE; // clear state
      signal TwiBasicAddr.writeDone(error, ADDR, INIT_LEN, INIT_BUFFER);
      break;
    case IDLE_STATE:
      break;
    }
  }

  const sam3u_twi_union_config_t sam3u_twi_default_config = {};

  default async command const sam3u_twi_union_config_t* Sam3uTwiConfigure.getConfig[uint8_t id]() {
    //DONE
    return &sam3u_twi_default_config;
  }

 default async event void TwiBasicAddr.readDone(error_t error, uint16_t addr, uint8_t length, uint8_t* data){}
 default async event void TwiBasicAddr.writeDone(error_t error, uint16_t addr, uint8_t length, uint8_t* data){}


}