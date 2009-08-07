configuration HalSam3uRttC
{
    provides
    {
        interface Init;
        interface Alarm<TMilli,uint32_t> as Alarm;
        interface LocalTime<TMilli> as LocalTime;
    }
}

implementation
{
    components HplSam3uRttC, HalSam3uRttP;

    HalSam3uRttP.HplSam3uRtt -> HplSam3uRttC;
    HalSam3uRttP.RttInit -> HplSam3uRttC.Init;

    Init = HalSam3uRttP;
    Alarm = HalSam3uRttP;
    LocalTime = HalSam3uRttP;
}    


