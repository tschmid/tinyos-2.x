/**
 * Emulate fast spi with SpiByte
 */
module FastSpiSam3uC
{
    provides
    {
        interface FastSpiByte;
    }
    uses
    {
        interface SpiByte;
    }
}

implementation
{
    volatile uint8_t lastRead = 0;

    /**
     * Starts a split-phase SPI data transfer with the given data.
     * A splitRead/splitReadWrite command must follow this command even 
     * if the result is unimportant.
     */
    async command void FastSpiByte.splitWrite(uint8_t data){
        atomic lastRead = call SpiByte.write(data);
    }

    /**
     * Finishes the split-phase SPI data transfer by waiting till 
     * the write command comletes and returning the received data.
     */
    async command uint8_t FastSpiByte.splitRead(){
        atomic return lastRead;
    }

    /**
     * This command first reads the SPI register and then writes
     * there the new data, then returns. 
     */
    async command uint8_t FastSpiByte.splitReadWrite(uint8_t data){
        uint8_t tmp;
        atomic {
            tmp = lastRead;
            lastRead = call SpiByte.write(data);
        }
        return tmp;
    }

    /**
     * This is the standard SpiByte.write command but a little
     * faster as we should not need to adjust the power state there.
     * (To be consistent, this command could have be named splitWriteRead).
     */
    async command uint8_t FastSpiByte.write(uint8_t data){
        return call SpiByte.write(data);
    }

}
