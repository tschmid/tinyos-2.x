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
    // Wire the pin interfaces
    components HilSam3uSpiC, HplSam3uGeneralIOC;
    components FastSpiSam3uC;
    RSTN = HplSam3uGeneralIOC.PioC1;
    SLP_TR = HplSam3uGeneralIOC.PioC2;
    SELN = HplSam3uGeneralIOC.PioC3;
    IRQ = HplSam3uGeneralIOC.CapturePioB0;

    // SPI resource
    SpiResource = HilSam3uSpiC.Resource;
    
    // Fast Spi byte
    FastSpiByte = FastSpiSam3uC.FastSpiByte;

    // Timestamping
    components HilTimerMilliC;
    LocalTimeRadio = HilTimerMilliC.LocalTime;

    // Radio alarm
    components new AlarmMilli16C(), RealMainP;
    Alarm = AlarmMilli16C.Alarm;
}

