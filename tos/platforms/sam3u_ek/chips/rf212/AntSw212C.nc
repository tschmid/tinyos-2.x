/*
 * Copyright (c) 2009, CSIRO
 * All rights reserved.
 *
 * Author: Christian Richter (Christian.Richter@csiro.au)
 */
configuration AntSw212C
{
	provides
	{
		interface AntennaSwitch as RF212AntennaSwitch;
    }
}

implementation
{
    components AntSw212P, HplRF212C;
    RF212AntennaSwitch = AntSw212P;

    AntSw212P.SELN -> HplRF212C.SELN;
    AntSw212P.SpiResource -> HplRF212C.SpiResource;
    AntSw212P.FastSpiByte -> HplRF212C;
}
