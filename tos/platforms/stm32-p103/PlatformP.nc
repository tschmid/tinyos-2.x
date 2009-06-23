/*
 * Copyright (c) 2009 University of California, Los Angeles 
 * All rights reserved. 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *	Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *	Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 */
/**
 * @author Thomas Schmid
 */

#include "hardware.h"
#include "stm32f10x_rcc.h"

module PlatformP {
    provides {
        interface Init;
        interface PlatformReset;
    }
    uses {
        interface Init as MoteInit;
        interface HplSTM32Interrupt as Interrupt;
    }
}
implementation {

/*************************************************************************
 * Function Name: Clk_Init
 * Parameters: Int32U Frequency
 * Return: Int32U
 *
 * Description: Init clock system
 *
 *************************************************************************/

void Clk_Init (void)
{
    // 1. Cloking the controller from internal HSI RC (8 MHz)
    RCC_HSICmd(ENABLE);
    // wait until the HSI is ready
    while(RCC_GetFlagStatus(RCC_FLAG_HSIRDY) == RESET);
    RCC_SYSCLKConfig(RCC_SYSCLKSource_HSI);
    // 2. Enable ext. high frequency OSC
    RCC_HSEConfig(RCC_HSE_ON);
    // wait until the HSE is ready
    while(RCC_GetFlagStatus(RCC_FLAG_HSERDY) == RESET);
    // 3. Init PLL
    RCC_PLLConfig(RCC_PLLSource_HSE_Div1,RCC_PLLMul_9); // 72MHz
    //  RCC_PLLConfig(RCC_PLLSource_HSE_Div2,RCC_PLLMul_9); // 72MHz
    RCC_PLLCmd(ENABLE);
    // wait until the PLL is ready
    while(RCC_GetFlagStatus(RCC_FLAG_PLLRDY) == RESET);
    // 4. Set system clock divders
    RCC_USBCLKConfig(RCC_USBCLKSource_PLLCLK_1Div5);
    RCC_ADCCLKConfig(RCC_PCLK2_Div8);
    RCC_PCLK2Config(RCC_HCLK_Div1);
    RCC_PCLK1Config(RCC_HCLK_Div2);
    RCC_HCLKConfig(RCC_SYSCLK_Div1);
    // Flash 1 wait state 
    *(volatile uint32_t *)0x40022000 = 0x12;
    // 5. Clock system from PLL
    RCC_SYSCLKConfig(RCC_SYSCLKSource_PLLCLK);
}


    command error_t Init.init() {
        *NVIC_CCR = *NVIC_CCR | 0x200; /* Set STKALIGN in NVIC */
        // Init clock system
        Clk_Init();

        RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO, ENABLE);
        RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC | RCC_APB2Periph_GPIOA, ENABLE);

        return SUCCESS;
    }

    async command void PlatformReset.reset() {
        while (1);
        return; // Should never get here.
    }

    void nmi_handler(void)
    {
        while(1) {};
        return ;
    }

    void hardfault_handler(void)
    {
        while(1) {};
        return ;
    }

    //Functions definitions
    void myDelay(unsigned long delay )
    {
        while(delay) delay--;
    }

    async event void Interrupt.fired(void)
{

}

}

