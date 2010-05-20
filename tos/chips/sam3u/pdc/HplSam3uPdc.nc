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
 * @author JeongGil Ko
 */

interface HplSam3uPdc {

  /* Pointer Registers */
  command void setRxPtr(void* addr);
  command void setTxPtr(void* addr);
  command void setNextRxPtr(void* addr);
  command void setNextTxPtr(void* addr);

  /* Counter Registers */
  command void setRxCounter(uint16_t counter);
  command void setTxCounter(uint16_t counter);
  command void setNextRxCounter(uint16_t counter);
  command void setNextTxCounter(uint16_t counter);

  /* Enable / Disable Register */
  command void enablePdcRx();
  command void enablePdcTx();
  command void disablePdcRx();
  command void disablePdcTx();

  /* Status Registers  - Checks status */
  command bool rxEnabled();
  command bool txEnabled();

}
