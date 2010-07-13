/**                                                                     
 *  IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.  By
 *  downloading, copying, installing or using the software you agree to
 *  this license.  If you do not agree to this license, do not download,
 *  install, copy or use the software.
 *
 *  Copyright (c) 2004-2005 Crossbow Technology, Inc.
 *  Copyright (c) 2002-2003 Intel Corporation.
 *  Copyright (c) 2000-2003 The Regents of the University  of California.    
 *  All rights reserved.
 *
 *  Permission to use, copy, modify, and distribute this software and its
 *  documentation for any purpose, without fee, and without written
 *  agreement is hereby granted, provided that the above copyright
 *  notice, the (updated) modification history and the author appear in
 *  all copies of this source code.
 *
 *  Permission is also granted to distribute this software under the
 *  standard BSD license as contained in the TinyOS distribution.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 *  PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE INTEL OR ITS
 *  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 *  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *  @author Jason Hill, Philip Levis, Nelson Lee, David Gay
 *  @author Alan Broad <abroad@xbow.com>
 *  @author Matt Miller <mmiller@xbow.com>
 *  @author Martin Turon <mturon@xbow.com>
 *
 *  $Id: hardware.h,v 1.1 2009/03/21 20:56:56 phsommer Exp $
 */
/*
 * Adjusted for CSIRO fleck3c, 2009
 *
 * Author: Christian.Richter@csiro.au
 */
#ifndef HARDWARE_H
#define HARDWARE_H

#ifndef MHZ
/* Clock rate is ~8MHz except if specified by user 
   (this value must be a power of 2, see MicaTimer.h and MeasureClockC.nc) */
#define MHZ 8
#endif

#include <atm128hardware.h>
#include <Atm128Adc.h>
#include <MicaTimer.h>

#ifndef PLATFORM_BAUDRATE
#define PLATFORM_BAUDRATE 57600L
#endif

#if !defined(USE_RF230_RADIO) && !defined(USE_RF212_RADIO)
	#warning !!!!!!!!!!!!!!!!!!!!!    default radio (rf230) used     !!!!!!!!!!!!!!!!!!!!!!!
#define USE_RF230_RADIO
#endif
#define NUM_RADIOS 1
#if defined(USE_RF230_RADIO) && defined(USE_RF212_RADIO)
#undef NUM_RADIOS
#define NUM_RADIOS 2
#endif

#ifndef UQ_R534_RADIO
#define UQ_R534_RADIO "Unique_R534_Radio"
#endif
enum {
#ifdef USE_RF230_RADIO
  RF230_RADIO_ID = unique( UQ_R534_RADIO ),
#endif
#ifdef USE_RF212_RADIO
  RF212_RADIO_ID = unique( UQ_R534_RADIO ),
#endif
};

typedef uint8_t radio_id_t;

#endif //HARDWARE_H
