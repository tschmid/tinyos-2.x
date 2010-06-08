/*
 * Copyright CSIRO 2009
 * All rights reserved.
 *
 * Author: Christian.Richter@csiro.au
 */
generic configuration DemoSensorC() {
    /* The onboard temperature, the first 2 bytes are for the degrees (the very
       first bit is 1 on negative) and the lower 2 bytes for after decimal
       degrees */
    provides interface Read<uint16_t>;
}
implementation {
    components DS1722DriverC;
    Read = DS1722DriverC.TempRead;
}
