module TestRestoreTcbC
{
	uses {
		interface Boot;
		interface Thread as Thread0;
		interface Thread as Thread1;
		interface Thread as Thread2;
		interface Leds;
	}
}
implementation
{
	event void Boot.booted() {
		call Thread0.start(NULL);
		call Thread1.start(NULL);
		call Thread2.start(NULL);
	}

	event void Thread0.run(void* arg) __attribute__((noinline)) {
		call Leds.led0On();
		// exit, calling RESTORE_TCB() internally
		// should then schedule and dispatch thread 1
	}

	event void Thread1.run(void* arg) __attribute__((noinline)) {
		call Leds.led1On();
		// exit, calling RESTORE_TCB() internally
		// should then schedule and dispatch thread 2
	}

	event void Thread2.run(void* arg) __attribute__((noinline)) {
		call Leds.led2On();
		while (1);
	}
}
