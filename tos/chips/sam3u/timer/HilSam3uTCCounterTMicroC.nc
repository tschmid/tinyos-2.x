/* "Copyright (c) 2000-2003 The Regents of the University of California.
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
 * HilSam3uTCCounterTMicroC provides the an approximate TMicro counter for the
 * SAM3U.
 *
 * @author Thomas Schmid
 * @see  Please refer to TEP 102 for more information about this component and its
 *          intended use.
 */

configuration HilSam3uTCCounterTMicroC
{
  provides {
      interface Counter<TMicro,uint16_t> as HilSam3uTCCounterTMicro;
      interface HplSam3uTCChannel;
      interface HplSam3uTCCompare;
  }
}
implementation
{
  components HplSam3uTCC;
  components new HilSam3uTCCounterC(TMicro) as Counter;

  HilSam3uTCCounterTMicro = Counter;
  Counter.HplSam3uTCChannel -> HplSam3uTCC.TC2;

  HplSam3uTCChannel = HplSam3uTCC.TC2;
  HplSam3uTCCompare = HplSam3uTCC.TC2CompareC;
}

