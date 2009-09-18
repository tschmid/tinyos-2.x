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

volatile struct32bytes __attribute__((aligned(32))) structure; // 32 bytes aligned

void  __attribute__((noinline)) __attribute__((aligned(32))) protected() @C()
{
	volatile int i = 0;
	for (; i < 50; i++);
}

module TestMpuC
{
	uses interface Leds;
	uses interface Boot;
	uses interface HplSam3uMpu;
}
implementation
{
	void fatal();

	event void Boot.booted()
	{
		// FIXME hack
		// setup IRQ, p. 8-28, MEMFAULTENA = 1
		uint32_t value = *((volatile uint32_t *) 0xe000ed24);
		value |= 0x00010000;
		*((volatile uint32_t *) 0xe000ed24) = value;

		// setup MPU
		call HplSam3uMpu.enableDefaultBackgroundRegion();
		call HplSam3uMpu.disableMpuDuringHardFaults();

//		structure.word1 = 13;
		protected();

		call Leds.led0On(); // LED 0: successful write/execute

		// activate MPU and write-protect structure
		//if ((call HplSam3uMpu.setupRegion(0, (void *) &structure, 32, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE, 0)) == FAIL) {
		//	fatal();
		//}

		// activate MPU and execute-protect protected()
		if ((call HplSam3uMpu.setupRegion(0, (void *) (((uint32_t) &protected) & (~ (32 - 1))), 32, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, 0)) == FAIL) {
		//if ((call HplSam3uMpu.setupRegion(0, (void *) &protected, 32, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, 0)) == FAIL) { // unaligned
			fatal();
		}

		call HplSam3uMpu.enableMpu();

//		structure.word1 = 42;
		protected();

		call Leds.led1On(); // LED 1: successful protected write/execute (should not happen)

		while(1);
	}

	void fatal()
	{
		while(1) {
			volatile int i;
			for (i = 0; i < 100000; i++);
			call Leds.led2Toggle(); // Led 2 (red) blinking: fatal
		}
	}

	async event void HplSam3uMpu.mpuFault()
	{
		call Leds.led2On(); // LED 2 (red): MPU fault
		//while(1);
	}
}
