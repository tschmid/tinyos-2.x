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
 * Static Memory Controller Register Definitions
 *
 * @author Thomas Schmid
 */

#ifndef _SAM3USMCHARDWARE_H
#define _SAM3USMCHARDWARE_H

/**
 *  SMC SETUP Register, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint8_t nwe_setup     : 6; // NWE Setup length
        uint8_t reserved0     : 2;
        uint8_t ncs_wr_setup  : 6; // ncs setup length in write access
        uint8_t reserved1     : 2;
        uint8_t nrd_setup     : 6; // nrd setup length
        uint8_t reserved2     : 2;
        uint8_t ncs_rd_setup  : 6; // ncs setup length in read access
        uint8_t reserved3     : 2;
    } __attribute__((__packed__)) bits;
} smc_setup_t;

/**
 *  SMC PULSE Register, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint8_t nwe_pulse     : 6; // NWE setup length
        uint8_t reserved0     : 2;
        uint8_t ncs_wr_pulse  : 6; // ncs setup length in write access
        uint8_t reserved1     : 2;
        uint8_t nrd_pulse     : 6; // nrd setup length
        uint8_t reserved2     : 2;
        uint8_t ncs_rd_pulse  : 6; // ncs setup length in read access
        uint8_t reserved3     : 2;
    } __attribute__((__packed__)) bits;
} smc_pulse_t;

/**
 *  SMC CYCLE Register, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint16_t nwe_cycle    : 9; // total write cycle length
        uint8_t reserved0     : 7;
        uint16_t nrd_cycle    : 9; // total read cycle length
        uint8_t reserved1     : 7;
    } __attribute__((__packed__)) bits;
} smc_cycle_t;

/**
 *  SMC TIMINGS Register, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 
 */

typedef union
{
    uint32_t flat;
    struct
    {
        uint8_t tclr        : 4; // cle to ren low delay
        uint8_t tadl        : 4; // ale to data start
        uint8_t tar         : 4; // ale to ren low delay
        uint8_t ocms        : 1; // off chip memory scrambling enable
        uint8_t reserved0   : 3;
        uint8_t trr         : 4; // ready to ren low delay
        uint8_t reserved1   : 4;
        uint8_t twb         : 4; // wen high to ren to busy
        uint8_t rbnsel      : 3; // ready/busy line selection
        uint8_t nfsel       : 1; // nand flash selection
    } __attribute__((__packed__)) bits;
} smc_timings_t;

/**
 *  SMC MODE Register, AT91 ARM Cortex-M3 based Microcontrollers
 *  SAM3U Series, Preliminary 9/1/09, p. 
 */
typedef union
{
    uint32_t flat;
    struct
    {
        uint8_t read_mode    : 1; // read mode
        uint8_t write_mode   : 1; // write mode
        uint8_t reserved0    : 2;
        uint8_t exnw_mode    : 2; // nwait mode
        uint8_t reserved1    : 2;
        uint8_t bat          : 1; // byte access type
        uint8_t reserved2    : 3;
        uint8_t dbw          : 1; // data bus width
        uint8_t reserved3    : 3;
        uint8_t tdf_cycles   : 4; // data float time
        uint8_t tdf_mode     : 1; // tdf optimization
        uint8_t reserved4    : 3;
        uint8_t pmen         : 1; // page mode enable (note, not in documentation, but in code at91lib!)
        uint8_t reserved5    : 3;
        uint8_t ps           : 2; // page mode size (note: not in documentation, but in code at91lib!)
        uint8_t reserved6    : 3;
    } __attribute__((__packed__)) bits;
} smc_mode_t;

typedef struct
{
    volatile smc_setup_t setup;
    volatile smc_pulse_t pulse;
    volatile smc_cycle_t cycle;
    volatile smc_timings_t timings;
    volatile smc_mode_t mode;
} smc_cs_t;

volatile smc_cs_t* SMC_CS0 = (volatile smc_cs_t*)0x400E0070; 
volatile smc_cs_t* SMC_CS1 = (volatile smc_cs_t*)0x400E0084; 
volatile smc_cs_t* SMC_CS2 = (volatile smc_cs_t*)0x400E0098; 
volatile smc_cs_t* SMC_CS3 = (volatile smc_cs_t*)0x400E00AC; 

#endif //_SAM3USMCHARDWARE_H
