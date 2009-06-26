/*
 */
/** 
 * @author Thomas Schmid
 *
 */

configuration CounterMilliC
{
  provides interface Counter<TMilli,uint32_t> as CounterMilli32;
  provides interface LocalTime<TMilli> as LocalTimeMilli;
}

implementation
{
  components STM32RtcC;
  components PlatformP;

  CounterMilli32 = STM32RtcC.Counter;
  LocalTimeMilli = STM32RtcC.LocalTime;

  // Wire the initialization to the plaform init routine
  PlatformP.Init -> STM32RtcC.Init;
}

