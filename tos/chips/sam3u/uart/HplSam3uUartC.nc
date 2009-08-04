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

#include "sam3uuarthardware.h"

/**
 * The hardware presentation layer for the SAM3U UART.
 *
 * @author wanja@cs.fau.de
 */

module HplSam3uUartC
{
	provides
	{
		interface HplSam3uUartConfig;
		interface HplSam3uUartControl;
		interface HplSam3uUartInterrupts;
		interface HplSam3uUartStatus;
	}
}
implementation
{
	/**
	 * cd = 0: baud rate generator disabled
	 * cd = 0: baud rate = MCK
	 * cd = 2--65535: baud rate = MCK / (cd * 16)
	 */
	async command error_t setClockDivisor(uint16_t cd)
	{
		UART_BRGR->bits.cd = cd;
		return SUCCESS;
	}

	/**
	 * par = 0x0/UART_MR_PAR_EVEN: even
	 * par = 0x1/UART_MR_PAR_ODD: odd
	 * par = 0x2/UART_MR_PAR_SPACE: space (forced to 0)
	 * par = 0x3/UART_MR_PAR_MARK: mark (forced to 1)
	 * par = 0x4/UART_MR_PAR_NONE: none
	 */
	async command error_t setParityType(uint8_t par)
	{
		if (par > 0x4) return FAIL;
		UART_MR->bits.par = par;
		return SUCCESS;
	}

	/**
	 * chmode = 0x0/UART_MR_CHMODE_NORMAL: normal
	 * chmode = 0x1/UART_MR_CHMODE_AUTOECHO: automatic echo
	 * chmode = 0x2/UART_MR_CHMODE_LOCALLOOP: local loopback
	 * chmode = 0x3/UART_MR_CHMODE_REMOTELOOP: remote loopback
	 */
	async command error_t setChannelMode(uint8_t chmode)
	{
		if (chmode > 0x3) return FAIL;
		UART_MR->bits.chmode = chmode;
		return SUCCESS;
	}

	async command void resetReceiver()
	{
		UART_CR->bits.rstrx = 1;
	}
	async command void resetTransmitter();
	{
		UART_CR->bits.rsttx = 1;
	}
	async command void enableReceiver();
	{
		UART_CR->bits.rxen = 1;
	}
	async command void disableReceiver();
	{
		UART_CR->bits.rxdis = 1;
	}
	async command void enableTransmitter();
	{
		UART_CR->bits.txen = 1;
	}
	async command void disableTransmitter();
	{
		UART_CR->bits.txdis = 1;
	}
	async command void resetStatusBits();
	{
		UART_CR->bits.rststa = 1;
	}

	// Rxrdy
	async command void enableRxrdyIrq()
	{
		UART_IER->bits.rxrdy = 1;
	}
	async command void disableRxrdyIrq()
	{
		UART_IDR->bits.rxrdy = 1;
	}
	async command bool isEnabledRxrdyIrq()
	{
		return (UART_IMR->bits.rxrdy == 0x1);
	}

	// Txrdy
	async command void enableTxrdyIrq()
	{
		UART_IER->bits.txrdy = 1;
	}
	async command void disableTxrdyIrq()
	{
		UART_IDR->bits.txrdy = 1;
	}
	async command bool isEnabledTxrdyIrq()
	{
		return (UART_IMR->bits.txrdy == 0x1);
	}

	// Endrx
	async command void enableEndrxIrq()
	{
		UART_IER->bits.endrx = 1;
	}
	async command void disableEndrxIrq()
	{
		UART_IDR->bits.endrx = 1;
	}
	async command bool isEnabledEndrxIrq()
	{
		return (UART_IMR->bits.endrx == 0x1);
	}

	// Endtx
	async command void enableEndtxIrq()
	{
		UART_IER->bits.endtx = 1;
	}
	async command void disableEndtxIrq()
	{
		UART_IDR->bits.endtx = 1;
	}
	async command bool isEnabledEndtxIrq()
	{
		return (UART_IMR->bits.endtx == 0x1);
	}

	// Ovre
	async command void enableOvreIrq()
	{
		UART_IER->bits.ovre = 1;
	}
	async command void disableOvreIrq()
	{
		UART_IDR->bits.ovre = 1;
	}
	async command bool isEnabledOvreIrq()
	{
		return (UART_IMR->bits.ovre == 0x1);
	}

	// Frame
	async command void enableFrameIrq()
	{
		UART_IER->bits.frame = 1;
	}
	async command void disableFrameIrq()
	{
		UART_IDR->bits.frame = 1;
	}
	async command bool isEnabledFrameIrq()
	{
		return (UART_IMR->bits.frame == 0x1);
	}

	// Pare
	async command void enablePareIrq()
	{
		UART_IER->bits.pare = 1;
	}
	async command void disablePareIrq()
	{
		UART_IDR->bits.pare = 1;
	}
	async command bool isEnabledPareIrq()
	{
		return (UART_IMR->bits.pare == 0x1);
	}

	// Txempty
	async command void enableTxemptyIrq()
	{
		UART_IER->bits.txempty = 1;
	}
	async command void disableTxemptyIrq()
	{
		UART_IDR->bits.txempty = 1;
	}
	async command bool isEnabledTxemptyIrq()
	{
		return (UART_IMR->bits.txempty == 0x1);
	}

	// Txbufe
	async command void enableTxbufeIrq()
	{
		UART_IER->bits.txbufe = 1;
	}
	async command void disableTxbufeIrq()
	{
		UART_IDR->bits.txbufe = 1;
	}
	async command bool isEnabledTxbufeIrq()
	{
		return (UART_IMR->bits.txbufe == 0x1);
	}

	// Rxbuff
	async command void enableRxbuffIrq()
	{
		UART_IER->bits.rxbuff = 1;
	}
	async command void disableRxbuffIrq()
	{
		UART_IDR->bits.rxbuff = 1;
	}
	async command bool isEnabledRxbuffIrq()
	{
		return (UART_IMR->bits.rxbuff == 0x1);
	}

	async command uint8_t getReceivedChar()
	{
		return UART_RHR->bits.rxchr;
	}
	async command void setCharToTransmit(uint8_t txchr)
	{
		UART_THR->bits.txchr = txchr;
	}

	async command bool isReceiverReady()
	{
		return (UART_SR->bits.rxrdy == 0x1);
	}
	async command bool isTransmitterReady()
	{
		return (UART_SR->bits.txrdy == 0x1);
	}
	async command bool isEndOfReceiverTransfer()
	{
		return (UART_SR->bits.endrx == 0x1);
	}
	async command bool isEndOfTransmitterTransfer()
	{
		return (UART_SR->bits.endtx == 0x1);
	}
	async command bool isOverrunError()
	{
		return (UART_SR->bits.ovre == 0x1);
	}
	async command bool isFramingError()
	{
		return (UART_SR->bits.frame == 0x1);
	}
	async command bool isParityError()
	{
		return (UART_SR->bits.pare == 0x1);
	}
	async command bool isTransmitterEmpty()
	{
		return (UART_SR->bits.txempty == 0x1);
	}
	async command bool isTransmissionBufferEmpty()
	{
		return (UART_SR->bits.txbufe == 0x1);
	}
	async command bool isReceiveBufferFull()
	{
		return (UART_SR->bits.rxbuff == 0x1);
	}
}
