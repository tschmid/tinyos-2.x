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
 * Timer Counter register definitions.
 *
 * @author Thomas Schmid
 */

#ifndef SAM3UTCHARDWARE_H
#define SAM3UTCHARDWARE_H

/**
 *  TC Block Control Register, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 828
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint8_t sync      : 1; // synchro command
        uint8_t reserved0 : 7;
        uint8_t reserved1 : 8;
        uint8_t reserved2 : 8;
    } bits;
} tc_bcr_t;

/**
 *  TC Block Mode Register, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 829
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint8_t tc0xc0s    : 2; // external clock signal 0 selection
        uint8_t tc1xc1s    : 2; // external clock signal 1 selection
        uint8_t tc2xc2s    : 2; // external clock signal 2 selection
        uint8_t reserved0  : 2;
        uint8_t qden       : 1; // quadrature decoder enabled
        uint8_t posen      : 1; // position enabled
        uint8_t speeden    : 1; // speed enabled
        uint8_t qdtrans    : 1; // quadrature decoding transparent
        uint8_t edgpha     : 1; // edge on pha count mode
        uint8_t inva       : 1; // invert pha
        uint8_t invb       : 1; // invert phb
        uint8_t invidx     : 1; // swap pha and phb
        uint8_t swap       : 1; // inverted index
        uint8_t idxphb     : 1; // index pin is phb pin
        uint8_t reserved1  : 1;
        uint8_t filter     : 1; // filter
        uint8_t maxfilt    : 6; // maximum filter
        uint8_t reserved2  : 6;
    } bits;
} tc_bmr_t;

/**
 *  TC Channel Control Register, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 831 
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint8_t clken      :  1; // counter clock enable command
        uint8_t clkdis     :  1; // counter clock disable command
        uint8_t swtrg      :  1; // software trigger command
        uint8_t reserved0  :  5;
        uint8_t reserved1  :  8;
        uint16_t reserved2 : 16;
    } bits;
} tc_ccr_t;

/**
 *  TC QDEC Interrupt Enable Register, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 832 
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint8_t idx        :  1; // index
        uint8_t dirchg     :  1; // direction change
        uint8_t qerr       :  1; // quadrature error
        uint8_t reserved0  :  5;
        uint8_t reserved1  :  8;
        uint16_t reserved2 : 16;
    } bits;
} tc_qier_t;

/**
 *  TC QDEC Interrupt Disable Register, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 833
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint8_t idx        :  1; // index
        uint8_t dirchg     :  1; // direction change
        uint8_t qerr       :  1; // quadrature error
        uint8_t reserved0  :  5;
        uint8_t reserved1  :  8;
        uint16_t reserved2 : 16;
    } bits;
} tc_qidr_t;

/**
 *  TC QDEC Interrupt Mask Register, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 834
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint8_t idx        :  1; // index
        uint8_t dirchg     :  1; // direction change
        uint8_t qerr       :  1; // quadrature error
        uint8_t reserved0  :  5;
        uint8_t reserved1  :  8;
        uint16_t reserved2 : 16;
    } bits;
} tc_qimr_t;

/**
 *  TC QDEC Interrupt Status Register, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 835 
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint8_t idx        :  1; // index
        uint8_t dirchg     :  1; // direction change
        uint8_t qerr       :  1; // quadrature error
        uint8_t reserved0  :  5;
        uint8_t dir        :  1; // direction
        uint8_t reserved1  :  7;
        uint16_t reserved2 : 16;
    } bits;
} tc_qisr_t;

/**
 *  TC Channel Mode Register Capture Mode, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 836
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint8_t tcclks    : 3; // clock selection
        uint8_t clki      : 1; // clock invert
        uint8_t burst     : 2; // burst signal selection
        uint8_t ldbstop   : 1; // counter clock stopped with rb loading
        uint8_t ldbdis    : 1; // counter clock disable with rb loading
        uint8_t etrgedg   : 1; // external trigger edge selection
        uint8_t abetrg    : 1; // tioa or tiob external trigger selection
        uint8_t reserved0 : 3;
        uint8_t cpctrg    : 1; // rc compare trigger enable
        uint8_t wave      : 1; // wave
        uint8_t ldra      : 2; // ra loading selection
        uint8_t ldrb      : 2; // rb loading selection
        uint8_t reserved1 : 4;
        uint8_t reserved2 : 8;
    } bits;
} tc_cmr_capture_t;

#define TC_CMR_ETRGEDG_NONE     0 
#define TC_CMR_ETRGEDG_RISING   1
#define TC_CMR_ETRGEDG_FALLING  2
#define TC_CMR_ETRGEDG_EACH     3

#define TC_CMR_CAPTURE          0
#define TC_CMR_WAVE             1

#define TC_CMR_CLK_TC1          0
#define TC_CMR_CLK_TC2          1
#define TC_CMR_CLK_TC3          2
#define TC_CMR_CLK_TC4          3
#define TC_CMR_CLK_SLOW         4
#define TC_CMR_CLK_XC0          5
#define TC_CMR_CLK_XC1          6
#define TC_CMR_CLK_XC2          7

#define TC_CMR_ABETRG_TIOA      0
#define TC_CMR_ABETRG_TIOB      1

/**
 *  TC Channel Mode Register Waveform Mode, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 838
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint8_t tcclks    : 3; // clock selection
        uint8_t clki      : 1; // clock invert
        uint8_t burst     : 2; // burst signal selection
        uint8_t cpcstop   : 1; // counter clock stopped with rc compare
        uint8_t cpcdis    : 1; // counter clock disable with rc compare
        uint8_t eevtedg   : 2; // external event edge selection
        uint8_t eevt      : 2; // external event selection
        uint8_t enetrg    : 1; // external event trigger enable
        uint8_t wavsel    : 2; // waveform selection
        uint8_t wave      : 1; // wave
        uint8_t acpa      : 2; // ra compare effect on tioa
        uint8_t acpc      : 2; // rc compare effect on tioa
        uint8_t aeevt     : 2; // external event effect on tioa
        uint8_t aswtrg    : 2; // software trigger effect on tioa
        uint8_t bcpb      : 2; // rb compare effect on tiob
        uint8_t bcpc      : 2; // rc compare effect on tiob
        uint8_t beevt     : 2; // external event effect on tiob
        uint8_t bswtrg    : 2; // software trigger effect on tiob
    } bits;
} tc_cmr_wave_t;

/**
 *  TC Counter Value Register, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 842 
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint16_t cv       : 16; // counter value
        uint16_t reserved : 16;
    } bits;
} tc_cv_t;

/**
 *  TC Register A, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 842 
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint16_t ra        : 16; // register a
        uint16_t reserved  : 16;
    } bits;
} tc_ra_t;

/**
 *  TC Register B, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 843 
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint16_t rb        : 16; // register b
        uint16_t reserved  : 16;
    } bits;
} tc_rb_t;

/**
 *  TC Register C, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 843 
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint16_t rc        : 16; // register c
        uint16_t reserved  : 16;
    } bits;
} tc_rc_t;

/**
 *  TC Status Register, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 844
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint8_t covfs      : 1; // counter overflow status
        uint8_t lovrs      : 1; // load overrun status
        uint8_t cpas       : 1; // ra compare status
        uint8_t cpbs       : 1; // rb compare status
        uint8_t cpcs       : 1; // rc compare status
        uint8_t ldras      : 1; // ra loading status
        uint8_t ldrbs      : 1; // rb loading status
        uint8_t etrgs      : 1; // external trigger status
        uint8_t reserved0  : 8;
        uint8_t clksta     : 1; // clock enable status
        uint8_t mtioa      : 1; // tioa mirror
        uint8_t mtiob      : 1; // tiob mirror
        uint8_t reserved1  : 5;
        uint8_t reserved2  : 8;
    } bits;
} tc_sr_t;

/**
 *  TC Interrupt Enable Register, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 846 
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint8_t covfs      : 1; // counter overflow 
        uint8_t lovrs      : 1; // load overrun 
        uint8_t cpas       : 1; // ra compare 
        uint8_t cpbs       : 1; // rb compare 
        uint8_t cpcs       : 1; // rc compare 
        uint8_t ldras      : 1; // ra loading 
        uint8_t ldrbs      : 1; // rb loading 
        uint8_t etrgs      : 1; // external trigger 
        uint8_t reserved0  : 8;
        uint16_t reserved1 :16;
    } bits;
} tc_ier_t;

/**
 *  TC Interrupt Disable Register, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 847 
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint8_t covfs      : 1; // counter overflow 
        uint8_t lovrs      : 1; // load overrun 
        uint8_t cpas       : 1; // ra compare 
        uint8_t cpbs       : 1; // rb compare 
        uint8_t cpcs       : 1; // rc compare 
        uint8_t ldras      : 1; // ra loading 
        uint8_t ldrbs      : 1; // rb loading 
        uint8_t etrgs      : 1; // external trigger 
        uint8_t reserved0  : 8;
        uint16_t reserved1 :16;
    } bits;
} tc_idr_t;

/**
 *  TC Interrupt Mask Register, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 848 
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint8_t covfs      : 1; // counter overflow 
        uint8_t lovrs      : 1; // load overrun 
        uint8_t cpas       : 1; // ra compare 
        uint8_t cpbs       : 1; // rb compare 
        uint8_t cpcs       : 1; // rc compare 
        uint8_t ldras      : 1; // ra loading 
        uint8_t ldrbs      : 1; // rb loading 
        uint8_t etrgs      : 1; // external trigger 
        uint8_t reserved0  : 8;
        uint16_t reserved1 :16;
    } bits;
} tc_imr_t;

/**
 * Channel definition capture mode
 */
