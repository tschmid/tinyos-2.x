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
  components new HalPXA27xAlarmM(TMilli,2) as PhysAlarmMilli32;
  components HalPXA27xOSTimerMapC;
  components CounterMilliC;
  enum {OST_CLIENT_ID = unique("PXA27xOSTimer.Resource")};

  Init = PhysAlarmMilli32;
  TimerMilli = VirtTimersMilli32.Timer;
  LocalTime = CounterMilliC;
  
  VirtTimersMilli32.TimerFrom -> AlarmToTimerMilli32.Timer;
  AlarmToTimerMilli32.Alarm -> PhysAlarmMilli32.Alarm;
  
  PhysAlarmMilli32.OSTInit -> HalPXA27xOSTimerMapC.Init;
  PhysAlarmMilli32.OSTChnl -> HalPXA27xOSTimerMapC.OSTChnl[OST_CLIENT_ID];

}
