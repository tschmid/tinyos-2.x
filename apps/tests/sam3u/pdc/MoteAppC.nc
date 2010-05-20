/*
* Copyright (c) 2009 Johns Hopkins University.
* All rights reserved.
*
* Permission to use, copy, modify, and distribute this software and its
* documentation for any purpose, without fee, and without written
* agreement is hereby granted, provided that the above copyright
* notice, the (updated) modification history and the author appear in
* all copies of this source code.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS  `AS IS'
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED  TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR  PURPOSE
* ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR  CONTRIBUTORS
* BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE,  DATA,
* OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR  OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
* THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * Simple test program for SAM3U's 12 bit ADC Read with LCD
 * @author Chieh-Jan Mike Liang
 * @author JeongGil Ko
 */

configuration MoteAppC {}

implementation
{
  components MainC,
    LedsC, NoLedsC,
    new TimerMilliC() as TimerC,
    SerialActiveMessageC,
    LcdC,
    Sam3uDmaC,
    HplNVICC,
    HplSam3uClockC,
    HplSam3uPdcC,
    MoteP;

  MoteP.Boot -> MainC;
  MoteP.Leds -> LedsC;
  MoteP.SerialSplitControl -> SerialActiveMessageC;
  MoteP.Packet -> SerialActiveMessageC;
  MoteP.Timer -> TimerC;

  //MoteP.ClockControl -> HplSam3uClockC.DBGUPPCntl;
  //MoteP.PDC -> HplSam3uPdcC.UartPdcControl;

  MoteP.ClockControl -> HplSam3uClockC.TWI0PPCntl;
  MoteP.PDC -> HplSam3uPdcC.Twi0PdcControl;

  MoteP.Lcd -> LcdC;
  MoteP.Draw -> LcdC;
}
