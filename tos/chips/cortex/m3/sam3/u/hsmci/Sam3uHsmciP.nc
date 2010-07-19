// implementation file
#include <sam3uhsmcihardware.h>

module Sam3uHsmciP {
  provides interface Sam3uHsmci;

  uses interface HplSam3uHsmci as HplHsmci;
  uses interface HplSam3uHsmciInterrupt as HplHsmciInterrupt;
  uses interface Leds;
}
implementation {

  // TODO: Should interrupt be handled here or the lower layer?
  // TODO: When should the readBlockDone and writeBlockDone be signalled?
  norace uint16_t RCAddr;
  norace uint8_t state;
  enum {
    S_IDLE = 0x00,
    S_WRITE = 0x01,
    S_READ = 0x02,
    S_OTHER = 0x03,
  };

  command error_t Sam3uHsmci.init(){
    // start clock, start interrupt, start pin
    call HplHsmci.configureHsmci();

    // Write protection registers
    call HplHsmci.unlockRegisters();

    // sw reset
    call HplHsmci.swReset();

    // init configure registers
    call HplHsmci.initConfigReg();

    call HplHsmci.sendCommand(CMD_PON, 0); // This process will do everything for us

    atomic state = S_OTHER;

    return SUCCESS;

  }

  command uint32_t Sam3uHsmci.readCardSize(){
    uint32_t cardSize;
    return cardSize;
  }

  uint32_t SECTOR;
  uint32_t* BUFFER;

  command error_t Sam3uHsmci.readBlock(uint32_t sector, uint32_t * buffer){
    call HplHsmci.setRxReg(buffer);
    //
    atomic state = S_READ;
    SECTOR = sector;
    BUFFER = buffer;
    call HplHsmci.setTransState(0);
    return SUCCESS;
  }

  event void HplHsmciInterrupt.setTransDone(){
    if(state == S_READ){
      //signal Sam3uHsmci.readBlockDone(BUFFER);
      call HplHsmci.sendCommand(CMD17, SECTOR);
      //call HplHsmci.sendCommand(CMD18, SECTOR);
    }else if (state == S_WRITE){
      call HplHsmci.sendCommand(CMD24, SECTOR);
      //call HplHsmci.sendCommand(CMD25, SECTOR);
    }
  }

  command error_t Sam3uHsmci.writeBlock(uint32_t sector, uint32_t * buffer){
    call HplHsmci.setTxReg(buffer);
    atomic state = S_WRITE;
    SECTOR = sector;
    BUFFER = buffer;
    call HplHsmci.setTransState(1);
    return SUCCESS;
  }

  command error_t Sam3uHsmci.setBlockSize(uint16_t blocksize){
    // TODO: SET_BLOCK_LEN command
    call HplHsmci.sendCommand(CMD16,blocksize);
    return SUCCESS;
  }

  event void HplHsmciInterrupt.fired(uint32_t* buffer){
    // TODO: Done with read/writing a single block of data
    if(state == S_READ){
      signal Sam3uHsmci.readBlockDone(buffer);
    }else if(state == S_WRITE){
      signal Sam3uHsmci.writeBlockDone(buffer);
    }
    //call HplHsmci.sendCommand(CMD12, 0);
    atomic state = S_IDLE;
  }

  event void HplHsmciInterrupt.initDone(error_t error){
    atomic state = S_IDLE;
    signal Sam3uHsmci.initDone(error);
  }

  event void HplHsmciInterrupt.lengthConfigDone(error_t error){
    atomic state = S_IDLE;
    signal Sam3uHsmci.lengthConfigDone(error);
  }

  /*
  async event void available();     
  async event void unavailable();
  */

 default event void Sam3uHsmci.initDone(error_t error){}
 default event void Sam3uHsmci.lengthConfigDone(error_t error){}
}
