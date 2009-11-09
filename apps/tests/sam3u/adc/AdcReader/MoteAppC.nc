//#include "StorageVolumes.h"

configuration MoteAppC {}

implementation
{
  // ========== Data download ========== //
  components MainC,
    LedsC, NoLedsC,
    new TimerMilliC() as UserButtonTimerC,
    SerialActiveMessageC,
    new SerialAMSenderC(0),
  //UserButtonC,
    AdcReaderC,
  //  Counter32khz32C,
  //new LogStorageC(VOLUME_LOG, TRUE),
    MoteP;
             
  MoteP.Boot -> MainC;
  MoteP.Leds -> LedsC;
  //MoteP.ReadStream -> AdcReaderC;
  MoteP.Read -> AdcReaderC;
  MoteP.SerialSplitControl -> SerialActiveMessageC;
  MoteP.AMSend -> SerialAMSenderC;
  MoteP.Packet -> SerialActiveMessageC;
  
  //MoteP.LogWrite -> LogStorageC;
  //MoteP.LogRead -> LogStorageC;
  
  //MoteP.UserButtonNotify -> UserButtonC;
  MoteP.UserButtonTimer -> UserButtonTimerC;
  
  //MoteP.Counter -> Counter32khz32C;
}
