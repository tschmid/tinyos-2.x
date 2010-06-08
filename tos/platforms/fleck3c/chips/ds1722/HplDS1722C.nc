/**
 * (C) Copyright CSIRO Australia, 2009
 * All rights reserved
 *
 * This file include the platform layer that wires IO pins etc to this sensor.
 * Easier said, this file provides a hardware abstraction that is used to build
 * the device driver on top of it.
 *
 * @author Christian.Richter@csiro.au
 */
configuration HplDS1722C {
    provides {
        interface GeneralIO as SEL_PIN;
        interface Resource as SpiResource;
        interface FastSpiByte;
    }
}

implementation {
    /* Wire the pin */
    components HplAtm128GeneralIOC as IO;
    SEL_PIN = IO.PortA5; /* we proxy it through this layer */

    /* SPI access */
    components Atm128SpiC as SpiC;
    SpiResource = SpiC.Resource[unique("Atm128SpiC.Resource")];
    FastSpiByte = SpiC; /* we proxy SpiC */

    /* and the init of this layer + what the private module needs for it */
    components HplDS1722P, RealMainP;
    HplDS1722P.SEL_PIN -> IO.PortA5;
    RealMainP.PlatformInit -> HplDS1722P.DS1722Init;
}
