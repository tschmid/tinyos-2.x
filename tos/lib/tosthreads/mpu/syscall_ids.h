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
