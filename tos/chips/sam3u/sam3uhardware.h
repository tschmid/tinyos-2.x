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
 * @author Wanja Hofer <wanja@cs.fau.de>
 */

#ifndef SAM3U_HARDWARE_H
#define SAM3U_HARDWARE_H

typedef uint32_t __nesc_atomic_t;

inline __nesc_atomic_t __nesc_atomic_start() @spontaneous() __attribute__((always_inline))
{
	__nesc_atomic_t oldState = 0;
	__nesc_atomic_t newState = 1;
	asm volatile(
		"mrs %[old], primask\n"
		"msr primask, %[new]\n"
		: [old] "=&r" (oldState) // output, assure write only!
		: [new] "r"  (newState)  // input
        : "cc", "memory"         // clobber condition code flag and memory
	);
	return oldState;
}
 
inline void __nesc_atomic_end(__nesc_atomic_t oldState) @spontaneous() __attribute__((always_inline))
{
	asm volatile("" : : : "memory"); // memory barrier
 
	asm volatile(
		"msr primask, %[old]"
		:                      // no output
		: [old] "r" (oldState) // input
	);
}

// See definitive guide to Cortex-M3, p. 141, 142
// Enables all exceptions except hard fault and NMI
inline void __nesc_enable_interrupt() __attribute__((always_inline))
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
inline void __nesc_disable_interrupt() __attribute__((always_inline))
{
	__nesc_atomic_t newState = 1;

	asm volatile(
		"msr primask, %0"
		: // output
		: "r" (newState) // input
	);
}

// Peripheral ID definitions for the SAM3U
//  Defined in AT91 ARM Cortex-M3 based Microcontrollers, SAM3U Series, Preliminary, p. 41
#define AT91C_ID_SUPC   ( 0) // SUPPLY CONTROLLER
#define AT91C_ID_RSTC   ( 1) // RESET CONTROLLER
#define AT91C_ID_RTC    ( 2) // REAL TIME CLOCK
#define AT91C_ID_RTT    ( 3) // REAL TIME TIMER
#define AT91C_ID_WDG    ( 4) // WATCHDOG TIMER
#define AT91C_ID_PMC    ( 5) // PMC
#define AT91C_ID_EFC0   ( 6) // EFC0
#define AT91C_ID_EFC1   ( 7) // EFC1
#define AT91C_ID_DBGU   ( 8) // DBGU
#define AT91C_ID_HSMC4  ( 9) // HSMC4
#define AT91C_ID_PIOA   (10) // Parallel IO Controller A
#define AT91C_ID_PIOB   (11) // Parallel IO Controller B
#define AT91C_ID_PIOC   (12) // Parallel IO Controller C
#define AT91C_ID_US0    (13) // USART 0
#define AT91C_ID_US1    (14) // USART 1
#define AT91C_ID_US2    (15) // USART 2
#define AT91C_ID_US3    (16) // USART 3
#define AT91C_ID_MCI0   (17) // Multimedia Card Interface
#define AT91C_ID_TWI0   (18) // TWI 0
#define AT91C_ID_TWI1   (19) // TWI 1
#define AT91C_ID_SPI0   (20) // Serial Peripheral Interface
#define AT91C_ID_SSC0   (21) // Serial Synchronous Controller 0
#define AT91C_ID_TC0    (22) // Timer Counter 0
#define AT91C_ID_TC1    (23) // Timer Counter 1
#define AT91C_ID_TC2    (24) // Timer Counter 2
#define AT91C_ID_PWMC   (25) // Pulse Width Modulation Controller
#define AT91C_ID_ADC12B (26) // 12-bit ADC Controller (ADC12B)
#define AT91C_ID_ADC    (27) // 10-bit ADC Controller (ADC)
#define AT91C_ID_HDMA   (28) // HDMA
#define AT91C_ID_UDPHS  (29) // USB Device High Speed

#endif // SAM3U_HARDWARE_H
