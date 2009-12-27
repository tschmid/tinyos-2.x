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
