// interface file
interface Sam3uHsmci {

  command error_t init();

  command uint32_t readCardSize();
  command error_t readBlock(uint32_t sector, uint32_t * buffer);
  command error_t writeBlock(uint32_t sector, uint32_t * buffer);
  command error_t setBlockSize(uint16_t blocksize);

  event void readBlockDone(uint32_t *buffer);     
  event void writeBlockDone(uint32_t *buffer);

  event void initDone(error_t error);
  event void lengthConfigDone(error_t error);
}