interface HplSam3uHsmciInterrupt {
  event void fired(uint32_t *buffer);
  event void initDone(error_t error);
  event void lengthConfigDone(error_t error);
  event void setTransDone();
}
