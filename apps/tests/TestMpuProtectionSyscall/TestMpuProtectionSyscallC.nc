extern unsigned int _stextthread0;
extern unsigned int _etextthread0;
extern unsigned int _sbssthread0;
extern unsigned int _ebssthread0;
extern unsigned int _sdatathread0;
extern unsigned int _edatathread0;

module TestMpuProtectionSyscallC
{
	uses
	{
		interface Boot;
		interface Thread as Thread0;
		interface BlockingRead<uint16_t>;
		interface BlockingStdControl as AMControl;
		interface BlockingAMSend;
		//interface Packet;
		interface Leds;
	}
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

		// thread-specific code: ThreadInfoP$0$run_thread(), TestMpuProtectionC$Thread0$run()
		call Thread0.setupMpuRegion(2, TRUE, (void *) &_stextthread0, (((uint32_t) &_etextthread0) - ((uint32_t) &_stextthread0)), /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, code
		// thread-specific BSS: n/a
		if (&_sbssthread0 != &_ebssthread0) {
			call Thread0.setupMpuRegion(3, TRUE, (void *) &_sbssthread0, (((uint32_t) &_ebssthread0) - ((uint32_t) &_sbssthread0)), /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, SRAM
		} else {
			call Thread0.setupMpuRegion(3, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00);
		}
		// thread-specific data: n/a
		if (&_sdatathread0 != &_edatathread0) {
			call Thread0.setupMpuRegion(4, TRUE, (void *) &_sdatathread0, (((uint32_t) &_edatathread0) - ((uint32_t) &_sdatathread0)), /*X*/ TRUE, /*RP*/ TRUE, /*WP*/ TRUE, /*RU*/ TRUE, /*WU*/ TRUE, /*C*/ TRUE, /*B*/ TRUE, 0x00); // 512 MB, SRAM
		} else {
			call Thread0.setupMpuRegion(4, FALSE, (void *) 0x00000000, 32, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 0x00);
		}
#endif
	}

	event void Thread0.run(void* arg) __attribute__((noinline))
	{
		uint16_t* var = NULL;
		message_t msg;
		//var = call Packet.getPayload(&msg, sizeof(uint16_t));

		while( call AMControl.start() != SUCCESS );    
		for(;;){
			while( call BlockingRead.read(var) != SUCCESS );
			while( call BlockingAMSend.send(AM_BROADCAST_ADDR, &msg, sizeof(uint16_t)) != SUCCESS );
			call Leds.led0Toggle();
			wait();
		}
	}
}
