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
 * Generic component to expose a full 32-bit port of GPIO pins.
 *
 * @author Thomas Schmid
 */

#include <stm32hardware.h>

generic configuration HplSTM32GeneralIOPortP (uint32_t port_addr)
{
  // provides all the ports as raw ports
  provides {
    interface GeneralIO as Pin0;
    interface GeneralIO as Pin1;
    interface GeneralIO as Pin2;
    interface GeneralIO as Pin3;
    interface GeneralIO as Pin4;
    interface GeneralIO as Pin5;
    interface GeneralIO as Pin6;
    interface GeneralIO as Pin7;
    interface GeneralIO as Pin8;
    interface GeneralIO as Pin9;
    interface GeneralIO as Pin10;
    interface GeneralIO as Pin11;
    interface GeneralIO as Pin12;
    interface GeneralIO as Pin13;
    interface GeneralIO as Pin14;
    interface GeneralIO as Pin15;
  }
}
implementation
{
  components 
  new HplSTM32GeneralIOPinP (port_addr, 0) as Bit0,
  new HplSTM32GeneralIOPinP (port_addr, 1) as Bit1,
  new HplSTM32GeneralIOPinP (port_addr, 2) as Bit2,
  new HplSTM32GeneralIOPinP (port_addr, 3) as Bit3,
  new HplSTM32GeneralIOPinP (port_addr, 4) as Bit4,
  new HplSTM32GeneralIOPinP (port_addr, 5) as Bit5,
  new HplSTM32GeneralIOPinP (port_addr, 6) as Bit6,
  new HplSTM32GeneralIOPinP (port_addr, 7) as Bit7,
  new HplSTM32GeneralIOPinP (port_addr, 8) as Bit8,
  new HplSTM32GeneralIOPinP (port_addr, 9) as Bit9,
  new HplSTM32GeneralIOPinP (port_addr, 10) as Bit10,
  new HplSTM32GeneralIOPinP (port_addr, 11) as Bit11,
  new HplSTM32GeneralIOPinP (port_addr, 12) as Bit12,
  new HplSTM32GeneralIOPinP (port_addr, 13) as Bit13,
  new HplSTM32GeneralIOPinP (port_addr, 14) as Bit14,
  new HplSTM32GeneralIOPinP (port_addr, 15) as Bit15;

  Pin0 = Bit0;
  Pin1 = Bit1;
  Pin2 = Bit2;
  Pin3 = Bit3;
  Pin4 = Bit4;
  Pin5 = Bit5;
  Pin6 = Bit6;
  Pin7 = Bit7;
  Pin8 = Bit8;
  Pin9 = Bit9;
  Pin10 = Bit10;
  Pin11 = Bit11;
  Pin12 = Bit12;
  Pin13 = Bit13;
  Pin14 = Bit14;
  Pin15 = Bit15;
}
