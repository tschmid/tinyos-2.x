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

#include "sam3umpuhardware.h"

module HplSam3uMpuP
{
	provides interface HplSam3uMpu;
}
implementation
{
	async command void HplSam3uMpu.enableMpu()
	{
		MPU_CTRL->bits.enable = 1;
	}

	async command void HplSam3uMpu.disableMpu()
	{
		MPU_CTRL->bits.enable = 0;
	}

	async command void HplSam3uMpu.enableMpuDuringHardFaults()
	{
		MPU_CTRL->bits.hfnmiena = 1;
	}

	async command void HplSam3uMpu.disableMpuDuringHardFaults()
	{
		MPU_CTRL->bits.hfnmiena = 0;
	}

	async command void HplSam3uMpu.enableDefaultBackgroundRegion()
	{
		MPU_CTRL->bits.privdefena = 1;
	}

	async command void HplSam3uMpu.disableDefaultBackgroundRegion()
	{
		MPU_CTRL->bits.privdefena = 0;
	}

	async command void HplSam3uMpu.writeProtect(void *pointer)
	{
		mpu_rbar_t rbar;
		mpu_rasr_t rasr;

		// setup IRQ, p. 8-28, MEMFAULTENA = 1
		uint32_t value = *((volatile uint32_t *) 0xe000ed24);
		value |= 0x00010000;
		*((volatile uint32_t *) 0xe000ed24) = value;


		// setup MPU
		call HplSam3uMpu.enableDefaultBackgroundRegion();
		call HplSam3uMpu.disableMpuDuringHardFaults();

		rbar.flat = (uint32_t) pointer;
		rbar.bits.region = 0; // define region 0
		rbar.bits.valid = 1; // region field is valid
		//rbar.bits.addr = (((uint32_t) pointer) >> 5); // base address (now aligned to the minimum size)

		rasr.bits.xn = 1; // disable instruction fetch
		rasr.bits.ap = 6; // read only for privileged and user
		rasr.bits.srd = 0; // no subregions disabled
		rasr.bits.tex = 0;
		rasr.bits.s = 1;
		rasr.bits.c = 1;
		rasr.bits.b = 1; // p. 211
		rasr.bits.size = 4; // 32 Byte
		rasr.bits.enable = 1; // region enabled

		*MPU_RBAR = rbar;
		*MPU_RASR = rasr;

		call HplSam3uMpu.enableMpu();
	}

	async command void HplSam3uMpu.executeProtect(void *pointer)
	{
		mpu_rbar_t rbar;
		mpu_rasr_t rasr;

		// setup IRQ, p. 8-28, MEMFAULTENA = 1
		uint32_t value = *((volatile uint32_t *) 0xe000ed24);
		value |= 0x00010000;
		*((volatile uint32_t *) 0xe000ed24) = value;


		// setup MPU
		call HplSam3uMpu.enableDefaultBackgroundRegion();
		call HplSam3uMpu.disableMpuDuringHardFaults();

		rbar.flat = (uint32_t) pointer;
		rbar.bits.region = 0; // define region 0
		rbar.bits.valid = 1; // region field is valid
		//rbar.bits.addr = (((uint32_t) pointer) >> 5); // base address (now aligned to the minimum size)

		rasr.bits.xn = 1; // disable instruction fetch
		rasr.bits.ap = 6; // read only for privileged and user
		rasr.bits.srd = 0; // no subregions disabled
		rasr.bits.tex = 0;
		rasr.bits.s = 1;
		rasr.bits.c = 1;
		rasr.bits.b = 1; // p. 211
		rasr.bits.size = 4; // 32 Byte
		rasr.bits.enable = 1; // region enabled

		*MPU_RBAR = rbar;
		*MPU_RASR = rasr;

		call HplSam3uMpu.enableMpu();
	}

	__attribute__((interrupt)) void MpuFaultHandler() @C() @spontaneous()
	{
		signal HplSam3uMpu.mpuFault();
	}
}
