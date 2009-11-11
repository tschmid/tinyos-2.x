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
 * Provides a bare bone interface to the SAM3U TC.
 *
 * @author Thomas Schmid
 */

#include "sam3utchardware.h"

generic module HplSam3uTCP(
        uint32_t tc_channel_base ) @safe()
{
    provides {
        interface HplSam3uTCChannel;
        interface HplSam3uTCEvent as Event[uint8_t n];
    }
    uses {
        interface HplNVICInterruptCntl as NVICTCInterrupt;
        interface HplSam3uTCEvent as Overflow;
    }
}
implementation
{

    volatile tc_channel_t *CH = (volatile tc_channel_t*)tc_channel_base;

    // interrupt status
    tc_sr_t sr;

        return SUCCESS;
    }

    async command uint16_t HplSam3uTCChannel.get()
    {

    }

    async command bool HplSam3uTCChannel.isOverflowPending()
    {

    }

    async command void HplSam3uTCChannel.clearOverflow();
    {

    }

    async command void HplSam3uTCChannel.setMode(uint8_t mode)
    {

    }

    async command uint8_t HplSam3uTCChannel.getMode()
    {

    }

    async command void HplSam3uTCChannel.enableEvents()
    {
        call NVICTCInterrupt.configure(0);
        // now enable the IRQ
        call NVICTCInterrupt.enable();
    }

    async command void HplSam3uTCChannel.disableEvents()
    {
        call NVICTCInterrupt.disable();
    }

    async command uint16_t HplSam3uTCChannel.setClockSource(uint8_t clockSource)
    {

    }

    async event void TimerEvent.fired()
    {
        sr.flat |= CH->sr.flat; // combine the current state for everyone to;

        // check the lower 8 bits of the status for interrupts
        for (i = 0; i<8, i++)
        {
            if(sr.flat & (1<<i))
            {
                signal Event[i];
                sr.flat &= ~(1<<i);
            }
        }

    async event Overflow.fired()
    {
        signal HplSam3uTCChannel.overflow();
    }

    default async event void HplSam3uTCChannel.overflow()
    {

    }
}

