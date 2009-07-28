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
 * Provide GeneralIO interfaces for all of the STM32's pins.
 *
 * @author Thomas Schmid
 */

#include <stm32hardware.h>

configuration HplSTM32GeneralIOC
{
  // provides all the ports as raw ports
  provides {
    interface GeneralIO as PortA0;
    interface GeneralIO as PortA1;
    interface GeneralIO as PortA2;
    interface GeneralIO as PortA3;
    interface GeneralIO as PortA4;
    interface GeneralIO as PortA5;
    interface GeneralIO as PortA6;
    interface GeneralIO as PortA7;
    interface GeneralIO as PortA8;
    interface GeneralIO as PortA9;
    interface GeneralIO as PortA10;
    interface GeneralIO as PortA11;
    interface GeneralIO as PortA12;
    interface GeneralIO as PortA13;
    interface GeneralIO as PortA14;
    interface GeneralIO as PortA15;

    interface GeneralIO as PortB0;
    interface GeneralIO as PortB1;
    interface GeneralIO as PortB2;
    interface GeneralIO as PortB3;
    interface GeneralIO as PortB4;
    interface GeneralIO as PortB5;
    interface GeneralIO as PortB6;
    interface GeneralIO as PortB7;
    interface GeneralIO as PortB8;
    interface GeneralIO as PortB9;
    interface GeneralIO as PortB10;
    interface GeneralIO as PortB11;
    interface GeneralIO as PortB12;
    interface GeneralIO as PortB13;
    interface GeneralIO as PortB14;
    interface GeneralIO as PortB15;

    interface GeneralIO as PortC0;
    interface GeneralIO as PortC1;
    interface GeneralIO as PortC2;
    interface GeneralIO as PortC3;
    interface GeneralIO as PortC4;
    interface GeneralIO as PortC5;
    interface GeneralIO as PortC6;
    interface GeneralIO as PortC7;
    interface GeneralIO as PortC8;
    interface GeneralIO as PortC9;
    interface GeneralIO as PortC10;
    interface GeneralIO as PortC11;
    interface GeneralIO as PortC12;
    interface GeneralIO as PortC13;
    interface GeneralIO as PortC14;
    interface GeneralIO as PortC15;

    interface GeneralIO as PortD0;
    interface GeneralIO as PortD1;
    interface GeneralIO as PortD2;
    interface GeneralIO as PortD3;
    interface GeneralIO as PortD4;
    interface GeneralIO as PortD5;
    interface GeneralIO as PortD6;
    interface GeneralIO as PortD7;
    interface GeneralIO as PortD8;
    interface GeneralIO as PortD9;
    interface GeneralIO as PortD10;
    interface GeneralIO as PortD11;
    interface GeneralIO as PortD12;
    interface GeneralIO as PortD13;
    interface GeneralIO as PortD14;
    interface GeneralIO as PortD15;

    interface GeneralIO as PortE0;
    interface GeneralIO as PortE1;
    interface GeneralIO as PortE2;
    interface GeneralIO as PortE3;
    interface GeneralIO as PortE4;
    interface GeneralIO as PortE5;
    interface GeneralIO as PortE6;
    interface GeneralIO as PortE7;
    interface GeneralIO as PortE8;
    interface GeneralIO as PortE9;
    interface GeneralIO as PortE10;
    interface GeneralIO as PortE11;
    interface GeneralIO as PortE12;
    interface GeneralIO as PortE13;
    interface GeneralIO as PortE14;
    interface GeneralIO as PortE15;
  }
}

implementation
{
    components 
        new HplSTM32GeneralIOPortP(GPIOA_BASE) as PortA,
        new HplSTM32GeneralIOPortP(GPIOB_BASE) as PortB,
        new HplSTM32GeneralIOPortP(GPIOC_BASE) as PortC,
        new HplSTM32GeneralIOPortP(GPIOD_BASE) as PortD,
        new HplSTM32GeneralIOPortP(GPIOE_BASE) as PortE;

  PortA0 = PortA.Pin0;
  PortA1 = PortA.Pin1;
  PortA2 = PortA.Pin2;
  PortA3 = PortA.Pin3;
  PortA4 = PortA.Pin4;
  PortA5 = PortA.Pin5;
  PortA6 = PortA.Pin6;
  PortA7 = PortA.Pin7;
  PortA8 = PortA.Pin8;
  PortA9 = PortA.Pin9;
  PortA10 = PortA.Pin10;
  PortA11 = PortA.Pin11;
  PortA12 = PortA.Pin12;
  PortA13 = PortA.Pin13;
  PortA14 = PortA.Pin14;
  PortA15 = PortA.Pin15;

  PortB0 = PortB.Pin0;
  PortB1 = PortB.Pin1;
  PortB2 = PortB.Pin2;
  PortB3 = PortB.Pin3;
  PortB4 = PortB.Pin4;
  PortB5 = PortB.Pin5;
  PortB6 = PortB.Pin6;
  PortB7 = PortB.Pin7;
  PortB8 = PortB.Pin8;
  PortB9 = PortB.Pin9;
  PortB10 = PortB.Pin10;
  PortB11 = PortB.Pin11;
  PortB12 = PortB.Pin12;
  PortB13 = PortB.Pin13;
  PortB14 = PortB.Pin14;
  PortB15 = PortB.Pin15;


  PortC0 = PortC.Pin0;
  PortC1 = PortC.Pin1;
  PortC2 = PortC.Pin2;
  PortC3 = PortC.Pin3;
  PortC4 = PortC.Pin4;
  PortC5 = PortC.Pin5;
  PortC6 = PortC.Pin6;
  PortC7 = PortC.Pin7;
  PortC8 = PortC.Pin8;
  PortC9 = PortC.Pin9;
  PortC10 = PortC.Pin10;
  PortC11 = PortC.Pin11;
  PortC12 = PortC.Pin12;
  PortC13 = PortC.Pin13;
  PortC14 = PortC.Pin14;
  PortC15 = PortC.Pin15;


  PortD0 = PortD.Pin0;
  PortD1 = PortD.Pin1;
  PortD2 = PortD.Pin2;
  PortD3 = PortD.Pin3;
  PortD4 = PortD.Pin4;
  PortD5 = PortD.Pin5;
  PortD6 = PortD.Pin6;
  PortD7 = PortD.Pin7;
  PortD8 = PortD.Pin8;
  PortD9 = PortD.Pin9;
  PortD10 = PortD.Pin10;
  PortD11 = PortD.Pin11;
  PortD12 = PortD.Pin12;
  PortD13 = PortD.Pin13;
  PortD14 = PortD.Pin14;
  PortD15 = PortD.Pin15;


  PortE0 = PortE.Pin0;
  PortE1 = PortE.Pin1;
  PortE2 = PortE.Pin2;
  PortE3 = PortE.Pin3;
  PortE4 = PortE.Pin4;
  PortE5 = PortE.Pin5;
  PortE6 = PortE.Pin6;
  PortE7 = PortE.Pin7;
  PortE8 = PortE.Pin8;
  PortE9 = PortE.Pin9;
  PortE10 = PortE.Pin10;
  PortE11 = PortE.Pin11;
  PortE12 = PortE.Pin12;
  PortE13 = PortE.Pin13;
  PortE14 = PortE.Pin14;
  PortE15 = PortE.Pin15;
}
