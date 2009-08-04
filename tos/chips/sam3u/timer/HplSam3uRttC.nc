configuration HplSam3uRttC
{

    provides
    {
        interface Init;
        interface Rtt;
    }
}

implementation
{
    components HplSam3uRttP, HplNVICC;

    Init = HplSam3uRttP;
    Rtt = HplSam3uRttP;

    HplSam3uRttP.HplNVICCntl -> HplNVICC;
    HplSam3uRttP.NVICRTTInterrupt -> HplNVICC.RTTInterrupt;
}
