/*
 * Copyright (c) 2005-2006 Arch Rock Corporation
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
 * - Neither the name of the Arch Rock Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * HPL implementation of general-purpose I/O for the ChipCon CC2420
 * radio connected to a SAM3U processor.
 *
 * @author Jonathan Hui <jhui@archrock.com>
 * @author Thomas Schmid (adaptation to SAM3U)
 */

configuration HplCC2420PinsC {

  provides 
  {
      interface GeneralIO as CCA;
      interface GeneralIO as FIFO;
      interface GeneralIO as FIFOP;
      interface GeneralIO as RSTN;
      interface GeneralIO as SFD;
      interface GeneralIO as CSN;
      interface GeneralIO as VREN;
  }

}

implementation {

  components HplSam3uGeneralIOC as GeneralIOC;

  CCA = GeneralIOC.PioC26;
  FIFO = GeneralIOC.PioA2;
  FIFOP = GeneralIOC.PioA0;
  RSTN = GeneralIOC.PioC27;
  SFD = GeneralIOC.PioA1;
  VREN = GeneralIOC.PioA17;
  CSN  = GeneralIOC.PioA19;

  // dummy connection for CSN
  //components HilSam3uSpiC;
  //CSN = HilSam3uSpiC.CSN;
  
}

