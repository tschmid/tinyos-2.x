module TestSvcC
{
	uses interface Leds;
	uses interface Boot;
}
implementation
{
	error_t syscall(uint8_t id, uint32_t p0, uint32_t p1, uint32_t p2, uint32_t p3)
	{
		volatile uint32_t result;

		//__nesc_disable_interrupt();

		asm volatile("mov r0, %0" : : "r" (p0));
		asm volatile("mov r1, %0" : : "r" (p1));
		asm volatile("mov r2, %0" : : "r" (p2));
		asm volatile("mov r3, %0" : : "r" (p3));
		asm volatile("svc %0" : : "i" (id));

		// result is in r0
		asm volatile("mov %0, r0" : "=r" (result));

		return result;
	}

	event void Boot.booted()
	{
		volatile uint32_t result = syscall(0x42, 0x00, 0x11, 0x22, 0x33);

		result++;

		while(1);

		return;
	}

	void ActualSVCallHandler(uint32_t *args) @C() @spontaneous()
	{
		volatile uint32_t svc_id;
		volatile uint32_t svc_r0;
		volatile uint32_t svc_r1;
		volatile uint32_t svc_r2;
		volatile uint32_t svc_r3;

		svc_id = ((uint8_t *) args[6])[-2];
		svc_r0 = ((uint32_t) args[0]);
		svc_r1 = ((uint32_t) args[1]);
		svc_r2 = ((uint32_t) args[2]);
		svc_r3 = ((uint32_t) args[3]);

		args[0] = 0x23;

		return;
	}

	void SVCallHandler() @C() @spontaneous() __attribute__((naked))
	{
		asm volatile(
		"tst lr, #4\n"
		"ite eq\n"
		"mrseq r0, msp\n"
		"mrsne r0, psp\n"
		"b ActualSVCallHandler\n"
		);
		// return from ActualSVCallHandler() returns to svc call site (through lr)
	}
}
