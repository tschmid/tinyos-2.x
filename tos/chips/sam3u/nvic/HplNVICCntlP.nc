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
 * NVIC Controller
 *
 * @author Thomas Schmid
 */

#include "sam3unvichardware.h"

module HplNVICCntlP
{
    provides interface HplNVICCntl;
}

implementation{
    command void HplNVICCntl.setPriorityGrouping(uint32_t priority_grouping)
    {
        uint32_t reg_value=0;

        reg_value  = SCB->AIRCR;                                                                            /* read old register configuration    */
        reg_value &= ~((0xFFFFU << 16) | (0x0F << 8));                                                      /* clear bits to change               */
        reg_value  = ((reg_value | NVIC_AIRCR_VECTKEY | (priority_grouping << 8)));                         /* Insert write key and priorty group */
        SCB->AIRCR = reg_value;
    }
}
