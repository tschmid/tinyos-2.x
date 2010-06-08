/**
 * (C) Copyright CSIRO Australia, 2009
 * All rights reserved
 *
 * This file implements the device functions to realize Read - based on the
 * used interfaces (which come from the Hardware Platform Layer: Hpl*).
 *
 * @author Christian.Richter@csiro.au
 */
module DS1722DriverP{
    provides interface Read<uint16_t> as TempRead;
    
    uses {
        interface GeneralIO as SEL_PIN;
        interface Resource as SpiResource;
        interface FastSpiByte;
        interface Timer<TMilli> as Timer0;
        interface Atm128Spi as HplSpi;
    }
}

implementation {

    void finishTempConv();
    void startTempConv();

    enum {
        STATE_READY = 0,
        STATE_SEND_CMD = 1,
        STATE_READ_RESULT = 2
    };
    uint8_t state = STATE_READY;
    uint8_t finishTaskCount = 0;

    /* Internal stuff */
    async event void HplSpi.dataReady(uint8_t data){}
    
    /* ---------- Helpers ---------- */

    inline void writeStatusRegister(uint8_t value) {

        call HplSpi.setClockPhase(1);
        call SEL_PIN.set();
        call FastSpiByte.splitWrite( 0x80 );
        call FastSpiByte.splitReadWrite(value);
        call FastSpiByte.splitRead();
        call SEL_PIN.clr();
        call HplSpi.setClockPhase(0);
    }

    inline uint8_t readRegister(uint8_t reg) {

        call HplSpi.setClockPhase(1);
        call SEL_PIN.set();
        call FastSpiByte.splitWrite(reg);
        call FastSpiByte.splitReadWrite(0);
        reg = call FastSpiByte.splitRead();
        call SEL_PIN.clr();
        call HplSpi.setClockPhase(0);
        return reg;
    }

    /* ---------- Interface read ---------- */
    
    /* Initiates the temperature sample */
    command error_t TempRead.read(){
        if(state == STATE_READY){
            state = STATE_SEND_CMD;
            return call SpiResource.request();
        } else {
            return EBUSY;
        }
    }

    /* ---------- SPI ---------- */

    event void SpiResource.granted(){
        if(state == STATE_SEND_CMD){
            startTempConv();
        } else if(state == STATE_READ_RESULT){
            finishTempConv();
        } else {
            call SpiResource.release();
        }
    }

    /* in case the timer gets fired, we have to read the result vi spi */
    event void Timer0.fired(){
        state = STATE_READ_RESULT;
        call SpiResource.request();
    }

    /* ---------- Tasks ---------- */
    
    void startTempConv(){
        /* FIXED precision of 2 afterdecimal */
        const uint8_t res = 2;

        /* reset the finish task post count */
        finishTaskCount = 0;

        /* send the command to write and init a timer to fire once done */
            /* start the conversion by setting 1shot + resolution */
        writeStatusRegister(0xf0 | (res << 1) | 0x01);

        call SpiResource.release();
        call Timer0.startOneShot(300); /* e.g. for 10 bit res it's 0.3 sec */
    } 

    void finishTempConv(){
        uint16_t res = 0;
        uint8_t msb = 0;
        uint8_t lsb = 0;
        uint8_t status = 0x10;

        /* make sure the one shot bit is clear so data is there */
        status = readRegister(0x00);
        lsb = readRegister(0x01);
        msb = readRegister(0x02);
        
        call SpiResource.release();
        
        if((status & 0x10)!=0x10){
            /* finished the conversion, prepare the result */
                /* get the information in one uint16 */
            res = msb;
            res = res << 8;
            res |= lsb;
                /* return the result via signal */
            state = STATE_READY;
            signal TempRead.readDone(SUCCESS, res);
        } else {
            /* post this task again and return */
            if(finishTaskCount++ < 3){
                call Timer0.startOneShot(50);
            } else { 
                signal TempRead.readDone(FAIL, res);
            }
            return;
        }
    }
}
