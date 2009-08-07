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

#include "sam3urtthardware.h"

module HplSam3uRttP @safe()
{
    provides {
        interface Init;
        interface HplSam3uRtt;
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
    async command error_t HplSam3uRtt.setPrescalar(uint16_t prescalar)
    {
        // after changing the prescalar, we have to restart the RTT
        RTT->rtmr.bits.rtpres = prescalar;
        return call HplSam3uRtt.restart();
    }

    async command uint32_t HplSam3uRtt.getTime()
    {
        return RTT->rtvr;
    }

    async command error_t HplSam3uRtt.enableAlarmInterrupt()
    {
        RTT->rtmr.bits.almien = 1;;
        return SUCCESS;
    }

    async command error_t HplSam3uRtt.disableAlarmInterrupt()
    {
        RTT->rtmr.bits.almien = 0;
        return SUCCESS;
    }

    async command error_t HplSam3uRtt.enableIncrementalInterrupt()
    {
        RTT->rtmr.bits.rttincien = 1;
        return SUCCESS;
    }

    async command error_t HplSam3uRtt.disableIncrementalInterrupt()
    {
        RTT->rtmr.bits.rttincien = 0;
        return SUCCESS;
    }

    async command error_t HplSam3uRtt.restart()
    {
        RTT->rtmr.bits.rttrst = 1;
        return SUCCESS;
    }

    async command error_t HplSam3uRtt.setAlarm(uint32_t time)
    {
        if(time > 0)
        {
            RTT->rtar = time - 1;
            return SUCCESS;
        } else {
            return FAIL;
        }
    }

    async command uint32_t HplSam3uRtt.getAlarm()
    {
        return RTT->rtar;
    }

    void HplSam3uRttIrqHandler() @C() @spontaneous()
    {
        rtt_rtsr_t status;

        atomic {
            // clear pending interrupt
            call NVICRTTInterrupt.clearPending();

            status = RTT->rtsr;

            if (status.bits.rttinc) {
                // we got an increment interrupt
                signal HplSam3uRtt.incrementFired();
            }

            if (status.bits.alms) {
                // we got an alarm
                signal HplSam3uRtt.alarmFired();
            }
        }
    }

    default async event void HplSam3uRtt.incrementFired() {}
    default async event void HplSam3uRtt.alarmFired() {}

}

