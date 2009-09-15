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

struct32bytes __attribute__((aligned(32))) structure; // 32 bytes aligned

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

		structure.word1 = 13;
		protected();

		call Leds.led0On(); // LED 0: successful write

		// activate MPU and write protect structure
		//call HplSam3uMpu.writeProtect(&structure);
		// activate MPU and execute protect protected()
		call HplSam3uMpu.executeProtect(&protected);

		structure.word1 = 42;
		protected();

		//call Leds.led1On(); // LED 1: successful protected write (should not happen)
		call Leds.led1On(); // LED 1: successful protected execute (should not happen)

		while(1);
	}

	async event void HplSam3uMpu.mpuFault()
	{
		call Leds.led2On(); // LED 2 (red): MPU fault
		//while(1);
	}
}
