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
 * Definitions specific to the SAM3U ARM Cortex-M3 memory protection unit.
 *
 * @author wanja@cs.fau.de
 */

#ifndef SAM3UMPUHARDWARE_H
#define SAM3UMPUHARDWARE_H

// Defined in AT91 ARM Cortex-M3 based Microcontrollers, SAM3U Series, Preliminary, p. 211
typedef union
{
	uint32_t flat;
	struct
	{
		uint8_t separate  : 1; // support for unified or separate instruction and data memory maps
		uint8_t reserved0 : 7;
		uint8_t dregion   : 8; // number of supported MPU data regions
		uint8_t iregion   : 8; // number of supported MPU instruction regions
		uint8_t reserved1 : 8; // receiver disable
	} bits;
} mpu_type_t;

// Defined in AT91 ARM Cortex-M3 based Microcontrollers, SAM3U Series, Preliminary, p. 212
typedef union
{
	uint32_t flat;
	struct
	{
		uint8_t enable     : 1; // enables the MPU
		uint8_t hfnmiena   : 1; // enables MPU operation during hard fault, NMI, and FAULTMASK handlers
		uint8_t privdefena : 1; // enables priviliged access to default memory map
		uint8_t reserved0  : 5;
		uint8_t reserved1  : 8;
		uint8_t reserved2  : 8;
		uint8_t reserved3  : 8;
	} bits;
} mpu_ctrl_t;

// Defined in AT91 ARM Cortex-M3 based Microcontrollers, SAM3U Series, Preliminary, p. 214
typedef union
{
	uint32_t flat;
	struct
	{
		uint8_t region    : 8; // region referenced by RBAR and RASR registers
		uint8_t reserved0 : 8;
		uint8_t reserved1 : 8;
		uint8_t reserved2 : 8;
	} bits;
} mpu_rnr_t;

// Defined in AT91 ARM Cortex-M3 based Microcontrollers, SAM3U Series, Preliminary, p. 215
typedef union
{
	uint32_t flat;
	struct
	{
		uint8_t  region : 4; // MPU region field
		uint8_t  valid  : 1; // MPU region number valid bit
		uint32_t addr   : 27; // region base address field, depending on the region size in RASR!
	} bits;
} mpu_rbar_r;

// Defined in AT91 ARM Cortex-M3 based Microcontrollers, SAM3U Series, Preliminary, p. 216
typedef union
{
	uint32_t flat;
	struct
	{
		uint8_t enable    : 1; // region enable bit
		uint8_t size      : 5; // size of the MPU protection region; minimum is 4 (32 B), maximum is 31 (4 GB)
		uint8_t reserved0 : 2;
		uint8_t srd       : 8; // subregion disable bits; 0 = enabled, 1 = disabled
		uint8_t b         : 1; // bufferable bit
		uint8_t c         : 1; // cacheable bit
		uint8_t s         : 1; // shareable bit
		uint8_t tex       : 3; // type extension field
		uint8_t reserved1 : 2;
		uint8_t ap        : 3; // access permission field
		uint8_t reserved2 : 1;
		uint8_t xn        : 1; // instruction access disable bit; 0 = fetches enabled, 1 = fetches disabled
		uint8_t reserved3 : 3;
	} bits;
} mpu_rasr_t;

// Defined in AT91 ARM Cortex-M3 based Microcontrollers, SAM3U Series, Preliminary, p. 210
volatile uint32_t*   MPU_BASE    = (volatile uint32_t *)   0xe000ed90;
volatile mpu_type_t* MPU_TYPE    = (volatile mpu_type_t *) 0xe000ed90;
volatile mpu_ctrl_t* MPU_CTRL    = (volatile mpu_ctrl_t *) 0xe000ed94;
volatile mpu_rnr_t*  MPU_RNR     = (volatile mpu_rnr_t *)  0xe000ed98;
volatile mpu_rbar_t* MPU_RBAR    = (volatile mpu_rbar_t *) 0xe000ed9c;
volatile mpu_rasr_t* MPU_RASR    = (volatile mpu_rasr_t *) 0xe000eda0;
volatile mpu_rbar_t* MPU_RBAR_A1 = (volatile mpu_rbar_t *) 0xe000eda4;
volatile mpu_rasr_t* MPU_RASR_A1 = (volatile mpu_rasr_t *) 0xe000eda8;
volatile mpu_rbar_t* MPU_RBAR_A2 = (volatile mpu_rbar_t *) 0xe000edac;
volatile mpu_rasr_t* MPU_RASR_A2 = (volatile mpu_rasr_t *) 0xe000edb0;
volatile mpu_rbar_t* MPU_RBAR_A3 = (volatile mpu_rbar_t *) 0xe000edb4;
volatile mpu_rasr_t* MPU_RASR_A3 = (volatile mpu_rasr_t *) 0xe000edb8;

#endif // SAM3UMPUHARDWARE_H