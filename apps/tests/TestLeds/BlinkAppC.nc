/**
 * Basic application that tests the platform LEDs.
 * In contrast to Blink, it does not use the timer yet.
 *
 * @author wanja@cs.fau.de
 **/

configuration TestLedsAppC
{
}
implementation
{
	components MainC, TestLedsC, LedsC;

	TestLedsC -> MainC.Boot;
	TestLedsC.Leds -> LedsC;
}
