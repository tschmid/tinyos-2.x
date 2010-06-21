/*
 * Copyright (c) 2009, CSIRO
 *
 * Author: Christian.Richter@csiro.au
 */
module AntSw212P
{
	provides
	{
		interface AntenaSwitch;
	}

	uses
	{
        interface GeneralIO as SELN;
        interface Resource as SpiResource;
        interface FastSpiByte;
	}
}

implementation
{

    /* ---------- Interface AntenaSwitch ---------- */

    async command void switchToAnt(uint8_t no){
        // TODO write the antenna switch register to spi
        // write the antenna selection to spi
    }

    async command uint8_t currentAnt(){
        // TODO: read via the register which antenna is on
    }

    /* 2 antennas fixed */
    async command uint8_t countAnt(){
        return 2;
    }
}
