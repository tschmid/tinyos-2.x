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
 * Adapted to include information about a thread's MPU settings.
 *
 * @author Kevin Klues <klueska@cs.stanford.edu>
 * @author Wanja Hofer <wanja@cs.fau.de>
 */

extern unsigned int _stextthread0;
extern unsigned int _etextthread0;
extern unsigned int _stextthread1;
extern unsigned int _etextthread1;
extern unsigned int _stextthread2;
extern unsigned int _etextthread2;
extern unsigned int _stextthread3;
extern unsigned int _etextthread3;
extern unsigned int _sbssthread0;
extern unsigned int _ebssthread0;
extern unsigned int _sbssthread1;
extern unsigned int _ebssthread1;
extern unsigned int _sbssthread2;
extern unsigned int _ebssthread2;
extern unsigned int _sbssthread3;
extern unsigned int _ebssthread3;
extern unsigned int _sdatathread0;
extern unsigned int _edatathread0;
extern unsigned int _sdatathread1;
extern unsigned int _edatathread1;
extern unsigned int _sdatathread2;
extern unsigned int _edatathread2;
extern unsigned int _sdatathread3;
extern unsigned int _edatathread3;

generic module ThreadInfoP(uint16_t stack_size, uint8_t thread_id) {
  provides {
    interface Init;
    interface ThreadInfo;
    interface ThreadFunction;
  }
  uses {
    interface Leds;
    interface HplSam3uMpuSettings;
  }
}
implementation {
  // the stack has to be word-aligned on SAM3U,
  // otherwise we'll get bus faults
  // both variables have to be static for -fdata-sections to put
  // them into separate sections
  static uint8_t stack[stack_size] __attribute__((aligned(4)));
  static thread_t thread_info;
  
  void run_thread(void* arg) __attribute__((noinline)) {
    signal ThreadFunction.signalThreadRun(arg);
  }

  error_t init() {
    atomic {
      thread_info.next_thread = NULL;
      thread_info.id = thread_id;
      thread_info.init_block = NULL;
      thread_info.stack_ptr = (stack_ptr_t)(STACK_TOP(stack, sizeof(stack)));
      thread_info.state = TOSTHREAD_STATE_INACTIVE;
      thread_info.mutex_count = 0;
      thread_info.start_ptr = run_thread;
      thread_info.start_arg_ptr = NULL;
      thread_info.syscall = NULL;
	}
	{
		// MPU setup

		uint32_t stext = 0, etext = 0, sbss = 0, ebss = 0, sdata = 0, edata = 0;
		error_t result = SUCCESS;

		if (thread_id == 0) {
			stext = (uint32_t) &_stextthread0; etext = (uint32_t) &_etextthread0; sbss = (uint32_t) &_sbssthread0; ebss = (uint32_t) &_ebssthread0; sdata = (uint32_t) &_sdatathread0; edata = (uint32_t) &_edatathread0;
		} else if (thread_id == 1) {
			stext = (uint32_t) &_stextthread1; etext = (uint32_t) &_etextthread1; sbss = (uint32_t) &_sbssthread1; ebss = (uint32_t) &_ebssthread1; sdata = (uint32_t) &_sdatathread1; edata = (uint32_t) &_edatathread1;
		} else if (thread_id == 2) {
			stext = (uint32_t) &_stextthread2; etext = (uint32_t) &_etextthread2; sbss = (uint32_t) &_sbssthread2; ebss = (uint32_t) &_ebssthread2; sdata = (uint32_t) &_sdatathread2; edata = (uint32_t) &_edatathread2;
		} else if (thread_id == 3) {
			stext = (uint32_t) &_stextthread3; etext = (uint32_t) &_etextthread3; sbss = (uint32_t) &_sbssthread3; ebss = (uint32_t) &_ebssthread3; sdata = (uint32_t) &_sdatathread3; edata = (uint32_t) &_edatathread3;
		}

		if (stext != etext) {
			result = ecombine(result, call HplSam3uMpuSettings.getMpuSettings(0, TRUE, (void *) stext, etext - stext, /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00, &(thread_info.regions[0].rbar), &(thread_info.regions[0].rasr)));
		} else {
			result = ecombine(result, call HplSam3uMpuSettings.getMpuSettings(0, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00, &(thread_info.regions[0].rbar), &(thread_info.regions[0].rasr)));
		}

		if (sbss != ebss) {
			result = ecombine(result, call HplSam3uMpuSettings.getMpuSettings(1, TRUE, (void *) sbss, ebss - sbss, /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00, &(thread_info.regions[1].rbar), &(thread_info.regions[1].rasr)));
		} else {
			result = ecombine(result, call HplSam3uMpuSettings.getMpuSettings(1, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00, &(thread_info.regions[1].rbar), &(thread_info.regions[1].rasr)));
		}

		if (sdata != edata) {
			result = ecombine(result, call HplSam3uMpuSettings.getMpuSettings(2, TRUE, (void *) sdata, edata - sdata, /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00, &(thread_info.regions[2].rbar), &(thread_info.regions[2].rasr)));
		} else {
			result = ecombine(result, call HplSam3uMpuSettings.getMpuSettings(2, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00, &(thread_info.regions[2].rbar), &(thread_info.regions[2].rasr)));
		}

		return result;
	}
  }
  
  command error_t Init.init() {
    return init();
  }
  
  async command error_t ThreadInfo.reset() {
    return init();
  }
  
  async command thread_t* ThreadInfo.get() {
    return &thread_info;
  }
}
