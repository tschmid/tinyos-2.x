/**
 * "Copyright (c) 2009 The Regents of the University of California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement
 * is hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
 * OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 * Provides an bare bone interface to the SAM3U RTT.
 *
 * @author Thomas Schmid
 */

#include "rtt.h"

module HplSam3uRttP @safe()
{
    provides {
        interface Init;
        interface Rtt;
    }
    uses {
        interface HplNVICCntl;
        interface HplNVICInterruptCntl as NVICRTTInterrupt;
    }
}
implementation
{
    command error_t Init.init()
    {
        call NVICRTTInterrupt.configure(0);
        // now enable the IRQ
        call NVICRTTInterrupt.enable();
        return SUCCESS;
    }

    /**
     * Sets the prescalar value of the RTT and restart it. This function
     * disables all interrupt sources!
     */
    async command error_t Rtt.setPrescalar(uint16_t prescalar)
    {
        // after changing the prescalar, we have to restart the RTT
        RTT->rtmr = (prescalar | RTTC_RTTRST);
        return SUCCESS;
    }

    async command uint32_t Rtt.getTime()
    {
        return RTT->rtvr;
    }

    async command error_t Rtt.enableAlarmInterrupt()
    {
        RTT->rtmr |= RTTC_ALMIEN;
        return SUCCESS;
    }

    async command error_t Rtt.disableAlarmInterrupt()
    {
        RTT->rtmr &= ~RTTC_ALMIEN;
        return SUCCESS;
    }

    async command error_t Rtt.enableIncrementalInterrupt()
    {
        RTT->rtmr |= RTTC_RTTINCIEN;
        return SUCCESS;
    }

    async command error_t Rtt.disableIncrementalInterrupt()
    {
        RTT->rtmr &= ~RTTC_RTTINCIEN;
        return SUCCESS;
    }

    async command error_t Rtt.restart()
    {
        RTT->rtmr |= RTTC_RTTRST;
        return SUCCESS;
    }

    async command error_t Rtt.setAlarm(uint32_t time)
    {
        if(time > 0)
        {
            RTT->rtar = time - 1;
            return SUCCESS;
        } else {
            return FAIL;
        }
    }

    async command uint32_t Rtt.getAlarm()
    {
        return RTT->rtar;
    }

    /**
     * Returns the status of the RTT. There are only two important bits:
     * bit 0: indicates if the alarm has occured since last read of the status
     * bit 1: indicates if the RTT has been incremented since last read of the
     *        status
     */
    async command bool Rtt.getStatus()
    {
        return RTT->rtsr;
    }

    void RTTIrqHandler() @C() @spontaneous()
    {
        uint32_t status;
        status = call Rtt.getStatus();

        if ((status & RTTC_RTTINC) == RTTC_RTTINC) {
            // we got an increment interrupt
            signal Rtt.incrementFired();
        }

        if ((status & RTTC_ALMS) == RTTC_ALMS) {
            // we got an alarm
            signal Rtt.alarmFired();
        }
    }

    default async event void Rtt.incrementFired() {}
    default async event void Rtt.alarmFired() {}

}

