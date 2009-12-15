/**
 * Basic app to test thread isolation with system calls.
 * Based on Kevin's TestSineSensorAppC.
 *
 * @author wanja@cs.fau.de
 */

configuration TestMpuProtectionSyscallAppC
{
}
implementation
{
	components MainC, TestMpuProtectionSyscallC;
	components new ThreadC(0x400) as Thread0;

	components new BlockingSineSensorC();
	components BlockingSerialActiveMessageC;
	components new BlockingSerialAMSenderC(228);

	MainC.Boot <- TestMpuProtectionSyscallC;
	MainC.SoftwareInit -> BlockingSineSensorC;
	TestMpuProtectionSyscallC.Thread0 -> Thread0;
	TestMpuProtectionSyscallC.BlockingRead -> BlockingSineSensorC;
	TestMpuProtectionSyscallC.AMControl -> BlockingSerialActiveMessageC;
	TestMpuProtectionSyscallC.BlockingAMSend -> BlockingSerialAMSenderC;
	//TestMpuProtectionSyscallC.Packet -> BlockingSerialAMSenderC;

	components LedsC;
	TestMpuProtectionSyscallC.Leds -> LedsC;

#ifdef MPU_PROTECTION
	components HplSam3uMpuC;
	TestMpuProtectionSyscallC.HplSam3uMpu -> HplSam3uMpuC;
#endif
}
