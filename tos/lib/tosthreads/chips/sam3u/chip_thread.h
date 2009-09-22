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

// see Cortex-M3 Technical Reference Manual, p. 2-4
typedef struct thread_regs {
	//uint32_t psr; // ?
//	uint32_t r0;
//	uint32_t r1;
//	uint32_t r2;
//	uint32_t r3;
//	uint32_t r4;
//	uint32_t r5;
//	uint32_t r6;
//	uint32_t r7;
//	uint32_t r8;
//	uint32_t r9;
//	uint32_t r10;
//	uint32_t r11;
//	uint32_t r12;
//	//uint32_t r13; // SP
//	uint32_t r14; // LR
//	uint32_t r15; // PC
} thread_regs_t;

typedef uint32_t* stack_ptr_t;

// stack grows from big to smaller addresses
#define STACK_TOP(stack, size) \
	(&(((uint8_t*)stack)[size - sizeof(stack_ptr_t)]))
  
// save stack pointer
#define SAVE_STACK_PTR(t) \
	__asm__ __volatile__("str.w r13,%0" : "=m" ((t)->stack_ptr))

// save other regs
#define SAVE_GPR(t)                        			\
	__asm__ __volatile__("push {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, lr}");
  
// restore stack pointer
#define RESTORE_STACK_PTR(t)           			 	\
  __asm__ __volatile__("ldr.w r13,%0" : : "m" ((t)->stack_ptr))

// restore other regs
#define RESTORE_GPR(t)           	         		\
	__asm__ __volatile__("pop {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, lr}");
  
#define SAVE_TCB(t) \
  SAVE_GPR(t);	 	\
  SAVE_STACK_PTR(t) 
  
#define RESTORE_TCB(t)  \
  RESTORE_STACK_PTR(t); \
  RESTORE_GPR(t)
  
#define SWITCH_CONTEXTS(from, to) \
  SAVE_TCB(from);				  \
  RESTORE_TCB(to)

#define SWAP_STACK_PTR(OLD, NEW)   			\
  __asm__("str.w r13,%0" : "=m" (OLD));		\
  __asm__("ldr.w r13,%0" : : "m" (NEW))
  
// 14 regs (including lr)
#define PREPARE_THREAD(t, thread_ptr)		\
  *((t)->stack_ptr) = (uint32_t)(&(thread_ptr)); \
  ((t)->stack_ptr) -= 13;
