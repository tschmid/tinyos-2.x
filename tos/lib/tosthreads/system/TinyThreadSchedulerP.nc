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

module TinyThreadSchedulerP {
  provides {
    interface ThreadScheduler;
    interface Boot as TinyOSBoot;
    interface ThreadCleanup[uint8_t id];
  }
  uses {
    interface Boot as ThreadSchedulerBoot;
    interface ThreadInfo[uint8_t id];
    interface ThreadQueue;
    interface BitArrayUtils;
    interface McuSleep;
    interface GeneralIO as Led2;
    interface Timer<TMilli> as PreemptionAlarm;
  }
}
implementation {
  //Pointer to currently running thread
  thread_t* current_thread;
  //Pointer to the tos thread
  thread_t* tos_thread;
  //Pointer to yielding thread
  thread_t* yielding_thread;
  //Number of threads started, and currently capable of running if given the chance
  uint8_t num_runnable_threads;
  //Thread queue for keeping track of threads waiting to run
  thread_queue_t ready_queue;

#if defined(PLATFORM_SAM3U_EK) || defined(PLATFORM_OPAL)
  void context_switch() __attribute__((noinline));
  void restore_tcb() __attribute__((noinline));
#endif
  
  void task alarmTask() {
    uint8_t temp;
    atomic temp = num_runnable_threads;
    if(temp <= 1)
      call PreemptionAlarm.stop();
    else if(temp > 1)
      call PreemptionAlarm.startOneShot(TOSTHREAD_PREEMPTION_PERIOD);
  }
  
  /* switch_threads()
   * This routine swaps the stack and allows a thread to run.
   * Needs to be in a separate function like this so that the 
   * PC counter gets saved on the stack correctly.
   *
   * This funciton should have NOTHING other than the call
   * to the SWITCH_CONTEXTS macro in it.  Otherwise we run
   * the risk of variables being pushed and popped by the 
   * compiler, causing obvious problems with the stack switching
   * thats going on....
   */
  void switchThreads() __attribute__((noinline)) {
    SWITCH_CONTEXTS(yielding_thread, current_thread);
  }

  void restoreThread() __attribute__((noinline)) {
    RESTORE_TCB(current_thread);
  }

/**
 * On the Cortex-M3, context switching needs to be done in a special
 * exception because we need to distinguish between a context switch
 * being invoked from within an IRQ handler (preemption timer) or from
 * within the thread itself. The former sets a PendSV exception pending,
 * which will then execute after all other IRQ handlers have executed.
 * The latter synchronously invokes an SVCall exception, which has the
 * same handler aliased. For this distinction, see the macro
 * SWITCH_CONTEXTS() in chip_thread.h.
 */
#if defined(PLATFORM_SAM3U_EK) || defined(PLATFORM_OPAL)
/**
 * The two context switch exception handlers are naked to keep the compiler
 * from using the stack. We need a manually defined stack layout here, which
 * we artificially create using PREPARE_THREAD() (see chip_thread.h). That is
 * why we need to manually save volatile (caller-save) registers before calling
 * another (non-inlined) function. That's also why they need the flatten
 * attribute, so that the atomic functions are definitely inlined here.
 */
  void PendSVHandler() @C() @spontaneous() __attribute__((naked, flatten))
  {
    atomic { // context switch itself is protected from being interrupted
      asm volatile("mrs r0, msp");
      asm volatile("stmdb r0!, {r1-r12,lr}");
      asm volatile("str r0, %0" : "=m" ((yielding_thread)->stack_ptr));
      asm volatile("ldr r0, %0" : : "m" ((current_thread)->stack_ptr));
      asm volatile("ldmia r0!, {r1-r12,lr}");
      asm volatile("msr msp, r0");
    }
    asm volatile("bx lr"); // important because this is a naked function
  }

  void context_switch() __attribute__((noinline, naked, flatten))
  {
    atomic { // context switch itself is protected from being interrupted
      asm volatile("mrs r0, msp");
      asm volatile("stmdb r0!, {r1-r12,lr}");
      asm volatile("str r0, %0" : "=m" ((yielding_thread)->stack_ptr));
      asm volatile("ldr r0, %0" : : "m" ((current_thread)->stack_ptr));
      asm volatile("ldmia r0!, {r1-r12,lr}");
      asm volatile("msr msp, r0");
    }
    asm volatile("bx lr"); // important because this is a naked function
  }

  void restore_tcb() __attribute__((noinline, naked, flatten))
  {
    atomic { // context switch itself is protected from being interrupted
  	  asm volatile("ldr r0, %0" : : "m" ((current_thread)->stack_ptr));
  	  asm volatile("ldmia r0!, {r1-r12,lr}");
  	  asm volatile("msr msp, r0");
    }
    asm volatile("bx lr"); // important because this is a naked function
  }

  void ActualSVCallHandler(uint32_t *args) @C() @spontaneous()
  {
    volatile uint32_t svc_id;
    volatile uint32_t svc_r0;
    volatile uint32_t svc_r1;
    volatile uint32_t svc_r2;
    volatile uint32_t svc_r3;
    volatile uint32_t prev_pc; // PC to return to after the syscall

    svc_id = ((uint8_t *) args[6])[-2];
    svc_r0 = ((uint32_t) args[0]);
    svc_r1 = ((uint32_t) args[1]);
    svc_r2 = ((uint32_t) args[2]);
    svc_r3 = ((uint32_t) args[3]);
    prev_pc = ((uint32_t) args[6]);

    if (svc_id == 0) { // context-switch syscall
	  context_switch();
    } else if (svc_id == 1) { // restore-TCB syscall
	  restore_tcb();
    }

    return; // this will return to svc call site
  }

  void SVCallHandler() @C() @spontaneous() __attribute__((naked))
  {
    asm volatile(
      "tst lr, #4\n"
      "ite eq\n"
      "mrseq r0, msp\n"
      "mrsne r0, psp\n"
      "b ActualSVCallHandler\n"
    );
    // return from ActualSVCallHandler() returns to svc call site (through lr)
  }
#endif
  
  /* sleepWhileIdle() 
   * This routine is responsible for putting the mcu to sleep as 
   * long as there are no threads waiting to be run.  Once a
   * thread has been added to the ready queue the mcu will be
   * woken up and the thread will start running
   */
  void sleepWhileIdle() {
    while(TRUE) {
      bool mt;
      atomic mt = (call ThreadQueue.isEmpty(&ready_queue) == TRUE);
      if(!mt || tos_thread->state == TOSTHREAD_STATE_READY) break;
      call McuSleep.sleep();
    }
  }
  
  /* schedule_next_thread()
   * This routine does the job of deciding which thread should run next.
   * Should be complete as is.  Add functionality to getNextThreadId() 
   * if you need to change the actual scheduling policy.
   */
  void scheduleNextThread() {
    if(tos_thread->state == TOSTHREAD_STATE_READY)
      current_thread = tos_thread;
    else
      current_thread = call ThreadQueue.dequeue(&ready_queue);

    current_thread->state = TOSTHREAD_STATE_ACTIVE;
  }
  
  /* interrupt()
   * This routine figures out what thread should run next
   * and then switches to it.
   */
  void interrupt(thread_t* thread) {
    yielding_thread = thread;
    scheduleNextThread();
    if(current_thread != yielding_thread) {
      switchThreads();
    }
  }
  
  /* suspend()
   * this routine is responsbile for suspending a thread.  It first 
   * checks to see if the mcu should be put to sleep based on the fact 
   * that the thread is being suspended.  If not, it proceeds to switch
   * contexts to the next thread on the ready queue.
   */
  void suspend(thread_t* thread) {
    //if there are no active threads, put the MCU to sleep
    //Then wakeup the TinyOS thread whenever the MCU wakes up again
    #ifdef TOSTHREADS_TIMER_OPTIMIZATION
      num_runnable_threads--;
	  post alarmTask();    
	#endif
    sleepWhileIdle();
    interrupt(thread);
  }
  
  void wakeupJoined(thread_t* t) {
    int i,j,k;
    k = 0;
    for(i=0; i<sizeof(t->joinedOnMe); i++) {
      if(t->joinedOnMe[i] == 0) {
        k+=8;
        continue;
      }
      for(j=0; j<8; j++) {
        if(t->joinedOnMe[i] & 0x1)
          call ThreadScheduler.wakeupThread(k);
        t->joinedOnMe[i] >>= 1;
        k++;
      }
    }
  }
  
  /* stop
   * This routine stops a thread by putting it into the inactive state
   * and decrementing any necessary variables used to keep track of
   * threads by the thread scheduler.
   */
  void stop(thread_t* t) {
    t->state = TOSTHREAD_STATE_INACTIVE;
    num_runnable_threads--;
    wakeupJoined(t);
    #ifdef TOSTHREADS_TIMER_OPTIMIZATION
	  post alarmTask();    
	#else
      if(num_runnable_threads == 1)
        call PreemptionAlarm.stop();
    #endif
    signal ThreadCleanup.cleanup[t->id]();
  }

  thread_t *thread_prolog() __attribute__((noinline))
  {
    thread_t* t;
    atomic t = current_thread;

    __nesc_enable_interrupt();

	return t;
  }

  void thread_epilog(thread_t *t) __attribute__((noinline))
  {
    atomic {
      stop(t);
      sleepWhileIdle();
      scheduleNextThread();
      restoreThread();
    }
  }
  
  /* This executes and cleans up a thread
   */
  void threadWrapper() __attribute__((naked, noinline)) {
    thread_t* t;
    atomic t = current_thread;
    
    __nesc_enable_interrupt();
    (*(t->start_ptr))(t->start_arg_ptr);
    
    atomic {
      stop(t);
      sleepWhileIdle();
      scheduleNextThread();
      restoreThread();
    }
  }
  
  event void ThreadSchedulerBoot.booted() {
    num_runnable_threads = 0;
    tos_thread = call ThreadInfo.get[TOSTHREAD_TOS_THREAD_ID]();
    tos_thread->id = TOSTHREAD_TOS_THREAD_ID;
    call ThreadQueue.init(&ready_queue);
    
    current_thread = tos_thread;
    current_thread->state = TOSTHREAD_STATE_ACTIVE;
    current_thread->init_block = NULL;

    signal TinyOSBoot.booted();
  }
  
  command error_t ThreadScheduler.initThread(uint8_t id) { 
    thread_t* t = (call ThreadInfo.get[id]());
    t->state = TOSTHREAD_STATE_INACTIVE;
    atomic t->init_block = current_thread->init_block;
    call BitArrayUtils.clrArray(t->joinedOnMe, sizeof(t->joinedOnMe));
    PREPARE_THREAD(t, threadWrapper);
    return SUCCESS;
  }
  
  command error_t ThreadScheduler.startThread(uint8_t id) {
    atomic {
      thread_t* t = (call ThreadInfo.get[id]());
      if(t->state == TOSTHREAD_STATE_INACTIVE) {
        num_runnable_threads++;
        #ifdef TOSTHREADS_TIMER_OPTIMIZATION
          post alarmTask();
        #else 
          if(num_runnable_threads == 2)
            call PreemptionAlarm.startOneShot(TOSTHREAD_PREEMPTION_PERIOD);
        #endif
        t->state = TOSTHREAD_STATE_READY;
        call ThreadQueue.enqueue(&ready_queue, t);
        return SUCCESS;
      }
    }
    return FAIL;  
  }
  
  command error_t ThreadScheduler.stopThread(uint8_t id) { 
    atomic {
      thread_t* t = call ThreadInfo.get[id]();
      if((t->state == TOSTHREAD_STATE_READY) && (t->mutex_count == 0)) {
        call ThreadQueue.remove(&ready_queue, t);
        stop(t);
        return SUCCESS;
      }
      return FAIL;
    }
  }
  
  async command error_t ThreadScheduler.suspendCurrentThread() {
    atomic {
      if(current_thread->state == TOSTHREAD_STATE_ACTIVE) {
        current_thread->state = TOSTHREAD_STATE_SUSPENDED;
        suspend(current_thread);
        return SUCCESS;
      }
      return FAIL;
    }
  }
  
  async command error_t ThreadScheduler.interruptCurrentThread() { 
    atomic {
      if(current_thread->state == TOSTHREAD_STATE_ACTIVE) {
        current_thread->state = TOSTHREAD_STATE_READY;
        if(current_thread != tos_thread)
          call ThreadQueue.enqueue(&ready_queue, current_thread);
        interrupt(current_thread);
        return SUCCESS;
      }
      return FAIL;
    }
  }
  
  async command error_t ThreadScheduler.joinThread(thread_id_t id) { 
    thread_t* t = call ThreadInfo.get[id]();
    atomic {
      if(current_thread == tos_thread)
        return FAIL;
      if (t->state != TOSTHREAD_STATE_INACTIVE) {
        call BitArrayUtils.setBit(t->joinedOnMe, current_thread->id);
        call ThreadScheduler.suspendCurrentThread();
        return SUCCESS;
      }
    }
    return EALREADY;
  }
  
  async command error_t ThreadScheduler.wakeupThread(uint8_t id) {
    thread_t* t = call ThreadInfo.get[id]();
    if((t->state) == TOSTHREAD_STATE_SUSPENDED) {
      t->state = TOSTHREAD_STATE_READY;
      if(t != tos_thread) {
        call ThreadQueue.enqueue(&ready_queue, call ThreadInfo.get[id]());
        #ifdef TOSTHREADS_TIMER_OPTIMIZATION
          atomic num_runnable_threads++;
          post alarmTask();
        #endif
      }
      return SUCCESS;
    }
    return FAIL;
  }
  
  async command uint8_t ThreadScheduler.currentThreadId() {
    atomic return current_thread->id;
  }    
  
  async command thread_t* ThreadScheduler.threadInfo(uint8_t id) {
    atomic return call ThreadInfo.get[id]();
  }   
  
  async command thread_t* ThreadScheduler.currentThreadInfo() {
    atomic return current_thread;
  }
  
  event void PreemptionAlarm.fired() {
    call PreemptionAlarm.startOneShot(TOSTHREAD_PREEMPTION_PERIOD);
    atomic {
      if((call ThreadQueue.isEmpty(&ready_queue) == FALSE)) {
        call ThreadScheduler.interruptCurrentThread();
      }
    }
  }
  
  default async command thread_t* ThreadInfo.get[uint8_t id]() {
    return NULL;
  }
}
