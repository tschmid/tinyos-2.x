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

/* Exception handlers for STM32 */

#ifndef __STM32EXCEPTIONS_H
#define __STM32EXCEPTIONS_H

/* Use a shared infinite loop for unexpected exceptions. */
/* #define SHARED_EXCEPTION_HANDLER */

/* Or use an external handler for unexpected exceptions. */
/* #define CUSTOM_EXCEPTION_HANDLER */

/* Or else use individual infinite loops when debugging,
 * or a shared infinite loop when not. */

#ifdef CUSTOM_EXCEPTION_HANDLER
	void unexpected_exception(const char* name, int address);
	#define DEFAULT_EXCEPTION_HANDLER(handler, name, number, address) unexpected_exception(name, address);
#endif

/* [0x08] NMI Exception (from the RCC Clock Security System) */
void NMIException(void);

/* [0x0C] Hard Fault Exception */
void HardFaultException(void);

/* [0x10] Memory Management Exception */
void MemManageException(void);

/* [0x14] Bus Fault Exception (prefetch and memory access faults) */
void BusFaultException(void);

/* [0x18] Usage Fault Exception (undefined instruction or illegal state faults) */
void UsageFaultException(void);

void __STM32ReservedException7(void);
void __STM32ReservedException8(void);
void __STM32ReservedException9(void);
void __STM32ReservedException10(void);

/* [0x2C] SVCall Exception (system service call via SWI instruction) */
void SVCHandler(void);

/* [0x30] Debug Monitor Exception */
void DebugMonitor(void);

void __STM32ReservedException13(void);

/* [0x38] PendSVC Exception (pendable request for system service) */
void PendSVC(void);

/* [0x3C] SysTick Exception */
void SysTickHandler(void);

/* [0x40] WWDG Interrupt */
void WWDG_IRQHandler(void);

/* [0x44] PVD Interrupt (EXTI Line 16) */
void PVD_IRQHandler(void);

/* [0x48] Tamper Interrupt */
void TAMPER_IRQHandler(void);

/* [0x4C] RTC Interrupt */
void RTC_IRQHandler(void);

/* [0x50] Flash Interrupt */
void FLASH_IRQHandler(void);

/* [0x54] RCC Interrupt */
void RCC_IRQHandler(void);

/* [0x58] EXTI Line 0 Interrupt */
void EXTI0_IRQHandler(void);

/* [0x5C] EXTI Line 1 Interrupt */
void EXTI1_IRQHandler(void);

/* [0x60] EXTI Line 2 Interrupt */
void EXTI2_IRQHandler(void);

/* [0x64] EXTI Line 3 Interrupt */
void EXTI3_IRQHandler(void);

/* [0x68] EXTI Line 4 Interrupt */
void EXTI4_IRQHandler(void);

/* [0x6C] DMA Channel 1 Interrupt */
void DMAChannel1_IRQHandler(void);

/* [0x70] DMA Channel 2 Interrupt */
void DMAChannel2_IRQHandler(void);

/* [0x74] DMA Channel 3 Interrupt */
void DMAChannel3_IRQHandler(void);

/* [0x78] DMA Channel 4 Interrupt */
void DMAChannel4_IRQHandler(void);

/* [0x7C] DMA Channel 5 Interrupt */
void DMAChannel5_IRQHandler(void);

/* [0x80] DMA Channel 6 Interrupt */
void DMAChannel6_IRQHandler(void);

/* [0x84] DMA Channel 7 Interrupt */
void DMAChannel7_IRQHandler(void);

/* [0x88] ADC Interrupt */
void ADC_IRQHandler(void);

/* [0x8C] USB High Priority/CAN TX Interrupt */
void USB_HP_CAN_TX_IRQHandler(void);

/* [0x90] USB Low Priority/CAN RX0 Interrupt */
void USB_LP_CAN_RX0_IRQHandler(void);

/* [0x94] CAN RX1 Interrupt */
void CAN_RX1_IRQHandler(void);

/* [0x98] CAN SCE Interrupt */
void CAN_SCE_IRQHandler(void);

/* [0x9C] EXTI Lines 5-9 Interrupt */
void EXTI9_5_IRQHandler(void);

/* [0xA0] TIM1 Break Interrupt */
void TIM1_BRK_IRQHandler(void);

/* [0xA4] TIM1 Update Interrupt */
void TIM1_UP_IRQHandler(void);

/* [0xA8] TIM1 Trigger/Commutation Interrupt */
void TIM1_TRG_COM_IRQHandler(void);

/* [0xAC] TIM1 Capture/Compare Interrupt */
void TIM1_CC_IRQHandler(void);

/* [0xB0] TIM2 Interrupt */
void TIM2_IRQHandler(void);

/* [0xB4] TIM3 Interrupt */
void TIM3_IRQHandler(void);

/* [0xB8] TIM4 Interrupt */
void TIM4_IRQHandler(void);

/* [0xBC] I2C1 Event Interrupt */
void I2C1_EV_IRQHandler(void);

/* [0xC0] I2C1 Error Interrupt */
void I2C1_ER_IRQHandler(void);

/* [0xC4] I2C2 Event Interrupt */
void I2C2_EV_IRQHandler(void);

/* [0xC8] I2C2 Error Interrupt */
void I2C2_ER_IRQHandler(void);

/* [0xCC] SPI1 Interrupt */
void SPI1_IRQHandler(void);

/* [0xD0] SPI2 Interrupt */
void SPI2_IRQHandler(void);

/* [0xD4] USART1 Interrupt */
void USART1_IRQHandler(void);

/* [0xD8] USART2 Interrupt */
void USART2_IRQHandler(void);

/* [0xDC] USART3 Interrupt */
void USART3_IRQHandler(void);

/* [0xE0] EXTI Lines 10-15 Interrupt */
void EXTI15_10_IRQHandler(void);

/* [0xE8] USB Wake Up Interrupt (EXTI Line 18) */
void USBWakeUp_IRQHandler(void);

#endif /* __STM32EXCEPTIONS_H */
