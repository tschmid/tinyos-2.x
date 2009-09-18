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

void __attribute__((aligned(32))) protected() @C()
//void __attribute__((noinline)) protected() @C()
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

		structure.word1 = 13;
		//protected();

		call Leds.led0On(); // LED 0: successful write

		// activate MPU and write protect structure
		if ((call HplSam3uMpu.setupRegion(0, (void *) &structure, 32, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE, 0)) == FAIL) {
			while(1) {
				volatile int i;
				call Leds.led0Toggle();
				for (i = 0; i < 10000; i++);
			}
		}

		// activate MPU and execute protect protected()
		//call HplSam3uMpu.executeProtect(&protected);

		call HplSam3uMpu.enableMpu();

		structure.word1 = 42;
		//protected();

		call Leds.led1On(); // LED 1: successful protected write (should not happen)
		//call Leds.led1On(); // LED 1: successful protected execute (should not happen)

		while(1);
	}

	async event void HplSam3uMpu.mpuFault()
	{
		call Leds.led2On(); // LED 2 (red): MPU fault
		//while(1);
	}
}
