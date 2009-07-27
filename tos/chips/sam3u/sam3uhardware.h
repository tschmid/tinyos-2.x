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
