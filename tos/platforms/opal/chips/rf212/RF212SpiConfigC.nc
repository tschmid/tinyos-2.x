

module RF212SpiConfigC 
{
    provides 
    {
        interface Init;
        interface ResourceConfigure;
    }
    uses {
        interface HplSam3uSpiChipSelConfig;
        interface HplSam3uSpiConfig;
    }
}
implementation {

    command error_t Init.init() {
        // configure clock 
        call HplSam3uSpiChipSelConfig.setBaud(10);
        call HplSam3uSpiChipSelConfig.setClockPolarity(0); // logic zero is inactive 
        call HplSam3uSpiChipSelConfig.setClockPhase(1);    // out on rising, in on falling 
        call HplSam3uSpiChipSelConfig.disableAutoCS();     // disable automatic rising of CS after each transfer 
        //call HplSam3uSpiChipSelConfig.enableAutoCS(); 
 
        // if the CS line is not risen automatically after the last tx. The lastxfer bit has to be used. 
        call HplSam3uSpiChipSelConfig.enableCSActive();    
        //call HplSam3uSpiChipSelConfig.disableCSActive();  
 
        call HplSam3uSpiChipSelConfig.setBitsPerTransfer(SPI_CSR_BITS_8); 
        call HplSam3uSpiChipSelConfig.setTxDelay(0); 
        call HplSam3uSpiChipSelConfig.setClkDelay(0); 
        return SUCCESS;
    }

    async command void ResourceConfigure.configure() {
        // Do stuff here
    }
    
    async command void ResourceConfigure.unconfigure() {
        // Do stuff here...
    }
}
