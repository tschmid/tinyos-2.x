/**
 * (C) Copyright CSIRO Australia, 2009
 * All rights reserved
 *
 * This file include the driver configuration which ties the Hpl together with
 * the state machine aware code and provide the read interface to it.
 *
 * @author Christian.Richter@csiro.au
 */
configuration DS1722DriverC {
    provides interface Read<uint16_t> as TempRead;
}

implementation {
    components DS1722DriverP;
    TempRead = DS1722DriverP; /* the driver provides read */
    
    /* Wire the things we use (everything from the Hpl) */
    components HplDS1722C;
    DS1722DriverP.SEL_PIN -> HplDS1722C.SEL_PIN;
    DS1722DriverP.SpiResource -> HplDS1722C.SpiResource;
    DS1722DriverP.FastSpiByte -> HplDS1722C.FastSpiByte;

    /* the timer for the delay when a read was requested */
    components new TimerMilliC() as Timer;
    DS1722DriverP.Timer0 -> Timer;

    /* internal usage */
    components HplAtm128SpiC;
    DS1722DriverP.HplSpi -> HplAtm128SpiC;
}
