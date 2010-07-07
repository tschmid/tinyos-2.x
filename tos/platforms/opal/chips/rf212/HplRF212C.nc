/*
*/

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
    components HilSam3uSpiC as SpiC;
    components RF212SpiInitC as RadioSpiInitC;
    SpiResource = SpiC.Resource[1];
    FastSpiByte = SpiC.FastSpiByte[1];
    RadioSpiInitC -> SpiC.HplSam3uSpiChipSelConfig[1];
    SpiC.SpiChipInit[1] -> RadioSpiInitC;
     
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

