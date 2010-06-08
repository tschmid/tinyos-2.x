/**
 * (C) Copyright CSIRO Australia, 2009
 * All rights reserved
 *
 * This file provides the private layer for the hardware abstraction. Nothing
 * fancy here, just pin stuff.
 *
 * @author Christian.Richter@csiro.au
 */
module HplDS1722P {
    provides interface Init as DS1722Init;

    uses interface GeneralIO as SEL_PIN;
}

implementation {
    command error_t DS1722Init.init(){
        call SEL_PIN.makeOutput();
        call SEL_PIN.clr();
        return SUCCESS;
    } 
}

