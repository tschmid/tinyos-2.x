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
 * Implementation of TEP 112 (Microcontroller Power Management) for
 * the STM32
 *
 * @author Thomas Schmid
 *
 */

module McuSleepC {
  provides {
    interface McuSleep;
    interface McuPowerState;
    interface Init as McuSleepInit;
  }
  uses {
    interface McuPowerOverride;
    interface Init as MoteClockInit;
  }
}
implementation {

    command error_t McuSleepInit.init() {
        EXTI_InitTypeDef EXTI_InitStructure;
        NVIC_InitTypeDef NVIC_InitStructure;


        //Configure EXTI Line17(RTC Alarm) to generate an interrupt on
        //rising edge
        EXTI_ClearITPendingBit(EXTI_Line17);
        EXTI_InitStructure.EXTI_Line = EXTI_Line17;
        EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Rising;
        EXTI_Init(&EXTI_InitStructure);

        // enable the EXTI RTCAlarm IRQ to wakeup the MCU
        NVIC_InitStructure.NVIC_IRQChannel = RTCAlarm_IRQChannel;
        NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
        NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
        NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
        NVIC_Init(&NVIC_InitStructure);

        return SUCCESS;
    }
  
  async command void McuSleep.sleep() {
      /*
       * Some notes ont he power management:
       * - Turning off the high frequency clocks and PLL saves a lot of energy
       *   during sleep. However, switching back the MCU to these clocks will
       *   take about 400us. Thus, it will be an interesting challange to get
       *   the right power management system done
       * - It would be interesting to get the power numbers and wakeup/sleep
       *   times for the different combinations of clocks. We could then
       *   obtimize for the right behavior, given an estimate of the time and
       *   work that we have to accomplish.
       */



      //*PERIPHERAL_BIT(GPIOC->ODR, 9) = 1;

      // slow down the clocks...
      //RCC_PCLK2Config(RCC_HCLK_Div16);
      //RCC_PCLK1Config(RCC_HCLK_Div16);
      
      // disable peripheral clocks
      RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO | RCC_APB2Periph_GPIOA, DISABLE);
      RCC_AHBPeriphClockCmd(RCC_AHBPeriph_FLITF | RCC_AHBPeriph_SRAM, DISABLE);

      // clock the system from internal RC
      RCC_HSICmd(ENABLE);
      // wait until the HSI is ready
      while(RCC_GetFlagStatus(RCC_FLAG_HSIRDY) == RESET);
      RCC_SYSCLKConfig(RCC_SYSCLKSource_HSI);
      // shut down the PLL
      RCC_PLLCmd(DISABLE);
      // shut down the external Oscillator
      RCC_HSEConfig(RCC_HSE_OFF);
      // FIXME: increasing this further above 64 somehow introduces
      // instabilities, and the MCU might not come back from sleep!
      RCC_HCLKConfig(RCC_SYSCLK_Div64);



      //*PERIPHERAL_BIT(GPIOC->ODR, 8) = 0;
      // for now, we just put the MCU into SLEEP mode. More sophisticated
      // things later...
      __WFI(); // wait for interrupt

      //*PERIPHERAL_BIT(GPIOC->ODR, 8) = 1;

      // Do A STOP command for even lower power. However, we can only wake up
      // from the EXTI interrupts (external io or RTC Alarm).
      // FIXME: This is not working yet...
      //PWR_EnterSTOPMode(PWR_Regulator_LowPower, PWR_STOPEntry_WFI);


      // If we get here, the system resumed!


      // reinitialize the clocks
      // 1. Reinitialize the SYSCLK
      RCC_HCLKConfig(RCC_SYSCLK_Div1);
      // 2. Enable ext. high frequency OSC
      RCC_HSEConfig(RCC_HSE_ON);

      // wait until the HSE is ready
      while(RCC_GetFlagStatus(RCC_FLAG_HSERDY) == RESET);

      // 3. Init PLL
      RCC_PLLConfig(RCC_PLLSource_HSE_Div1,RCC_PLLMul_9); // 72MHz

      //  RCC_PLLConfig(RCC_PLLSource_HSE_Div2,RCC_PLLMul_9); // 36MHz
      RCC_PLLCmd(ENABLE);

      // wait until the PLL is ready
      while(RCC_GetFlagStatus(RCC_FLAG_PLLRDY) == RESET);
      RCC_SYSCLKConfig(RCC_SYSCLKSource_PLLCLK);

      RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO | RCC_APB2Periph_GPIOC | RCC_APB2Periph_GPIOA, ENABLE);
      RCC_AHBPeriphClockCmd(RCC_AHBPeriph_FLITF | RCC_AHBPeriph_SRAM, ENABLE);

      //*PERIPHERAL_BIT(GPIOC->ODR, 9) = 0;

      return;
  }

  async command void McuPowerState.update() {

    return;
  }

 default async command mcu_power_t McuPowerOverride.lowestState() {
   return 0;
 }

 /* this is the interrupt that gets thrown through the EXTI line when the
  * system wakes up from an RTC Alarm.
  */
 void RTCAlarm_IRQHandler(void) @spontaneous() @C()
 {
     if(RTC_GetITStatus(RTC_IT_ALR) != RESET)
     {
         /* Clear EXTI line17 pending bit */
         EXTI_ClearITPendingBit(EXTI_Line17);

         /* Check if the Wake-Up flag is set */
         if(PWR_GetFlagStatus(PWR_FLAG_WU) != RESET)
         {
             /* Clear Wake Up flag */
             PWR_ClearFlag(PWR_FLAG_WU);
         }
     }
     RTC_IRQHandler();
 }

}
