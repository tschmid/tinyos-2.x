/**
 * Basic application to test the MPU and the corresponding exception.
 *
 * @author wanja@cs.fau.de
 **/

configuration TestMpuAppC
{
}
implementation
{
	components MainC, TestMpuC, LedsC, HplSam3uMpuC;

	TestMpuC -> MainC.Boot;
	TestMpuC.Leds -> LedsC;
	TestMpuC.HplSam3uMpu -> HplSam3uMpuC;
}
