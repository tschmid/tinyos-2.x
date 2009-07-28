/*
 * Copyright (c) 2009 University of California, Los Angeles 
 * All rights reserved. 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *	Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *	Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 */
/**
 * @author Thomas Schmid
 */
#include "hardware.h"

configuration PlatformC
{
  provides {
      interface Init;
      interface PlatformReset;
  }
}

implementation
{
  components PlatformP, MoteClockC, McuSleepC, HplSTM32InterruptM;

  Init = PlatformP;
  PlatformReset = PlatformP;
  PlatformP.Interrupt -> HplSTM32InterruptM;
  PlatformP.MoteClockInit -> MoteClockC;
  PlatformP.McuSleepInit -> McuSleepC;
  McuSleepC.MoteClockInit -> MoteClockC;

}
