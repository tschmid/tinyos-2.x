configuration HplSam3uRttC
{

    provides
    {
        interface Init;
        interface HplSam3uRtt;
    }
}

implementation
{
    components HplSam3uRttP, HplNVICC;

    Init = HplSam3uRttP;
    HplSam3uRtt = HplSam3uRttP;

    HplSam3uRttP.HplNVICCntl -> HplNVICC;
    HplSam3uRttP.NVICRTTInterrupt -> HplNVICC.RTTInterrupt;

	components PlatformInterruptC;
	HplSam3uRttP.PlatformInterrupt -> PlatformInterruptC;
}
