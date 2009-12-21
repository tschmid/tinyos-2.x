module SyscallInstructionC {
	provides interface SyscallInstruction;
}
implementation
{
	async command uint32_t SyscallInstruction.syscall(uint8_t id, uint32_t p0, uint32_t p1, uint32_t p2, uint32_t p3) __attribute__((section(".textcommon")))
	{
		volatile uint32_t result;

		asm volatile(
			"mov r0, %[arg0]\n"
			"mov r1, %[arg1]\n"
			"mov r2, %[arg2]\n"
			"mov r3, %[arg3]\n"
			"svc %[sysid]\n"
			"mov %[res], r0\n"
			: [res] "=r" (result) // output operands
			: [arg0] "r" (p0), [arg1] "r" (p1), [arg2] "r" (p2), [arg3] "r" (p3), [sysid] "i" (id) // input operands
			: "r0", "r1", "r2", "r3" // clobber list
		);
		return result;
	}
}
