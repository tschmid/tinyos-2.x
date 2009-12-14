/**
 * Basic application to test thread isolation.
 *
 * @author wanja@cs.fau.de
 **/

configuration TestMpuProtectionAppC
{
}
implementation
{
	components MainC, TestMpuProtectionC, LedsC;
	components new ThreadC(0x400) as Thread0;
	components new ThreadC(0x400) as Thread1;

	TestMpuProtectionC -> MainC.Boot;
	TestMpuProtectionC.Leds -> LedsC;
	TestMpuProtectionC.Thread0 -> Thread0;
	TestMpuProtectionC.Thread1 -> Thread1;
#ifdef MPU_PROTECTION
	components HplSam3uMpuC;
	TestMpuProtectionC.HplSam3uMpu -> HplSam3uMpuC;
#endif
}
