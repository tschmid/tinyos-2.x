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
 * Provides the functionality of the SAM3U TC. It enables and disables the
 * whole unit and initializes the default configuration.
 *
 * @author Thomas Schmid
 */

#include "sam3utchardware.h"

module HplSam3uTCP @safe()
{
    provides {
        interface Init;
    }
    uses {
        interface HplSam3uTCChannel as TC0;
    }
}
implementation
{
    command error_t Init.init()
    {
        // configure channel 0 to be clocked from the SLOW clokc (32kHz)
        call TC0.setMode(TC_CMR_CAPTURE);
        call TC0.setClockSource(TC_CMR_CLK_SLOW);

        call TC0.enableEvents();

        return SUCCESS;
    }

    async event void TC0.overflow() {};
}


