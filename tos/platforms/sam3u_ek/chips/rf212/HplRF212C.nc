/*
 * CSIRO fleck3c, Christian.Richter@csiro.au
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
        interface Alarm<TRadio, uint32_t> as Alarm;
	}
}

implementation
{
    // Wire the pin interfaces
    components HilSam3uSpiC, HplSam3uGeneralIOC;
    SELN = HplSam3uGeneralIOC.PioA19;
    SLP_TR = HplSam3uGeneralIOC.PioA24;
    RSTN = HplSam3uGeneralIOC.PioA2;
    IRQ = HplSam3uGeneralIOC.CapturePioA1;

    // SPI resource
    SpiResource = HilSam3uSpiC.Resource;
    
    // Fast Spi byte
    FastSpiByte = HilSam3uSpiC.FastSpiByte;

    // Timestamping
    components HilTimerMilliC;
    LocalTimeRadio = HilTimerMilliC.LocalTime;

    // Radio alarm
    components new AlarmMilliC(), RealMainP;
//    RealMainP.PlatformInit -> AlarmMilliC.Init;
    Alarm = AlarmMilliC.Alarm;
}
