configuration HplSam3uTwiC {
  provides interface HplSam3uTwiInterrupt;
  provides interface HplSam3uTwi;
}
implementation{

  enum {
    CLIENT_ID = unique( SAM3U_HPLTWI_RESOURCE ),
  };

  components HplSam3uTwiP as TwiP;
  
  HplSam3uTwiInterrupt = TwiP.HplSam3uTwiInterrupt;
  HplSam3uTwi = TwiP.HplSam3uTwi;


}