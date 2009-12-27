configuration TestRestoreTcbAppC
{
}
implementation
{
	components MainC, TestRestoreTcbC, LedsC;
	components new ThreadC(0x200) as Thread0;
	components new ThreadC(0x200) as Thread1;
	components new ThreadC(0x200) as Thread2;

	TestRestoreTcbC -> MainC.Boot;
	TestRestoreTcbC.Leds -> LedsC;
	TestRestoreTcbC.Thread0 -> Thread0;
	TestRestoreTcbC.Thread1 -> Thread1;
	TestRestoreTcbC.Thread2 -> Thread2;
}
