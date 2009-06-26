/*
 */
/** 
 * @author Thomas Schmid
 *
 */

#include "Timer.h"

configuration HilTimerMilliC
{
  provides interface Init;
  provides interface Timer<TMilli> as TimerMilli[ uint8_t num ];
  provides interface LocalTime<TMilli>;
}

implementation
{
  components new VirtualizeTimerC(TMilli,uniqueCount(UQ_TIMER_MILLI)) as VirtTimersMilli32;
  components new AlarmToTimerC(TMilli) as AlarmToTimerMilli32;
  components new AlarmMilliC() as AlarmMilli32;
  components STM32RtcC;

  Init = AlarmMilli32;
  TimerMilli = VirtTimersMilli32.Timer;
  LocalTime = STM32RtcC;
  
  VirtTimersMilli32.TimerFrom -> AlarmToTimerMilli32.Timer;
  AlarmToTimerMilli32.Alarm -> AlarmMilli32.Alarm;
}
