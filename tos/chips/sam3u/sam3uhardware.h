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
 * Definitions specific to the SAM3U MCU.
 * Includes interrupt enable/disable routines for nesC.
 *
 * @author wanja@cs.fau.de
 */

#ifndef SAM3U_HARDWARE_H
#define SAM3U_HARDWARE_H

typedef uint32_t __nesc_atomic_t;

inline __nesc_atomic_t __nesc_atomic_start() @spontaneous()
{
	__nesc_atomic_t oldState = 0;
	__nesc_atomic_t newState = 0;

	asm volatile(
		"mrs %0, primask\n"
		"msr primask, %1\n"
		: "=r" (oldState) // output
		: "r" (newState) // input
	);

	asm volatile("" : : : "memory"); // memory barrier

	return oldState;
}

inline void __nesc_atomic_end(__nesc_atomic_t oldState) @spontaneous()
{
	asm volatile("" : : : "memory"); // memory barrier

	asm volatile(
		"msr primask, %0"
		: // output
		: "r" (oldState) // input
	);
}

// See definitive guide to Cortex-M3, p. 141, 142
// Enables all exceptions except hard fault and NMI
inline void __nesc_enable_interrupt()
{
	__nesc_atomic_t newState = 0;

	asm volatile(
		"msr primask, %0"
		: // output
		: "r" (newState) // input
	);
}

// See definitive guide to Cortex-M3, p. 141, 142
// Disables all exceptions except hard fault and NMI
inline void __nesc_disable_interrupt()
{
	__nesc_atomic_t newState = 1;

	asm volatile(
		"msr primask, %0"
		: // output
		: "r" (newState) // input
	);
}
#endif // SAM3U_HARDWARE_H
