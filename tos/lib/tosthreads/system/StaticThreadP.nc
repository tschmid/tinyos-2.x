/*
 * Copyright (c) 2008 Stanford University.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Stanford University nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */
 
/**
 * @author Kevin Klues <klueska@cs.stanford.edu>
 */

module StaticThreadP {
  provides {
    interface Thread[uint8_t id];
    interface ThreadNotification[uint8_t id];
  }
  uses {
    interface ThreadScheduler;
    interface ThreadSleep;
    interface ThreadInfo[uint8_t id];
    interface ThreadFunction[uint8_t id];
    interface ThreadCleanup[uint8_t id];
    interface Leds;
  }
}
implementation {

  error_t init(uint8_t id, void* arg) {
    error_t r1, r2;
    thread_t* thread_info = call ThreadInfo.get[id]();
    thread_info->start_arg_ptr = arg; 
    thread_info->mutex_count = 0;
    thread_info->next_thread = NULL;
    r1 = call ThreadInfo.reset[id]();
    r2 = call ThreadScheduler.initThread(id);
    return ecombine(r1, r2);
  }

#ifdef MPU_PROTECTION
  command error_t Thread.setupMpuRegion[uint8_t id](
    uint8_t regionNumber,
    bool enable,
    void *baseAddress,
    uint32_t size, // in bytes (bug: 4 GB not possible with this interface)
    bool enableInstructionFetch,
    bool enableReadPrivileged,
    bool enableWritePrivileged,
    bool enableReadUnprivileged,
    bool enableWriteUnprivileged,
    bool cacheable, // should be turned off for periphery and sys control (definitive guide, p. 213)
    bool bufferable, // should be turned off for sys control to be strongly ordered (definitive guide, p. 213)
    uint8_t disabledSubregions // bit = 1: subregion disabled
  ) {
    thread_t* thread_info;
    if (regionNumber > 7) return FAIL;

	// setup region info for context switch to deploy
    thread_info = call ThreadInfo.get[id]();
    thread_info->regions[regionNumber].enable = enable;
    thread_info->regions[regionNumber].baseAddress = baseAddress;
    thread_info->regions[regionNumber].size = size;
    thread_info->regions[regionNumber].enableInstructionFetch = enableInstructionFetch;
    thread_info->regions[regionNumber].enableReadPrivileged = enableReadPrivileged;
    thread_info->regions[regionNumber].enableWritePrivileged = enableWritePrivileged;
    thread_info->regions[regionNumber].enableReadUnprivileged = enableReadUnprivileged;
    thread_info->regions[regionNumber].enableWriteUnprivileged = enableWriteUnprivileged;
    thread_info->regions[regionNumber].cacheable = cacheable;
    thread_info->regions[regionNumber].bufferable = bufferable;
    thread_info->regions[regionNumber].disabledSubregions = disabledSubregions;

	return SUCCESS;
  }
#endif
  
  command error_t Thread.start[uint8_t id](void* arg) {
    atomic {
      if( init(id, arg) == SUCCESS ) {
        error_t e = call ThreadScheduler.startThread(id);
        if(e == SUCCESS) 
          signal ThreadNotification.justCreated[id]();
        return e;
      }
    }
    return FAIL;
  }
  
  command error_t Thread.pause[uint8_t id]() {
    return call ThreadScheduler.stopThread(id);
  }
  
  command error_t Thread.resume[uint8_t id]() {
    return call ThreadScheduler.startThread(id);
  }
  
  command error_t Thread.stop[uint8_t id]() {
    if(call ThreadScheduler.stopThread(id) == SUCCESS)
      return init(id, NULL);
    return FAIL;
  }
  
  command error_t Thread.sleep[uint8_t id](uint32_t milli) {
    return call ThreadSleep.sleep(milli);
  }
  
  command error_t Thread.join[uint8_t id]() {
    return call ThreadScheduler.joinThread(id);
  }
  
  event void ThreadFunction.signalThreadRun[uint8_t id](void *arg) {
    signal Thread.run[id](arg);
  }
  
  async event void ThreadCleanup.cleanup[uint8_t id]() {
    signal ThreadNotification.aboutToDestroy[id]();
  }
  
  default event void Thread.run[uint8_t id](void* arg) {}
  default async command thread_t* ThreadInfo.get[uint8_t id]() {return NULL;}
  default async command error_t ThreadInfo.reset[uint8_t id]() {return FAIL;}
  default async event void ThreadNotification.justCreated[uint8_t id]() {}
  default async event void ThreadNotification.aboutToDestroy[uint8_t id]() {}

}
