configuration HplSam3uTCC
{

    provides
    {
        interface HplSam3uTCChannel as TC0;
        interface HplSam3uTCChannel as TC1;
        interface HplSam3uTCChannel as TC2;
    }
}

implementation
{
    components 
        new HplSam3uTCChannelP(TC_CH0_BASE) as TCCH0,
        new HplSam3uTCChannelP(TC_CH1_BASE) as TCCH1,
        new HplSam3uTCChannelP(TC_CH2_BASE) as TCCH2,
        new HplNVICC;

    TC0 = TCCH0;
    TC1 = TCCH1;
    TC2 = TCCH2;

    TCCH0.Overflow -> TCCH0.Event[0]; 
    TCCH0.NVICTCInterrupt -> HplNVICC.TC0Interrupt;

    TCCH1.Overflow -> TCCH1.Event[0]; 
    TCCH1.NVICTCInterrupt -> HplNVICC.TC1Interrupt;

    TCCH2.Overflow -> TCCH2.Event[0]; 
    TCCH2.NVICTCInterrupt -> HplNVICC.TC2Interrupt;
}
