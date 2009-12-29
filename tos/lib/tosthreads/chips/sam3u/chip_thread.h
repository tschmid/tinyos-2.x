/*
 * Copyright (c) 2009 Stanford University.
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
 * @author Wanja Hofer <wanja@cs.fau.de>
 */

// see Cortex-M3 Technical Reference Manual, p. 2-4
typedef struct thread_regs {
	// we store all our regs on the stack (one ARM instruction)
} thread_regs_t;

typedef uint32_t* stack_ptr_t;

// stack grows from big to smaller addresses
#define STACK_TOP(stack, size) \
	(&(((uint8_t*)stack)[size - sizeof(stack_ptr_t)]))

/*
 * Stack-frame layout from bottom to top:
 * - Initial PSW: 0x01000000
 * - Program counter PC: pointer to thread function (i.e., thread wrapper)
 * - Link register LR: invalid value 0xffffffff, because the outer thread
 *   function (i.e., the wrapper) is never supposed to return!
 * - r0 to r3, r12: would be saved by the corresponding exception (SVCall
 *   or PendSV)
 * - r1 to r12: saved by context-switch routine (see TinyThreadSchedulerP)
 *   (r0 is used by context-switch routine)
 * - lr: also saved by context-switch routine (see TinyThreadSchedulerP),
 *   initialized to 0xfffffff9 (i.e., exception return, to thread mode and
 *   main stack)
 */
#define PREPARE_THREAD(t, thread_ptr) \
*((t)->stack_ptr) = (uint32_t)(0x01000000); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(&(thread_ptr)); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0xffffffff); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0x12121212); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0x03030303); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0x02020202); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0x01010101); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0x00000000); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0xfffffff9); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0x12121212); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0x11111111); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0x10101010); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0x09090909); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0x08080808); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0x07070707); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0x06060606); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0x05050505); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0x04040404); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0x03030303); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0x02020202); \
\
((t)->stack_ptr) -= 1; *((t)->stack_ptr) = (uint32_t)(0x01010101); \
;

/*
 * The context-switch call distinguishes between its being called
 * asynchronously from within an IRQ handler (timer interrupt) or
 * synchronously from within a thread (yield / end of thread). It
 * then either requests a PendSV exception to be executed after the
 * IRQ handler returns, or it invokes an SVCall with parameter 0,
 * which is executed promptly.
 *
 * With memory protection, there is the additional case that a
 * context switch is requested from within a running system call.
 * That will be noticed by comparing the active vector to 0xb, which
 * is the SVCall exception. In that case, the context switch routine
 * is jumped to directly.
 *
 * The restore-TCB call does the same thing, except that it uses
 * SVCall with parameter 1, which indicates that the current context
 * does not need to be saved. This should always happen with no
 * IRQ being active, so the infinite loop should never be entered.
 *
 * The corresponding register addresses are hard-coded because
 * wiring in the target component (TinyThreadSchedulerP) is not
 * possible if this is defined as a macro.
 */

// FIXME: The enable IRQ statement is currently a hack, since invoking
// a system call w/ IRQs disabled results in a usage fault.
// This should be properly synchronized eventually.

#define SWITCH_CONTEXTS(from,to) \
uint32_t icsr = *((volatile uint32_t *) 0xe000ed04); \
uint16_t vectactive = icsr & 0x000001ff; \
if (vectactive == 0) { \
	__nesc_enable_interrupt(); \
	asm volatile("svc 0"); \
} else if (vectactive == 0xb) { \
	context_switch(); \
} else { \
	*((volatile uint32_t *) 0xe000ed04) = 0x10000000; \
}

#define RESTORE_TCB(t) \
uint32_t icsr = *((volatile uint32_t *) 0xe000ed04); \
uint16_t vectactive = icsr & 0x000001ff; \
if (vectactive == 0) { \
	__nesc_enable_interrupt(); \
	asm volatile("svc 1"); \
} else { \
	restore_tcb(); \
}

/*
 * Documentation:
 *
 * CM3 TR, p. 2-9: Saved xPSR bits
 * On entering an exception, the processor saves the combined information from the three
 * status registers on the stack.
 *
 * CM3 TR, p. 5-9:
 * Only one stack, the process stack or the main stack, is visible at any time. After pushing
 * the eight registers, the ISR uses the main stack, and all subsequent interrupt
 * pre-emptions use the main stack. The stack that saves context is as follows:
 *
 * Thread mode uses either the main stack or the process stack, depending on the
 * value of the CONTROL bit [1] that Move to Status Register (MSR) or Move to
 * Register from Status (MRS) can access. Appropriate EXC_RETURN values can
 * also set this bit when exiting an ISR. An exception that pre-empts a user thread
 * saves the context of the user thread on the stack that the Thread mode is using.
 *
 * Using the process stack for the Thread mode and the main stack for exceptions supports
 * Operating System (OS) scheduling. To reschedule, the kernel only requires to save the
 * eight registers not pushed by hardware, r4-r11, and to copy SP_process into the Thread
 * Control Block (TCB). If the processor saved the context on the main stack, the kernel
 * would have to copy the 16 registers to the TCB.
 *
 * CM3 TR, p. 5-11:
 * When the processor invokes an exception, it automatically pushes the following eight
 * registers to the SP in the following order:
 * - Program Counter (PC)
 * - Processor Status Register (xPSR)
 * - r0-r3
 * - r12
 * - Link Register (LR).
 *
 * SAM3U, p. 54:
 * The processor uses a full descending stack. This means the stack pointer indicates the last
 * stacked item on the stack memory. When the processor pushes a new item onto the stack, it
 * decrements the stack pointer and then writes the item to the new memory location.
 */