typedef struct
{
    volatile tc_ccr_t ccr;
    volatile tc_cmr_capture_t cmr;
    uint32_t reserved[2];
    volatile tc_cv_t cv;
    volatile tc_ra_t ra;
    volatile tc_rb_t rb;
    volatile tc_rc_t rc;
    volatile tc_sr_t sr;
    volatile tc_ier_t ier;
    volatile tc_idr_t idr;
    volatile tc_imr_t imr;
} tc_channel_capture_t;

/**
 * Channel definition wave mode
 */
typedef struct
{
    volatile tc_ccr_t ccr;
    volatile tc_cmr_wave_t cmr;
    uint32_t reserved[2];
    volatile tc_cv_t cv;
    volatile tc_ra_t ra;
    volatile tc_rb_t rb;
    volatile tc_rc_t rc;
    volatile tc_sr_t sr;
    volatile tc_ier_t ier;
    volatile tc_idr_t idr;
    volatile tc_imr_t imr;
} tc_channel_wave_t;

/**
 * TC definition capture mode
 */
typedef struct
{
    volatile tc_channel_capture_t ch0;
    uint32_t reserved0[4];
    volatile tc_channel_capture_t ch1;
    uint32_t reserved1[4];
    volatile tc_channel_capture_t ch2;
    uint32_t reserved2[4];
    volatile tc_bcr_t bcr;
    volatile tc_bmr_t bmr;
    volatile tc_qier_t qier;
    volatile tc_qidr_t qidr;
    volatile tc_qimr_t qimr;
    volatile tc_qisr_t qisr;
} tc_t;

/**
 * TC Register definitions, AT91 ARM Cortex-M3 based Microcontrollers SAM3U
 * Series, Preliminary 9/1/09, p. 827
 */
#define TC_BASE     0x40080000
#define TC_CH0_BASE 0x40080000
#define TC_CH1_BASE 0x40080040
#define TC_CH2_BASE 0x40080080

volatile tc_t* TC = (volatile tc_t*)TC_BASE;

#endif //SAM3UTCHARDWARE_H

