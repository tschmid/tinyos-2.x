module SyscallInstructionC {
	provides interface SyscallInstruction;
}
implementation
{
	async command error_t SyscallInstruction.syscall(uint8_t id, uint32_t p0, uint32_t p1, uint32_t p2, uint32_t p3) __attribute__((section(".textcommon")))
	{
		volatile uint32_t result;

		asm volatile("mov r0, %0" : : "r" (p0));
		asm volatile("mov r1, %0" : : "r" (p1));
		asm volatile("mov r2, %0" : : "r" (p2));
		asm volatile("mov r3, %0" : : "r" (p3));

		asm volatile("svc %0" : : "i" (id));

		// result is in r0
		asm volatile("mov %0, r0" : "=r" (result));

		return result;
	}
}
