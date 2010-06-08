/*
 * Copyright (c) 2009, CSIRO
 * All rights reserved.
 *
 * Author: Christian Richter (Christian.Richter@csiro.au)
 */

/**
 * This interface allows to switch the antenna to a specific antenna. It also
 * supports a read operation.
 */
interface AntennaSwitch
{
	/**
     * Perform a switch to antenna <no>, where the first antenna is antenna 0.
     * The number should be smaller than the return value of countAnt().
     * However, an implementation should be fault tolerant and use the highest
     * number in a case where no >= countAnt().
	 */
	async command void switchToAnt(uint8_t no);

	/**
     * Returns a uint8_t of the current antenna that is in use.
	 */
	async command uint8_t currentAnt();
	
    /**
     * Returns a uint8_t how many antennas are available.
     */
    async command uint8_t countAnt();
}
