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

/*
 * @author Thomas Schmid
 */

#include "stm32exceptions.h"

module HplSTM32InterruptM
{
    provides {
        interface HplSTM32Interrupt as Irq;
    }

}

implementation 
{

/* Exception handlers for STM32 
 *
 * This code is meant to handle exceptions that the application does not expect.
 * Handlers that are part of the application should be defined elsewhere. */


#define DEFAULT_EXCEPTION_HANDLER(handler, name, number, address) while (1);

/* Undefined handlers will default to a shared infinite loop (see stm32-isrs.S). */

	/* [0x08] NMI Exception (from the RCC Clock Security System) */
	void NMIException(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(NMIException, "NMI", 2, 0x08);
        signal Irq.fired();
	}

	/* [0x0C] Hard Fault Exception */
	void HardFaultException(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(HardFaultException, "Hard Fault", 3, 0x0C);
	}

	/* [0x10] Memory Management Exception */
	void MemManageException(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(MemManageException, "Memory Management", 4, 0x10);
	}

	/* [0x14] Bus Fault Exception (prefetch and memory access faults) */
	void BusFaultException(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(BusFaultException, "Bus Fault", 5, 0x14);
	}

	/* [0x18] Usage Fault Exception (undefined instruction or illegal state faults) */
	void UsageFaultException(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(UsageFaultException, "Usage Fault", 6, 0x18);
	}

    void __STM32ReservedException7(void) @spontaneous() @C()
    {
		DEFAULT_EXCEPTION_HANDLER(__STM32ReservedException7, "Reserved Exception 7", 7, 0x1C);
    }

    void __STM32ReservedException8(void) @spontaneous() @C()
    {
        DEFAULT_EXCEPTION_HANDLER(__STM32ReservedException8, "Reserved Exception 8", 8, 0x20);
    }

    void __STM32ReservedException9(void) @spontaneous() @C()
    {
        DEFAULT_EXCEPTION_HANDLER(__STM32ReservedException9, "Reserved Exception 9", 9, 0x24);
    }

    void __STM32ReservedException10(void) @spontaneous() @C()
    {
        DEFAULT_EXCEPTION_HANDLER(__STM32ReservedException10, "Reserved Exception 10", 10, 0x28);
    }

	/* [0x2C] SVCall Exception (system service call via SWI instruction) */
	void SVCHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(SVCHandler, "SVCall", 11, 0x2C);
	}

	/* [0x30] Debug Monitor Exception */
	void DebugMonitor(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(DebugMonitor, "Debug Monitor", 12, 0x30);
	}

    void __STM32ReservedException13(void) @spontaneous() @C()
    {
		DEFAULT_EXCEPTION_HANDLER(__STM32ReservedException13, "Reserved Exception 13", 13, 0x34);
    }


	/* [0x38] PendSVC Exception (pendable request for system service) */
	void PendSVC(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(PendSVC, "PendSVC", 14, 0x38);
	}

	/* [0x3C] SysTick Exception */
	void SysTickHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(SysTickHandler, "SysTick", 15, 0x3C);
	}

	/* [0x40] WWDG Interrupt */
	void WWDG_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(WWDG_IRQHandler, "WWDG", 16, 0x40);
	}

	/* [0x44] PVD Interrupt (EXTI Line 16) */
	void PVD_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(PVD_IRQHandler, "PVD", 17, 0x44);
	}

	/* [0x48] Tamper Interrupt */
	void TAMPER_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(TAMPER_IRQHandler, "Tamper", 18, 0x48);
	}

	/* [0x4C] RTC Interrupt */

    /* Defined in STM32AlarmC!!!
	void RTC_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(RTC_IRQHandler, "RTC", 19, 0x4C);
	}
    */

	/* [0x50] Flash Interrupt */
	void FLASH_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(FLASH_IRQHandler, "Flash", 20, 0x50);
	}

	/* [0x54] RCC Interrupt */
	void RCC_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(RCC_IRQHandler, "RCC", 21, 0x54);
	}

	/* [0x58] EXTI Line 0 Interrupt */
	void EXTI0_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(EXTI0_IRQHandler, "EXTI Line 0", 22, 0x58);
	}

	/* [0x5C] EXTI Line 1 Interrupt */
	void EXTI1_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(EXTI1_IRQHandler, "EXTI Line 1", 23, 0x5C);
	}

	/* [0x60] EXTI Line 2 Interrupt */
	void EXTI2_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(EXTI2_IRQHandler, "EXTI Line 2", 24, 0x60);
	}

	/* [0x64] EXTI Line 3 Interrupt */
	void EXTI3_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(EXTI3_IRQHandler, "EXTI Line 3", 25, 0x64);
	}

	/* [0x68] EXTI Line 4 Interrupt */
	void EXTI4_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(EXTI4_IRQHandler, "EXTI Line 4", 26, 0x68);
	}

	/* [0x6C] DMA Channel 1 Interrupt */
	void DMAChannel1_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(DMAChannel1_IRQHandler, "DMA Channel 1", 27, 0x6C);
	}

	/* [0x70] DMA Channel 2 Interrupt */
	void DMAChannel2_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(DMAChannel2_IRQHandler, "DMA Channel 2", 28, 0x70);
	}

	/* [0x74] DMA Channel 3 Interrupt */
	void DMAChannel3_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(DMAChannel3_IRQHandler, "DMA Channel 3", 29, 0x74);
	}

	/* [0x78] DMA Channel 4 Interrupt */
	void DMAChannel4_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(DMAChannel4_IRQHandler, "DMA Channel 4", 30, 0x78);
	}

	/* [0x7C] DMA Channel 5 Interrupt */
	void DMAChannel5_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(DMAChannel5_IRQHandler, "DMA Channel 5", 31, 0x7C);
	}

	/* [0x80] DMA Channel 6 Interrupt */
	void DMAChannel6_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(DMAChannel6_IRQHandler, "DMA Channel 6", 32, 0x80);
	}

	/* [0x84] DMA Channel 7 Interrupt */
	void DMAChannel7_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(DMAChannel7_IRQHandler, "DMA Channel 7", 33, 0x84);
	}

	/* [0x88] ADC Interrupt */
	void ADC_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(ADC_IRQHandler, "ADC", 34, 0x88);
	}

	/* [0x8C] USB High Priority/CAN TX Interrupt */
	void USB_HP_CAN_TX_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(USB_HP_CAN_TX_IRQHandler, "USB High Priority/CAN TX", 35, 0x8C);
	}

	/* [0x90] USB Low Priority/CAN RX0 Interrupt */
	void USB_LP_CAN_RX0_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(USB_LP_CAN_RX0_IRQHandler, "USB Low Priority/CAN RX0", 36, 0x90);
	}

	/* [0x94] CAN RX1 Interrupt */
	void CAN_RX1_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(CAN_RX1_IRQHandler, "CAN RX1", 37, 0x94);
	}

	/* [0x98] CAN SCE Interrupt */
	void CAN_SCE_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(CAN_SCE_IRQHandler, "CAN SCE", 38, 0x98);
	}

	/* [0x9C] EXTI Lines 5-9 Interrupt */
	void EXTI9_5_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(EXTI9_5_IRQHandler, "EXTI Lines 5-9", 39, 0x9C);
	}

	/* [0xA0] TIM1 Break Interrupt */
	void TIM1_BRK_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(TIM1_BRK_IRQHandler, "TIM1 Break", 40, 0xA0);
	}

	/* [0xA4] TIM1 Update Interrupt */
	void TIM1_UP_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(TIM1_UP_IRQHandler, "TIM1 Update", 41, 0xA4);
	}

	/* [0xA8] TIM1 Trigger/Commutation Interrupt */
	void TIM1_TRG_COM_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(TIM1_TRG_COM_IRQHandler, "TIM1 Trigger/Commutation", 42, 0xA8);
	}

	/* [0xAC] TIM1 Capture/Compare Interrupt */
	void TIM1_CC_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(TIM1_CC_IRQHandler, "TIM1 Capture/Compare", 43, 0xAC);
	}

	/* [0xB0] TIM2 Interrupt */
	void TIM2_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(TIM2_IRQHandler, "TIM2", 44, 0xB0);
	}

	/* [0xB4] TIM3 Interrupt */
	void TIM3_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(TIM3_IRQHandler, "TIM3", 45, 0xB4);
	}

	/* [0xB8] TIM4 Interrupt */
	void TIM4_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(TIM4_IRQHandler, "TIM4", 46, 0xB8);
	}

	/* [0xBC] I2C1 Event Interrupt */
	void I2C1_EV_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(I2C1_EV_IRQHandler, "I2C1 Event", 47, 0xBC);
	}

	/* [0xC0] I2C1 Error Interrupt */
	void I2C1_ER_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(I2C1_ER_IRQHandler, "I2C1 Error", 48, 0xC0);
	}

	/* [0xC4] I2C2 Event Interrupt */
	void I2C2_EV_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(I2C2_EV_IRQHandler, "I2C2 Event", 49, 0xC4);
	}

	/* [0xC8] I2C2 Error Interrupt */
	void I2C2_ER_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(I2C2_ER_IRQHandler, "I2C2 Error", 50, 0xC8);
	}

	/* [0xCC] SPI1 Interrupt */
	void SPI1_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(SPI1_IRQHandler, "SPI1", 51, 0xCC);
	}

	/* [0xD0] SPI2 Interrupt */
	void SPI2_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(SPI2_IRQHandler, "SPI2", 52, 0xD0);
	}

	/* [0xD4] USART1 Interrupt */
	void USART1_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(USART1_IRQHandler, "USART1", 53, 0xD4);
	}

	/* [0xD8] USART2 Interrupt */
	void USART2_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(USART2_IRQHandler, "USART2", 54, 0xD8);
	}

	/* [0xDC] USART3 Interrupt */
	void USART3_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(USART3_IRQHandler, "USART3", 55, 0xDC);
	}

	/* [0xE0] EXTI Lines 10-15 Interrupt */
	void EXTI15_10_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(EXTI15_10_IRQHandler, "EXTI Lines 10-15", 56, 0xE0);
	}

	/* [0xE4] RTC Alarm Interrupt (EXTI Line 17) */
    /*
     * Now defined in McuSleepC.nc
	void RTCAlarm_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(RTCAlarm_IRQHandler, "RTC Alarm", 57, 0xE4);
	}
    */

	/* [0xE8] USB Wake Up Interrupt (EXTI Line 18) */
	void USBWakeUp_IRQHandler(void) @spontaneous() @C()
	{
		DEFAULT_EXCEPTION_HANDLER(USBWakeUp_IRQHandler, "USB Wake Up", 58, 0xE8);
	}


    default async event void Irq.fired()
    {
        return;
    }

}
