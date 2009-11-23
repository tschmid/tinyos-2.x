interface HplSam3uPdc {
  command void setRxPtr(void* addr);
  command void setTxPtr(void* addr);
  command void setNextRxPtr(void* addr);
  command void setNextTxPtr(void* addr);

  command void setRxCounter(uint16_t counter);
  command void setTxCounter(uint16_t counter);
  command void setNextRxCounter(uint16_t counter);
  command void setNextTxCounter(uint16_t counter);

  command void enablePdcRx();
  command void enablePdcTx();
  command void disablePdcRx();
  command void disablePdcTx();

  command uint32_t rxEnabled();
  command bool txEnabled();
}