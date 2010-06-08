/*
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2006 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/**
 * Busy wait component as per TEP102. 
 */
module BusyWaitMicroC @safe()
{
    provides interface BusyWait<TMicro,uint16_t>;
    uses interface HplSam3uClock as Clk;
}
implementation
{
    async command void BusyWait.wait(uint16_t dt) __attribute__((noinline)) {
        // based on the current rate we have to adjust the steps
        if (dt > 1){
            // calculate the cycles we should burn 
            volatile uint32_t cyc = (dt * (call Clk.getMainClockSpeed()))/12000;
            //volatile uint32_t cyc = (dt * (call Clk.getMainClockSpeed()))/12000;
            //volatile uint32_t cyc = 12000;
            
            // one cycle in this while loop takes 12 CPU cycles
            atomic {
            while(cyc > 0){
                asm volatile ("    nop\n");
                cyc--;
            }
            }
        }
    }

    async event void Clk.mainClockChanged(){};
}
