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

// Real Time Timer Register definition
typedef struct rtt {
    volatile uint32_t rtmr;	// Real Time Mode Register
    volatile uint32_t rtar;	// Real Time Alarm Register
    volatile uint32_t rtvr;	// Real Time Value Register
    volatile uint32_t rtsr;	// Real Time Status Register
} rtt_t, *prtt_t;

#define BASE_RTTC (prtt_t 0x400E1230) // (RTTC) Base Address

// -------- RTTC_RTMR : (RTTC Offset: 0x0) Real-time Mode Register --------
#define RTTC_RTPRES     (0xFFFF <<  0) // (RTTC) Real-time Timer Prescaler Value
#define RTTC_ALMIEN     (0x1 << 16) // (RTTC) Alarm Interrupt Enable
#define RTTC_RTTINCIEN  (0x1 << 17) // (RTTC) Real Time Timer Increment Interrupt Enable
#define RTTC_RTTRST     (0x1 << 18) // (RTTC) Real Time Timer Restart
// -------- RTTC_RTAR : (RTTC Offset: 0x4) Real-time Alarm Register --------
#define RTTC_ALMV       (0x0 <<  0) // (RTTC) Alarm Value
// -------- RTTC_RTVR : (RTTC Offset: 0x8) Current Real-time Value Register --------
#define RTTC_CRTV       (0x0 <<  0) // (RTTC) Current Real-time Value
// -------- RTTC_RTSR : (RTTC Offset: 0xc) Real-time Status Register --------
#define RTTC_ALMS       (0x1 <<  0) // (RTTC) Real-time Alarm Status
#define RTTC_RTTINC     (0x1 <<  1) // (RTTC) Real-time Timer Increment


#endif // SAM3U_HARDWARE_H
