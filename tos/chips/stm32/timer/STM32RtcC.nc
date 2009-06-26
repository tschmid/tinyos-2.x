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
 * STM32Alarm provides an alarm using the STM32's RTC.
 *
 * @author Thomas Schmid
 */

#include "stm32fwlib.h"

module STM32RtcC @safe()
{
    provides {
        interface Init;
        interface Alarm<TMilli,uint32_t> as Alarm;
        interface Counter<TMilli,uint32_t> as Counter;
        interface LocalTime<TMilli> as LocalTime;
    }
}
implementation
{

    norace uint32_t alarm;
    bool running;

    void enableInterrupt()
    {
        /* Enable the RTC Alarm Interrupt */
        atomic {
            RTC_ITConfig(RTC_IT_ALR, ENABLE);
            RTC_WaitForLastTask();
            running = TRUE;
        }
    }

    void disableInterrupt()
    {
        /* Disable the RTC Alarm Interrupt */
        atomic {
            RTC_ClearITPendingBit(RTC_IT_ALR);
            RTC_WaitForLastTask();
            RTC_ITConfig(RTC_IT_ALR, DISABLE);
            RTC_WaitForLastTask();
            running = FALSE;
        }
    }



    command error_t Init.init()
    {
        NVIC_InitTypeDef NVIC_InitStructure;

        /* Configure one bit for preemption priority */
        NVIC_PriorityGroupConfig(NVIC_PriorityGroup_1);

        /* Enable the RTC Interrupt on the NVIC*/
        NVIC_InitStructure.NVIC_IRQChannel = RTC_IRQChannel;
        NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 1;
        NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
        NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
        NVIC_Init(&NVIC_InitStructure);

        /* Enable PWR and BKP clocks */
        RCC_APB1PeriphClockCmd(RCC_APB1Periph_PWR | RCC_APB1Periph_BKP, ENABLE);

        /* Allow access to BKP Domain */
        PWR_BackupAccessCmd(ENABLE);

        /* Reset Backup Domain */
        BKP_DeInit();

        /* Enable LSE */
        RCC_LSEConfig(RCC_LSE_ON);
        /* Wait till LSE is ready */
        while (RCC_GetFlagStatus(RCC_FLAG_LSERDY) == RESET) {}

        /* Select LSE as RTC Clock Source */
        RCC_RTCCLKConfig(RCC_RTCCLKSource_LSE);

        /* Enable RTC Clock */
        RCC_RTCCLKCmd(ENABLE);

        /* Wait for RTC registers synchronization */
        RTC_WaitForSynchro();

        /* Wait until last write operation on RTC registers has finished */
        RTC_WaitForLastTask();

        /* Set RTC prescaler: set RTC period to 1/1024s */
        RTC_SetPrescaler(31); /* RTC period = RTCCLK/RTC_PR = (32.768 KHz)/(31+1) */

        /* Wait until last write operation on RTC registers has finished */
        RTC_WaitForLastTask();

        /* reset the counter */
        RTC_SetCounter(0x0);

        /* wait till last write has finished */
        RTC_WaitForLastTask();

        /* enable overflow interrupt for counter */
        RTC_ITConfig(RTC_IT_OW, ENABLE);

        /* wait till last write has finished */
        RTC_WaitForLastTask();

        atomic alarm=0;

        return SUCCESS;
    }

    async command void Alarm.start( uint32_t dt )
    {
        call Alarm.startAt( call Alarm.getNow(), dt );
    }

    async command void Alarm.stop()
    {
        disableInterrupt();
    }

    async command bool Alarm.isRunning()
    {
        return running;
    }

    async command void Alarm.startAt( uint32_t t0, uint32_t dt )
    {
        {
            uint32_t now = call Alarm.getNow();
            uint32_t elapsed = now - t0;
            now = RTC_GetCounter();
            if( elapsed >= dt )
            {
                // let the timer expire at the next tic of the RTC!
                RTC_SetAlarm(now+1); 
                atomic alarm = now+1;
                RTC_WaitForLastTask();
            }
            else
            {
                uint32_t remaining = dt - elapsed;
                if( remaining <= 1 )
                {
                    RTC_SetAlarm(now+1); 
                    atomic alarm = now+1;
                    RTC_WaitForLastTask();
                }
                else
                {
                    RTC_SetAlarm(now+remaining); 
                    atomic alarm = now+remaining;
                    RTC_WaitForLastTask();
                }
            }
            enableInterrupt();
        }
    }

    async command uint32_t Alarm.getNow()
    {
        uint32_t c;
        c = RTC_GetCounter();
        return c;
    }

    async command uint32_t Alarm.getAlarm()
    {
        return alarm;
    }

    async command uint32_t Counter.get()
    {
        return call Alarm.getNow();
    }

    async command bool Counter.isOverflowPending()
    {
        return (RTC_GetITStatus(RTC_IT_OW));
    }

    async command void Counter.clearOverflow()
    {
        RTC_ClearITPendingBit(RTC_IT_OW);
        RTC_WaitForLastTask();
    }

    async command uint32_t LocalTime.get() {
        return call Alarm.getNow();
    }


    default async event void Counter.overflow() {
        return;
    }

    /**
     * This is the interrupt handler defined in stm32-vectors.c.
     */
    void RTC_IRQHandler(void) @C() @spontaneous() 
    {
        if (RTC_GetITStatus(RTC_IT_ALR) != RESET)
        {
            // interrupt gets cleared when the timer is stopped in
            // Alarm.stop()
            call Alarm.stop();
            signal Alarm.fired();
        } 
        if (RTC_GetITStatus(RTC_IT_OW) != RESET)
        {
            RTC_ClearITPendingBit(RTC_IT_OW);
            RTC_WaitForLastTask();
            signal Counter.overflow();
        }

    }

}

