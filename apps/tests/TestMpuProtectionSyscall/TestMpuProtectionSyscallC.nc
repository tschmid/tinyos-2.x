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

		// Memory map setup (SAM3U Manual, p. 72)
		call Thread0.setupMpuRegion(0, TRUE, (void *) 0x00000000, 536870912, /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, code
		call Thread0.setupMpuRegion(1, TRUE, (void *) 0x20000000, 536870912, /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, SRAM
		call Thread0.setupMpuRegion(2, TRUE, (void *) 0x40000000, 536870912, /*X*/ FALSE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ FALSE, /*B*/ TRUE, 0x00); // 512 MB, periphery
		call Thread0.setupMpuRegion(3, TRUE, (void *) 0x60000000, 1073741824, /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 1 GB, ext. RAM
		call Thread0.setupMpuRegion(4, TRUE, (void *) 0xa0000000, 1073741824, /*X*/ FALSE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 1 GB, ext. devices
		call Thread0.setupMpuRegion(5, TRUE, (void *) 0xe0000000, 1048576, /*X*/ FALSE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ FALSE, /*B*/ FALSE, 0x00); // 1 MB, sys control
		call Thread0.setupMpuRegion(6, TRUE, (void *) 0xe0100000, 535822336, /*X*/ FALSE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 511 MB, reserved
		call Thread0.setupMpuRegion(7, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00);

#if 0
		// common code: TinyThreadSchedulerP$threadWrapper(), StaticThreadP$ThreadFunction$signalThreadRun()
		call Thread0.setupMpuRegion(0, TRUE, (void *) &_stextcommon, (((uint32_t) &_etextcommon) - ((uint32_t) &_stextcommon)), /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, code
		// thread-specific code: ThreadInfoP$0$run_thread(), TestMpuProtectionC$Thread0$run()
		call Thread0.setupMpuRegion(1, TRUE, (void *) &_stextthread0, (((uint32_t) &_etextthread0) - ((uint32_t) &_stextthread0)), /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, code
		// ThreadInfoP$0$stack
		call Thread0.setupMpuRegion(2, TRUE, (void *) 0x20000600, 0x200, /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, SRAM
		// needed for LED: 0x400e0e34
		call Thread0.setupMpuRegion(3, TRUE, (void *) 0x400e0000, 0x10000, /*X*/ FALSE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ FALSE, /*B*/ TRUE, 0x00); // 512 MB, periphery
		// thread-specific BSS: data0
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
		// common BSS: TinyThreadSchedulerP$current_thread (ro would be enough), ThreadInfoP$1$thread_info, ThreadInfoP$0$thread_info (should both be specific to each thread)
		call Thread0.setupMpuRegion(6, TRUE, (void *) &_sbsscommon, (((uint32_t) &_ebsscommon) - ((uint32_t) &_sbsscommon)), /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, SRAM
		call Thread0.setupMpuRegion(7, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00);
#endif
#endif
	}

	event void Thread0.run(void* arg)
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
