/**
 * Implementation for TestLeds application. Count up a counter
 * and display it using the LEDs.
 **/

module TestLedsC
{
	uses interface Leds;
	uses interface Boot;
}
implementation
{
	event void Boot.booted()
	{
		uint8_t counter = 0;

		while (1) {
			volatile int i = 0;
			for (i = 0; i < 20000; i++);
			}
			counter++;
			counter = counter % 8;
			if (counter & 0x1) {
				call Leds.led0On();
			} else {
				call Leds.led0Off();
			}
			if (counter & 0x2) {
				call Leds.led1On();
			}
			} else {
				call Leds.led1Off();
			}
			if (counter & 0x4) {
				call Leds.led2On();
			}
			} else {
				call Leds.led2Off();
			}
		}
	}
}
