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
 * General-purpose I/O abstraction for the SAM3U.
 * Includes PIO controllers A, B, C with 32 pins each.
 *
 * @author Wanja Hofer <wanja@cs.fau.de>
 */

configuration HplSam3uGeneralIOC
{
	provides {
		interface GeneralIO as PioA0;
		interface GeneralIO as PioA1;
		interface GeneralIO as PioA2;
		interface GeneralIO as PioA3;
		interface GeneralIO as PioA4;
		interface GeneralIO as PioA5;
		interface GeneralIO as PioA6;
		interface GeneralIO as PioA7;
		interface GeneralIO as PioA8;
		interface GeneralIO as PioA9;
		interface GeneralIO as PioA10;
		interface GeneralIO as PioA11;
		interface GeneralIO as PioA12;
		interface GeneralIO as PioA13;
		interface GeneralIO as PioA14;
		interface GeneralIO as PioA15;
		interface GeneralIO as PioA16;
		interface GeneralIO as PioA17;
		interface GeneralIO as PioA18;
		interface GeneralIO as PioA19;
		interface GeneralIO as PioA20;
		interface GeneralIO as PioA21;
		interface GeneralIO as PioA22;
		interface GeneralIO as PioA23;
		interface GeneralIO as PioA24;
		interface GeneralIO as PioA25;
		interface GeneralIO as PioA26;
		interface GeneralIO as PioA27;
		interface GeneralIO as PioA28;
		interface GeneralIO as PioA29;
		interface GeneralIO as PioA30;
		interface GeneralIO as PioA31;

		interface GeneralIO as PioB0;
		interface GeneralIO as PioB1;
		interface GeneralIO as PioB2;
		interface GeneralIO as PioB3;
		interface GeneralIO as PioB4;
		interface GeneralIO as PioB5;
		interface GeneralIO as PioB6;
		interface GeneralIO as PioB7;
		interface GeneralIO as PioB8;
		interface GeneralIO as PioB9;
		interface GeneralIO as PioB10;
		interface GeneralIO as PioB11;
		interface GeneralIO as PioB12;
		interface GeneralIO as PioB13;
		interface GeneralIO as PioB14;
		interface GeneralIO as PioB15;
		interface GeneralIO as PioB16;
		interface GeneralIO as PioB17;
		interface GeneralIO as PioB18;
		interface GeneralIO as PioB19;
		interface GeneralIO as PioB20;
		interface GeneralIO as PioB21;
		interface GeneralIO as PioB22;
		interface GeneralIO as PioB23;
		interface GeneralIO as PioB24;
		interface GeneralIO as PioB25;
		interface GeneralIO as PioB26;
		interface GeneralIO as PioB27;
		interface GeneralIO as PioB28;
		interface GeneralIO as PioB29;
		interface GeneralIO as PioB30;
		interface GeneralIO as PioB31;

		interface GeneralIO as PioC0;
		interface GeneralIO as PioC1;
		interface GeneralIO as PioC2;
		interface GeneralIO as PioC3;
		interface GeneralIO as PioC4;
		interface GeneralIO as PioC5;
		interface GeneralIO as PioC6;
		interface GeneralIO as PioC7;
		interface GeneralIO as PioC8;
		interface GeneralIO as PioC9;
		interface GeneralIO as PioC10;
		interface GeneralIO as PioC11;
		interface GeneralIO as PioC12;
		interface GeneralIO as PioC13;
		interface GeneralIO as PioC14;
		interface GeneralIO as PioC15;
		interface GeneralIO as PioC16;
		interface GeneralIO as PioC17;
		interface GeneralIO as PioC18;
		interface GeneralIO as PioC19;
		interface GeneralIO as PioC20;
		interface GeneralIO as PioC21;
		interface GeneralIO as PioC22;
		interface GeneralIO as PioC23;
		interface GeneralIO as PioC24;
		interface GeneralIO as PioC25;
		interface GeneralIO as PioC26;
		interface GeneralIO as PioC27;
		interface GeneralIO as PioC28;
		interface GeneralIO as PioC29;
		interface GeneralIO as PioC30;
		interface GeneralIO as PioC31;

		interface HplSam3uGeneralIOPin as HplPioA0;
		interface HplSam3uGeneralIOPin as HplPioA1;
		interface HplSam3uGeneralIOPin as HplPioA2;
		interface HplSam3uGeneralIOPin as HplPioA3;
		interface HplSam3uGeneralIOPin as HplPioA4;
		interface HplSam3uGeneralIOPin as HplPioA5;
		interface HplSam3uGeneralIOPin as HplPioA6;
		interface HplSam3uGeneralIOPin as HplPioA7;
		interface HplSam3uGeneralIOPin as HplPioA8;
		interface HplSam3uGeneralIOPin as HplPioA9;
		interface HplSam3uGeneralIOPin as HplPioA10;
		interface HplSam3uGeneralIOPin as HplPioA11;
		interface HplSam3uGeneralIOPin as HplPioA12;
		interface HplSam3uGeneralIOPin as HplPioA13;
		interface HplSam3uGeneralIOPin as HplPioA14;
		interface HplSam3uGeneralIOPin as HplPioA15;
		interface HplSam3uGeneralIOPin as HplPioA16;
		interface HplSam3uGeneralIOPin as HplPioA17;
		interface HplSam3uGeneralIOPin as HplPioA18;
		interface HplSam3uGeneralIOPin as HplPioA19;
		interface HplSam3uGeneralIOPin as HplPioA20;
		interface HplSam3uGeneralIOPin as HplPioA21;
		interface HplSam3uGeneralIOPin as HplPioA22;
		interface HplSam3uGeneralIOPin as HplPioA23;
		interface HplSam3uGeneralIOPin as HplPioA24;
		interface HplSam3uGeneralIOPin as HplPioA25;
		interface HplSam3uGeneralIOPin as HplPioA26;
		interface HplSam3uGeneralIOPin as HplPioA27;
		interface HplSam3uGeneralIOPin as HplPioA28;
		interface HplSam3uGeneralIOPin as HplPioA29;
		interface HplSam3uGeneralIOPin as HplPioA30;
		interface HplSam3uGeneralIOPin as HplPioA31;

		interface HplSam3uGeneralIOPin as HplPioB0;
		interface HplSam3uGeneralIOPin as HplPioB1;
		interface HplSam3uGeneralIOPin as HplPioB2;
		interface HplSam3uGeneralIOPin as HplPioB3;
		interface HplSam3uGeneralIOPin as HplPioB4;
		interface HplSam3uGeneralIOPin as HplPioB5;
		interface HplSam3uGeneralIOPin as HplPioB6;
		interface HplSam3uGeneralIOPin as HplPioB7;
		interface HplSam3uGeneralIOPin as HplPioB8;
		interface HplSam3uGeneralIOPin as HplPioB9;
		interface HplSam3uGeneralIOPin as HplPioB10;
		interface HplSam3uGeneralIOPin as HplPioB11;
		interface HplSam3uGeneralIOPin as HplPioB12;
		interface HplSam3uGeneralIOPin as HplPioB13;
		interface HplSam3uGeneralIOPin as HplPioB14;
		interface HplSam3uGeneralIOPin as HplPioB15;
		interface HplSam3uGeneralIOPin as HplPioB16;
		interface HplSam3uGeneralIOPin as HplPioB17;
		interface HplSam3uGeneralIOPin as HplPioB18;
		interface HplSam3uGeneralIOPin as HplPioB19;
		interface HplSam3uGeneralIOPin as HplPioB20;
		interface HplSam3uGeneralIOPin as HplPioB21;
		interface HplSam3uGeneralIOPin as HplPioB22;
		interface HplSam3uGeneralIOPin as HplPioB23;
		interface HplSam3uGeneralIOPin as HplPioB24;
		interface HplSam3uGeneralIOPin as HplPioB25;
		interface HplSam3uGeneralIOPin as HplPioB26;
		interface HplSam3uGeneralIOPin as HplPioB27;
		interface HplSam3uGeneralIOPin as HplPioB28;
		interface HplSam3uGeneralIOPin as HplPioB29;
		interface HplSam3uGeneralIOPin as HplPioB30;
		interface HplSam3uGeneralIOPin as HplPioB31;

		interface HplSam3uGeneralIOPin as HplPioC0;
		interface HplSam3uGeneralIOPin as HplPioC1;
		interface HplSam3uGeneralIOPin as HplPioC2;
		interface HplSam3uGeneralIOPin as HplPioC3;
		interface HplSam3uGeneralIOPin as HplPioC4;
		interface HplSam3uGeneralIOPin as HplPioC5;
		interface HplSam3uGeneralIOPin as HplPioC6;
		interface HplSam3uGeneralIOPin as HplPioC7;
		interface HplSam3uGeneralIOPin as HplPioC8;
		interface HplSam3uGeneralIOPin as HplPioC9;
		interface HplSam3uGeneralIOPin as HplPioC10;
		interface HplSam3uGeneralIOPin as HplPioC11;
		interface HplSam3uGeneralIOPin as HplPioC12;
		interface HplSam3uGeneralIOPin as HplPioC13;
		interface HplSam3uGeneralIOPin as HplPioC14;
		interface HplSam3uGeneralIOPin as HplPioC15;
		interface HplSam3uGeneralIOPin as HplPioC16;
		interface HplSam3uGeneralIOPin as HplPioC17;
		interface HplSam3uGeneralIOPin as HplPioC18;
		interface HplSam3uGeneralIOPin as HplPioC19;
		interface HplSam3uGeneralIOPin as HplPioC20;
		interface HplSam3uGeneralIOPin as HplPioC21;
		interface HplSam3uGeneralIOPin as HplPioC22;
		interface HplSam3uGeneralIOPin as HplPioC23;
		interface HplSam3uGeneralIOPin as HplPioC24;
		interface HplSam3uGeneralIOPin as HplPioC25;
		interface HplSam3uGeneralIOPin as HplPioC26;
		interface HplSam3uGeneralIOPin as HplPioC27;
		interface HplSam3uGeneralIOPin as HplPioC28;
		interface HplSam3uGeneralIOPin as HplPioC29;
		interface HplSam3uGeneralIOPin as HplPioC30;
		interface HplSam3uGeneralIOPin as HplPioC31;
	}
}

