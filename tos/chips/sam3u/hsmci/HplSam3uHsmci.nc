// interface file

interface HplSam3uHsmci {
  command void configureHsmci();
  command void unlockRegisters();
  command void swReset();
  command void initConfigReg();
  command void setTxReg(uint32_t* data); 
  command void setRxReg(uint32_t* data);
  command void setTransState(uint8_t write);
  command void sendCommand(uint8_t command_number, uint32_t arg);
}