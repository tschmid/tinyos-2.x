#include <RadioConfig.h>

configuration HplRF212C
{
    provides
    {
        // pin interfaces
        interface GeneralIO as SELN;
        interface GeneralIO as SLP_TR;
        interface GeneralIO as RSTN;
        interface GpioCapture as IRQ;
        
        // SPI
        interface Resource as SpiResource;
        interface FastSpiByte;
        
        // for Timestamping
        interface LocalTime<TRadio> as LocalTimeRadio;
        
        // Radio alarm (see RadioConfig.h)
        interface Alarm<TRadio, uint16_t> as Alarm;
    }
}

implementation
{
    components new Sam3uSpi1C() as SpiC;
    SpiResource = SpiC;
    FastSpiByte = SpiC;

    components RF212SpiConfigC as RadioSpiConfigC;
    RadioSpiConfigC.Init <- SpiC;
    RadioSpiConfigC.ResourceConfigure <- SpiC;
    RadioSpiConfigC.HplSam3uSpiChipSelConfig -> SpiC;
     
    // Wire the pin interfaces
    components HplSam3uGeneralIOC;
    RSTN = HplSam3uGeneralIOC.PioC1;
    SLP_TR = HplSam3uGeneralIOC.PioC2;
    SELN = HplSam3uGeneralIOC.PioC3;
    IRQ = HplSam3uGeneralIOC.CapturePioB0;
 
    // Timestamping
    components LocalTimeMicroC;
    LocalTimeRadio = LocalTimeMicroC;
 
    // Radio alarm
    components new AlarmTMicro16C(), RealMainP;
    Alarm = AlarmTMicro16C.Alarm;
}

