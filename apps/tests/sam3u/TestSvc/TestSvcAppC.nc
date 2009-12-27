configuration TestSvcAppC
{
}
implementation
{
	components MainC, TestSvcC, LedsC;

	TestSvcC -> MainC.Boot;
	TestSvcC.Leds -> LedsC;
}
