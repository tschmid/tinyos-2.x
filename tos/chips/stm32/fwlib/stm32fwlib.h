#ifndef __STM32FWLIB_H
#define __STM32FWLIB_H

#include <stdint.h>
#include "stm32f10x_lib.h"

#define BB_BIT(REGISTER, BIT_NUMBER, BASE, BB_BASE) \
	((volatile int32_t*) ((BB_BASE) + (((uint32_t) &(REGISTER)) - (BASE)) * 32 + (BIT_NUMBER) * 4))

#define PERIPHERAL_BIT(REGISTER, BIT_NUMBER) \
	BB_BIT(REGISTER, BIT_NUMBER, PERIPH_BASE, PERIPH_BB_BASE)

#define SRAM_BIT(REGISTER, BIT_NUMBER) \
	BB_BIT(REGISTER, BIT_NUMBER, SRAM_BASE, SRAM_BB_BASE)

#endif /* __STM32FWLIB_H */
