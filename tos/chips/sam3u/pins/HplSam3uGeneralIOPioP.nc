/*
 * Copyright (c) 2009 Stanford University.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Stanford University nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * Abstraction of a PIO controller on the SAM3U. Has 32 pins.
 *
 * @author wanja@cs.fau.de
 */

generic configuration HplSam3uGeneralIOPioP(uint32_t pio_addr)
{
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
		interface GeneralIO as Pin16;
		interface GeneralIO as Pin17;
		interface GeneralIO as Pin18;
		interface GeneralIO as Pin19;
		interface GeneralIO as Pin20;
		interface GeneralIO as Pin21;
		interface GeneralIO as Pin22;
		interface GeneralIO as Pin23;
		interface GeneralIO as Pin24;
		interface GeneralIO as Pin25;
		interface GeneralIO as Pin26;
		interface GeneralIO as Pin27;
		interface GeneralIO as Pin28;
		interface GeneralIO as Pin29;
		interface GeneralIO as Pin30;
		interface GeneralIO as Pin31;
	}
}
implementation
{
	components 
	new HplSam3uGeneralIOPinP(pio_addr, 0) as Bit0,
	new HplSam3uGeneralIOPinP(pio_addr, 1) as Bit1,
	new HplSam3uGeneralIOPinP(pio_addr, 2) as Bit2,
	new HplSam3uGeneralIOPinP(pio_addr, 3) as Bit3,
	new HplSam3uGeneralIOPinP(pio_addr, 4) as Bit4,
	new HplSam3uGeneralIOPinP(pio_addr, 5) as Bit5,
	new HplSam3uGeneralIOPinP(pio_addr, 6) as Bit6,
	new HplSam3uGeneralIOPinP(pio_addr, 7) as Bit7,
	new HplSam3uGeneralIOPinP(pio_addr, 8) as Bit8,
	new HplSam3uGeneralIOPinP(pio_addr, 9) as Bit9,
	new HplSam3uGeneralIOPinP(pio_addr, 10) as Bit10,
	new HplSam3uGeneralIOPinP(pio_addr, 11) as Bit11,
	new HplSam3uGeneralIOPinP(pio_addr, 12) as Bit12,
	new HplSam3uGeneralIOPinP(pio_addr, 13) as Bit13,
	new HplSam3uGeneralIOPinP(pio_addr, 14) as Bit14,
	new HplSam3uGeneralIOPinP(pio_addr, 15) as Bit15,
	new HplSam3uGeneralIOPinP(pio_addr, 16) as Bit16,
	new HplSam3uGeneralIOPinP(pio_addr, 17) as Bit17,
	new HplSam3uGeneralIOPinP(pio_addr, 18) as Bit18,
	new HplSam3uGeneralIOPinP(pio_addr, 19) as Bit19,
	new HplSam3uGeneralIOPinP(pio_addr, 20) as Bit20,
	new HplSam3uGeneralIOPinP(pio_addr, 21) as Bit21,
	new HplSam3uGeneralIOPinP(pio_addr, 22) as Bit22,
	new HplSam3uGeneralIOPinP(pio_addr, 23) as Bit23,
	new HplSam3uGeneralIOPinP(pio_addr, 24) as Bit24,
	new HplSam3uGeneralIOPinP(pio_addr, 25) as Bit25,
	new HplSam3uGeneralIOPinP(pio_addr, 26) as Bit26,
	new HplSam3uGeneralIOPinP(pio_addr, 27) as Bit27,
	new HplSam3uGeneralIOPinP(pio_addr, 28) as Bit28,
	new HplSam3uGeneralIOPinP(pio_addr, 29) as Bit29,
	new HplSam3uGeneralIOPinP(pio_addr, 30) as Bit30,
	new HplSam3uGeneralIOPinP(pio_addr, 31) as Bit31;

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
	Pin16 = Bit16;
	Pin17 = Bit17;
	Pin18 = Bit18;
	Pin19 = Bit19;
	Pin20 = Bit20;
	Pin21 = Bit21;
	Pin22 = Bit22;
	Pin23 = Bit23;
	Pin24 = Bit24;
	Pin25 = Bit25;
	Pin26 = Bit26;
	Pin27 = Bit27;
	Pin28 = Bit28;
	Pin29 = Bit29;
	Pin30 = Bit30;
	Pin31 = Bit31;
}
