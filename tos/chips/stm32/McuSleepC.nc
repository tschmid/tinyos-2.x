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
 * Implementation of TEP 112 (Microcontroller Power Management) for
 * the STM32
 *
 * @author Thomas Schmid
 *
 */

module McuSleepC {
  provides {
    interface McuSleep;
    interface McuPowerState;
  }
  uses {
    interface McuPowerOverride;
  }
}
implementation {
  
  async command void McuSleep.sleep() {
    // Put idle into here.
    /*
    asm volatile (
		  "mcr p14,0,%0,c7,c0,0"
		  : 
		  : "r" (PWRMODE_M_IDLE)
		  );
    __nesc_enable_interrupt();
    // All of memory may change at this point...
    asm volatile ("" : : : "memory");
    __nesc_disable_interrupt();
    */
    return;
  }

  async command void McuPowerState.update() {

    return;
  }

 default async command mcu_power_t McuPowerOverride.lowestState() {
   return 0;
 }

}
