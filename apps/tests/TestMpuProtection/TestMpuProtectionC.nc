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

module TestMpuProtectionC
{
	uses interface Leds;
	uses interface Boot;
	uses interface Thread as Thread1;
	uses interface Thread as Thread2;
}
implementation
{
	// does not normally have to be volatile, but here it does
	// so that the compiler does not optimize the artificial check
	// for manipulation in the test case
	volatile struct32bytes data1; // belongs to thread 1

	volatile struct32bytes data2; // belongs to thread 2

	void fatal();

	void wait() {
		volatile unsigned int i; 
		for (i = 0; i < 1000000; i++);
	}  

	event void Boot.booted()
	{
		call Thread1.start(NULL);
		call Thread2.start(NULL);
	}

	event void Thread1.run(void* arg)
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

	event void Thread2.run(void* arg)
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

#if 0
	async event void HplSam3uMpu.mpuFault()
	{
		call Leds.led2On(); // LED 2 (red): MPU fault
		while(1); // wait
	}
#endif
}
