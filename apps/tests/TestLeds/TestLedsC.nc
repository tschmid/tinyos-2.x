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

			counter++;
			counter = counter % 8;
			call Leds.set(counter);
		}
	}
}