implementation
{
	components 
	new HplSam3uGeneralIOPioP(0x400e0c00) as PioA,
	new HplSam3uGeneralIOPioP(0x400e0e00) as PioB,
	new HplSam3uGeneralIOPioP(0x400e1000) as PioC;

	PioA0 = PioA.Pin0;
	PioA1 = PioA.Pin1;
	PioA2 = PioA.Pin2;
	PioA3 = PioA.Pin3;
	PioA4 = PioA.Pin4;
	PioA5 = PioA.Pin5;
	PioA6 = PioA.Pin6;
	PioA7 = PioA.Pin7;
	PioA8 = PioA.Pin8;
	PioA9 = PioA.Pin9;
	PioA10 = PioA.Pin10;
	PioA11 = PioA.Pin11;
	PioA12 = PioA.Pin12;
	PioA13 = PioA.Pin13;
	PioA14 = PioA.Pin14;
	PioA15 = PioA.Pin15;
	PioA16 = PioA.Pin16;
	PioA17 = PioA.Pin17;
	PioA18 = PioA.Pin18;
	PioA19 = PioA.Pin19;
	PioA20 = PioA.Pin20;
	PioA21 = PioA.Pin21;
	PioA22 = PioA.Pin22;
	PioA23 = PioA.Pin23;
	PioA24 = PioA.Pin24;
	PioA25 = PioA.Pin25;
	PioA26 = PioA.Pin26;
	PioA27 = PioA.Pin27;
	PioA28 = PioA.Pin28;
	PioA29 = PioA.Pin29;
	PioA30 = PioA.Pin30;
	PioA31 = PioA.Pin31;

	PioB0 = PioB.Pin0;
	PioB1 = PioB.Pin1;
	PioB2 = PioB.Pin2;
	PioB3 = PioB.Pin3;
	PioB4 = PioB.Pin4;
	PioB5 = PioB.Pin5;
	PioB6 = PioB.Pin6;
	PioB7 = PioB.Pin7;
	PioB8 = PioB.Pin8;
	PioB9 = PioB.Pin9;
	PioB10 = PioB.Pin10;
	PioB11 = PioB.Pin11;
	PioB12 = PioB.Pin12;
	PioB13 = PioB.Pin13;
	PioB14 = PioB.Pin14;
	PioB15 = PioB.Pin15;
	PioB16 = PioB.Pin16;
	PioB17 = PioB.Pin17;
	PioB18 = PioB.Pin18;
	PioB19 = PioB.Pin19;
	PioB20 = PioB.Pin20;
	PioB21 = PioB.Pin21;
	PioB22 = PioB.Pin22;
	PioB23 = PioB.Pin23;
	PioB24 = PioB.Pin24;
	PioB25 = PioB.Pin25;
	PioB26 = PioB.Pin26;
	PioB27 = PioB.Pin27;
	PioB28 = PioB.Pin28;
	PioB29 = PioB.Pin29;
	PioB30 = PioB.Pin30;
	PioB31 = PioB.Pin31;

	PioC0 = PioC.Pin0;
	PioC1 = PioC.Pin1;
	PioC2 = PioC.Pin2;
	PioC3 = PioC.Pin3;
	PioC4 = PioC.Pin4;
	PioC5 = PioC.Pin5;
	PioC6 = PioC.Pin6;
	PioC7 = PioC.Pin7;
	PioC8 = PioC.Pin8;
	PioC9 = PioC.Pin9;
	PioC10 = PioC.Pin10;
	PioC11 = PioC.Pin11;
	PioC12 = PioC.Pin12;
	PioC13 = PioC.Pin13;
	PioC14 = PioC.Pin14;
	PioC15 = PioC.Pin15;
	PioC16 = PioC.Pin16;
	PioC17 = PioC.Pin17;
	PioC18 = PioC.Pin18;
	PioC19 = PioC.Pin19;
	PioC20 = PioC.Pin20;
	PioC21 = PioC.Pin21;
	PioC22 = PioC.Pin22;
	PioC23 = PioC.Pin23;
	PioC24 = PioC.Pin24;
	PioC25 = PioC.Pin25;
	PioC26 = PioC.Pin26;
	PioC27 = PioC.Pin27;
	PioC28 = PioC.Pin28;
	PioC29 = PioC.Pin29;
	PioC30 = PioC.Pin30;
	PioC31 = PioC.Pin31;

	HplPioA0 = PioA.HplPin0;
	HplPioA1 = PioA.HplPin1;
	HplPioA2 = PioA.HplPin2;
	HplPioA3 = PioA.HplPin3;
	HplPioA4 = PioA.HplPin4;
	HplPioA5 = PioA.HplPin5;
	HplPioA6 = PioA.HplPin6;
	HplPioA7 = PioA.HplPin7;
	HplPioA8 = PioA.HplPin8;
	HplPioA9 = PioA.HplPin9;
	HplPioA10 = PioA.HplPin10;
	HplPioA11 = PioA.HplPin11;
	HplPioA12 = PioA.HplPin12;
	HplPioA13 = PioA.HplPin13;
	HplPioA14 = PioA.HplPin14;
	HplPioA15 = PioA.HplPin15;
	HplPioA16 = PioA.HplPin16;
	HplPioA17 = PioA.HplPin17;
	HplPioA18 = PioA.HplPin18;
	HplPioA19 = PioA.HplPin19;
	HplPioA20 = PioA.HplPin20;
	HplPioA21 = PioA.HplPin21;
	HplPioA22 = PioA.HplPin22;
	HplPioA23 = PioA.HplPin23;
	HplPioA24 = PioA.HplPin24;
	HplPioA25 = PioA.HplPin25;
	HplPioA26 = PioA.HplPin26;
	HplPioA27 = PioA.HplPin27;
	HplPioA28 = PioA.HplPin28;
	HplPioA29 = PioA.HplPin29;
	HplPioA30 = PioA.HplPin30;
	HplPioA31 = PioA.HplPin31;

	HplPioB0 = PioB.HplPin0;
	HplPioB1 = PioB.HplPin1;
	HplPioB2 = PioB.HplPin2;
	HplPioB3 = PioB.HplPin3;
	HplPioB4 = PioB.HplPin4;
	HplPioB5 = PioB.HplPin5;
	HplPioB6 = PioB.HplPin6;
	HplPioB7 = PioB.HplPin7;
	HplPioB8 = PioB.HplPin8;
	HplPioB9 = PioB.HplPin9;
	HplPioB10 = PioB.HplPin10;
	HplPioB11 = PioB.HplPin11;
	HplPioB12 = PioB.HplPin12;
	HplPioB13 = PioB.HplPin13;
	HplPioB14 = PioB.HplPin14;
	HplPioB15 = PioB.HplPin15;
	HplPioB16 = PioB.HplPin16;
	HplPioB17 = PioB.HplPin17;
	HplPioB18 = PioB.HplPin18;
	HplPioB19 = PioB.HplPin19;
	HplPioB20 = PioB.HplPin20;
	HplPioB21 = PioB.HplPin21;
	HplPioB22 = PioB.HplPin22;
	HplPioB23 = PioB.HplPin23;
	HplPioB24 = PioB.HplPin24;
	HplPioB25 = PioB.HplPin25;
	HplPioB26 = PioB.HplPin26;
	HplPioB27 = PioB.HplPin27;
	HplPioB28 = PioB.HplPin28;
	HplPioB29 = PioB.HplPin29;
	HplPioB30 = PioB.HplPin30;
	HplPioB31 = PioB.HplPin31;

	HplPioC0 = PioC.HplPin0;
	HplPioC1 = PioC.HplPin1;
	HplPioC2 = PioC.HplPin2;
	HplPioC3 = PioC.HplPin3;
	HplPioC4 = PioC.HplPin4;
	HplPioC5 = PioC.HplPin5;
	HplPioC6 = PioC.HplPin6;
	HplPioC7 = PioC.HplPin7;
	HplPioC8 = PioC.HplPin8;
	HplPioC9 = PioC.HplPin9;
	HplPioC10 = PioC.HplPin10;
	HplPioC11 = PioC.HplPin11;
	HplPioC12 = PioC.HplPin12;
	HplPioC13 = PioC.HplPin13;
	HplPioC14 = PioC.HplPin14;
	HplPioC15 = PioC.HplPin15;
	HplPioC16 = PioC.HplPin16;
	HplPioC17 = PioC.HplPin17;
	HplPioC18 = PioC.HplPin18;
	HplPioC19 = PioC.HplPin19;
	HplPioC20 = PioC.HplPin20;
	HplPioC21 = PioC.HplPin21;
	HplPioC22 = PioC.HplPin22;
	HplPioC23 = PioC.HplPin23;
	HplPioC24 = PioC.HplPin24;
	HplPioC25 = PioC.HplPin25;
	HplPioC26 = PioC.HplPin26;
	HplPioC27 = PioC.HplPin27;
	HplPioC28 = PioC.HplPin28;
	HplPioC29 = PioC.HplPin29;
	HplPioC30 = PioC.HplPin30;
	HplPioC31 = PioC.HplPin31;
}
