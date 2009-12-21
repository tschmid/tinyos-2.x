interface SyscallInstruction {
	async command uint32_t syscall(uint8_t id, uint32_t p0, uint32_t p1, uint32_t p2, uint32_t p3);
}
