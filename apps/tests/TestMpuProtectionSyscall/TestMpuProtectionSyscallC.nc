extern unsigned int _stextcommon;
extern unsigned int _etextcommon;
extern unsigned int _stextthread0;
extern unsigned int _etextthread0;
extern unsigned int _sbssthread0;
extern unsigned int _ebssthread0;
extern unsigned int _sdatathread0;
extern unsigned int _edatathread0;
extern unsigned int _sbsscommon;
extern unsigned int _ebsscommon;

module TestMpuProtectionSyscallC
{
	uses
	{
		interface Boot;
		interface Thread as Thread0;
		interface BlockingRead<uint16_t>;
		//interface BlockingStdControl as AMControl;
		//interface BlockingAMSend;
		//interface Packet;
		interface Leds;
	}
#ifdef MPU_PROTECTION
	uses interface HplSam3uMpu;
#endif
}
implementation
{
	void wait() {
		volatile unsigned int i;  
		for (i = 0; i < 1000000; i++);
	}   

	event void Boot.booted()
	{
		call Thread0.start(NULL);

#ifdef MPU_PROTECTION
		// MPU region setup has to be *after* thread start because init() sets all regions to disabled

		call HplSam3uMpu.enableDefaultBackgroundRegion(); // for privileged code
		call HplSam3uMpu.disableMpuDuringHardFaults();

		// common code: TinyThreadSchedulerP$threadWrapper(), StaticThreadP$ThreadFunction$signalThreadRun() (here: inlined?)
		call Thread0.setupMpuRegion(0, TRUE, (void *) &_stextcommon, (((uint32_t) &_etextcommon) - ((uint32_t) &_stextcommon)), /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, code
		// thread-specific code: ThreadInfoP$0$run_thread(), TestMpuProtectionC$Thread0$run()
		call Thread0.setupMpuRegion(1, TRUE, (void *) &_stextthread0, (((uint32_t) &_etextthread0) - ((uint32_t) &_stextthread0)), /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, code
		// ThreadInfoP$0$stack
		call Thread0.setupMpuRegion(2, TRUE, (void *) 0x20000400, 0x400, /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, SRAM
		// needed for LED: 0x400e0e34
		call Thread0.setupMpuRegion(3, TRUE, (void *) 0x400e0000, 0x10000, /*X*/ FALSE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ FALSE, /*B*/ TRUE, 0x00); // 512 MB, periphery
		// thread-specific BSS: n/a
		if (&_sbssthread0 != &_ebssthread0) {
			call Thread0.setupMpuRegion(4, TRUE, (void *) &_sbssthread0, (((uint32_t) &_ebssthread0) - ((uint32_t) &_sbssthread0)), /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, SRAM
		} else {
			call Thread0.setupMpuRegion(4, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00);
		}
		// thread-specific data: n/a
		if (&_sdatathread0 != &_edatathread0) {
			call Thread0.setupMpuRegion(5, TRUE, (void *) &_sdatathread0, (((uint32_t) &_edatathread0) - ((uint32_t) &_sdatathread0)), /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, SRAM
		} else {
			call Thread0.setupMpuRegion(5, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00);
		}
		// common BSS: TinyThreadSchedulerP$current_thread (ro would be enough), ThreadInfoP$0$thread_info (should be specific to the thread)
		if (&_sbsscommon != &_ebsscommon) {
			call Thread0.setupMpuRegion(6, TRUE, (void *) &_sbsscommon, (((uint32_t) &_ebsscommon) - ((uint32_t) &_sbsscommon)), /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, SRAM
		} else {
			call Thread0.setupMpuRegion(6, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00);
		}
		call Thread0.setupMpuRegion(7, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00);
#endif
	}

	event void Thread0.run(void* arg) __attribute__((noinline))
	{
		uint16_t* var = NULL;
		//message_t msg;
		//var = call Packet.getPayload(&msg, sizeof(uint16_t));

		//while( call AMControl.start() != SUCCESS );    
		for(;;){
			while( call BlockingRead.read(var) != SUCCESS );
			//while( call BlockingAMSend.send(AM_BROADCAST_ADDR, &msg, sizeof(uint16_t)) != SUCCESS );
			call Leds.led0Toggle();
			wait();
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
