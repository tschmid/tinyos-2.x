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

#ifndef SYSCALL_IDS_H
#define SYSCALL_IDS_H

// 0x0 to 0xf reserved
#define SYSCALL_ID_READ                   0x10
#define SYSCALL_ID_STDCONTROL_START       0x11
#define SYSCALL_ID_STDCONTROL_STOP        0x12
#define SYSCALL_ID_AMSEND                 0x13
#define SYSCALL_ID_LEDS                   0x14
#define SYSCALL_ID_THREAD_SLEEP           0x15
#define SYSCALL_ID_THREAD_JOIN            0x16
#define SYSCALL_ID_THREAD_START           0x17
#define SYSCALL_ID_THREAD_PAUSE           0x18
#define SYSCALL_ID_THREAD_RESUME          0x19
#define SYSCALL_ID_THREAD_STOP            0x20

// LEDs functions
#define SYSCALL_LEDS_PARAM_ON              0x0
#define SYSCALL_LEDS_PARAM_OFF             0x1
#define SYSCALL_LEDS_PARAM_TOGGLE          0x2
#define SYSCALL_LEDS_PARAM_GET             0x3
#define SYSCALL_LEDS_PARAM_SET             0x4

// LEDs parameters
#define SYSCALL_LEDS_PARAM_LED0            0x0
#define SYSCALL_LEDS_PARAM_LED1            0x1
#define SYSCALL_LEDS_PARAM_LED2            0x2

#endif // SYSCALL_IDS_H
