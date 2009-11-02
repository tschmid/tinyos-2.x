typedef struct
{
	uint32_t word1;
	uint32_t word2;
	uint32_t word3;
	uint32_t word4;
	uint32_t word5;
	uint32_t word6;
	uint32_t word7;
	uint32_t word8;
} struct32bytes;

extern unsigned int _stextcommon;
extern unsigned int _etextcommon;
extern unsigned int _stextthread0;
extern unsigned int _etextthread0;
extern unsigned int _stextthread1;
extern unsigned int _etextthread1;

module TestMpuProtectionC
{
	uses interface Leds;
	uses interface Boot;
	uses interface Thread as Thread0;
	uses interface Thread as Thread1;
#ifdef MPU_PROTECTION
	uses interface HplSam3uMpu;
#endif
}
implementation
{
	// does not normally have to be volatile, but here it does
	// so that the compiler does not optimize the artificial check
	// for manipulation in the test case
	volatile struct32bytes data1; // belongs to thread 0

	volatile struct32bytes data2; // belongs to thread 1

	void fatal();

	void wait() {
		volatile unsigned int i; 
		for (i = 0; i < 1000000; i++);
	}  

	event void Boot.booted()
	{
		call Thread0.start(NULL);
		call Thread1.start(NULL);

#ifdef MPU_PROTECTION
		// MPU region setup has to be *after* thread start because init() sets all regions to disabled

		/*
		SAM3U Manual, p. 225:
		Flash memory b000 1 0 0 Normal memory, Non-shareable, write-through
		Internal SRAM b000 1 0 1 Normal memory, Shareable, write-through
		External SRAM b000 1 1 1 Normal memory, Shareable, write-back, write-allocate
		Peripherals b000 0 1 1 Device memory, Shareable

		SAM3U Manual, p. 72: Memory map

		command error_t setupMpuRegion(
			uint8_t regionNumber,
			bool enable,
			void *baseAddress,
			uint32_t size, // in bytes (bug: 4 GB not possible with this interface)
			bool enableInstructionFetch,
			bool enableReadPrivileged,
			bool enableWritePrivileged,
			bool enableReadUnprivileged,
			bool enableWriteUnprivileged,
			bool cacheable, // should be turned off for periphery and sys control (definitive guide, p. 213)
			bool bufferable, // should be turned off for sys control to be strongly ordered (definitive guide, p. 213)
			uint8_t disabledSubregions // bit = 1: subregion disabled
		);

		TRUE == 1; FALSE == 0;
		*/
#if 0
		// Memory map setup (SAM3U Manual, p. 72)
		call Thread0.setupMpuRegion(0, TRUE, (void *) 0x00000000, 536870912, /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, code
		call Thread0.setupMpuRegion(1, TRUE, (void *) 0x20000000, 536870912, /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, SRAM
		call Thread0.setupMpuRegion(2, TRUE, (void *) 0x40000000, 536870912, /*X*/ FALSE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ FALSE, /*B*/ TRUE, 0x00); // 512 MB, periphery
		call Thread0.setupMpuRegion(3, TRUE, (void *) 0x60000000, 1073741824, /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 1 GB, ext. RAM
		call Thread0.setupMpuRegion(4, TRUE, (void *) 0xa0000000, 1073741824, /*X*/ FALSE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 1 GB, ext. devices
		call Thread0.setupMpuRegion(5, TRUE, (void *) 0xe0000000, 1048576, /*X*/ FALSE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ FALSE, /*B*/ FALSE, 0x00); // 1 MB, sys control
		call Thread0.setupMpuRegion(6, TRUE, (void *) 0xe0100000, 535822336, /*X*/ FALSE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 511 MB, reserved
		call Thread0.setupMpuRegion(7, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00);
#endif

		call HplSam3uMpu.enableDefaultBackgroundRegion(); // for privileged code
		call HplSam3uMpu.disableMpuDuringHardFaults();

		// common code: TinyThreadSchedulerP$threadWrapper(), StaticThreadP$ThreadFunction$signalThreadRun()
		call Thread0.setupMpuRegion(0, TRUE, (void *) &_stextcommon, (((uint32_t) &_etextcommon) - ((uint32_t) &_stextcommon)), /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, code
		// thread-specific code: ThreadInfoP$0$run_thread(), TestMpuProtectionC$Thread0$run()
		call Thread0.setupMpuRegion(1, TRUE, (void *) &_stextthread0, (((uint32_t) &_etextthread0) - ((uint32_t) &_stextthread0)), /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, code
		// needed for data
		// ThreadInfoP$0$stack
		call Thread0.setupMpuRegion(2, TRUE, (void *) 0x20000000, 0x800, /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, SRAM
		// needed for LED
		// 0x400e0e34
		call Thread0.setupMpuRegion(3, TRUE, (void *) 0x400e0000, 0x10000, /*X*/ FALSE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ FALSE, /*B*/ TRUE, 0x00); // 512 MB, periphery
		// data1: 0x200006b8 + 0x20
		call Thread0.setupMpuRegion(4, TRUE, (void *) 0x20000600, 0x100, /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, SRAM
		call Thread0.setupMpuRegion(5, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00);
		call Thread0.setupMpuRegion(6, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00);
		call Thread0.setupMpuRegion(7, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00);
                                              
		// common code: TinyThreadSchedulerP$threadWrapper(), StaticThreadP$ThreadFunction$signalThreadRun()
		call Thread1.setupMpuRegion(0, TRUE, (void *) &_stextcommon, (((uint32_t) &_etextcommon) - ((uint32_t) &_stextcommon)), /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, code
		// thread-specific code: ThreadInfoP$1$run_thread(), TestMpuProtectionC$Thread1$run()
		call Thread1.setupMpuRegion(1, TRUE, (void *) &_stextthread1, (((uint32_t) &_etextthread1) - ((uint32_t) &_stextthread1)), /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, code
		// needed for data
		// ThreadInfoP$1$stack
		call Thread1.setupMpuRegion(2, TRUE, (void *) 0x20000000, 0x1000, /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, SRAM
		// needed for LED
		// 0x400e0e34
		call Thread1.setupMpuRegion(3, TRUE, (void *) 0x400e0000, 0x10000, /*X*/ FALSE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ FALSE, /*B*/ TRUE, 0x00); // 512 MB, periphery
		// foreign data1: allow or disallow
		call Thread1.setupMpuRegion(4, TRUE, (void *) 0x20000600, 0x100, /*X*/ TRUE, /*RP*/ FALSE, /*WP*/ FALSE, /*RU*/ FALSE, /*WU*/ FALSE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, SRAM
		//call Thread1.setupMpuRegion(4, TRUE, (void *) 0x20000600, 0x100, /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, SRAM
		call Thread1.setupMpuRegion(5, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00);
		call Thread1.setupMpuRegion(6, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00);
		call Thread1.setupMpuRegion(7, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00);
#endif
	}

	event void Thread0.run(void* arg) __attribute__((noinline))
	{
		// initialize own data
		data1.word1 = 1;
		data1.word2 = 1;
		data1.word3 = 1;
		data1.word4 = 1;
		data1.word5 = 1;
		data1.word6 = 1;
		data1.word7 = 1;
		data1.word8 = 1;

		// check if data has been manipulated
		while (1) {
			if (data1.word1 != 1) {
				call Leds.led1On(); // LED 1 (green): data has been manipulated
			}
		}
	}

	event void Thread1.run(void* arg) __attribute__((noinline))
	{
		volatile uint32_t i;

		for (i = 0; i < 4; i++) {
			// wait for some time
			wait();
		}

		// then manipulate foreign data
		call Leds.led0On(); // LED 0 (green): manipulation attempt about to happen
		data1.word1 = 2;

		while (1); // wait forever
	}

	void fatal()
	{
		while (1) {
			volatile int i;
			for (i = 0; i < 100000; i++);
			call Leds.led2Toggle(); // Led 2 (red) blinking: fatal
		}
	}

#ifdef MPU_PROTECTION
	async event void HplSam3uMpu.mpuFault()
	{
		call Leds.led2On(); // LED 2 (red): MPU fault
		while (1); // wait
	}
#endif
}
