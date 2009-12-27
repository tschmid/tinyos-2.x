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
 * Header definition for the Nested Vector Interrupt Controller.
 *
 * @author Thomas Schmid
 * @author Wanja Hofer <wanja@cs.fau.de>
 */

#ifndef SAM3UNVICHARDWARE_H
#define SAM3UNVICHARDWARE_H

#include "sam3uhardware.h"

#define __NVIC_PRIO_BITS    4               /*!< standard definition for NVIC Priority Bits */

#define NVIC_AIRCR_VECTKEY    (0x5FA << 16)   /*!< AIRCR Key for write access   */

/**
 *  IO definitions
 * 
 * define access restrictions to peripheral registers
 **/

#define     __I     volatile const            /*!< defines 'read only' permissions      */
#define     __O     volatile                  /*!< defines 'write only' permissions     */
#define     __IO    volatile                  /*!< defines 'read / write' permissions   */


/* memory mapping struct for Nested Vectored Interrupt Controller (NVIC) */
typedef struct
{
  volatile uint32_t iser0;              // Interrupt Set Enable
           uint32_t reserved[31];
  volatile uint32_t icer0;              // Interrupt Clear-enable
           uint32_t reserved1[31];
  volatile uint32_t ispr0;              // Interrupt Set-pending
           uint32_t reserved2[31];
  volatile uint32_t icpr0;              // Interrupt Clear-pending
           uint32_t reserved3[31];
  volatile uint32_t iabr0;              // Interrupt Active Bit
           uint32_t reserved4[63];
  volatile uint8_t  ip[32];             // Interrupt Priority Registers
           uint32_t reserved5[696];
  volatile uint32_t stir;               // Software Trigger Interrupt
}  nvic_t;

typedef union
{
	uint32_t flat;
	struct
	{
		uint8_t		memfaultact:	1;
		uint8_t		busfaultact:	1;
		uint8_t		reserved0:		1;
		uint8_t		usgfaultact:	1;
		uint8_t		reserved1:		3;
		uint8_t		svcallact:		1;
		uint8_t		monitoract:		1;
		uint8_t		reserved2:		1;
		uint8_t		pendsvact:		1;
		uint8_t		systickact:		1;
		uint8_t		usgfaultpended:	1;
		uint8_t		memfaultpended:	1;
		uint8_t		busfaultpended:	1;
		uint8_t		svcallpended:	1;
		uint8_t		memfaultena:	1;
		uint8_t		busfaultena:	1;
		uint8_t		usgfaultena:	1;
		uint16_t	reserved3:		13;
	} bits;
} nvic_shcsr_t;

/* memory mapping struct for System Control Block */
typedef struct
{
    __I  uint32_t CPUID;                        /*!< CPU ID Base Register                                     */
    __IO uint32_t ICSR;                         /*!< Interrupt Control State Register                         */
    __IO uint32_t VTOR;                         /*!< Vector Table Offset Register                             */
    __IO uint32_t AIRCR;                        /*!< Application Interrupt / Reset Control Register           */
    __IO uint32_t SCR;                          /*!< System Control Register                                  */
    __IO uint32_t CCR;                          /*!< Configuration Control Register                           */
    __IO uint8_t  SHP[12];                      /*!< System Handlers Priority Registers (4-7, 8-11, 12-15)    */
    __IO nvic_shcsr_t SHCSR;                    /*!< System Handler Control and State Register                */
    __IO uint32_t CFSR;                         /*!< Configurable Fault Status Register                       */
    __IO uint32_t HFSR;                         /*!< Hard Fault Status Register                               */
    __IO uint32_t DFSR;                         /*!< Debug Fault Status Register                              */
    __IO uint32_t MMFAR;                        /*!< Mem Manage Address Register                              */
    __IO uint32_t BFAR;                         /*!< Bus Fault Address Register                               */
    __IO uint32_t AFSR;                         /*!< Auxiliary Fault Status Register                          */
    __I  uint32_t PFR[2];                       /*!< Processor Feature Register                               */
    __I  uint32_t DFR;                          /*!< Debug Feature Register                                   */
    __I  uint32_t ADR;                          /*!< Auxiliary Feature Register                               */
    __I  uint32_t MMFR[4];                      /*!< Memory Model Feature Register                            */
    __I  uint32_t ISAR[5];                      /*!< ISA Feature Register                                     */
} scb_t;


/* Memory mapping of Cortex-M3 Hardware */
volatile nvic_t* NVIC = (volatile nvic_t *) 0xE000E100; // NVIC Base Address

#define SCS_BASE            (0xE000E000)                  /*!< System Control Space Base Address    */
#define SCB_BASE            (SCS_BASE +  0x0D00)          /*!< System Control Block Base Address    */

#define SCB                 ((scb_t*)   SCB_BASE)         /*!< SCB configuration struct             */

/// Interrupt sources
typedef enum irqn
{
/******  Cortex-M3 Processor Exceptions Numbers ***************************************************/
  NonMaskableInt_IRQn         = -14,    /*!< 2 Non Maskable Interrupt                             */
  MemoryManagement_IRQn       = -12,    /*!< 4 Cortex-M3 Memory Management Interrupt              */
  BusFault_IRQn               = -11,    /*!< 5 Cortex-M3 Bus Fault Interrupt                      */
  UsageFault_IRQn             = -10,    /*!< 6 Cortex-M3 Usage Fault Interrupt                    */
  SVCall_IRQn                 = -5,     /*!< 11 Cortex-M3 SV Call Interrupt                       */
  DebugMonitor_IRQn           = -4,     /*!< 12 Cortex-M3 Debug Monitor Interrupt                 */
  PendSV_IRQn                 = -2,     /*!< 14 Cortex-M3 Pend SV Interrupt                       */
  SysTick_IRQn                = -1,     /*!< 15 Cortex-M3 System Tick Interrupt                   */

/******  AT91SAM3U4 specific Interrupt Numbers *********************************************************/
 IROn_SUPC                = AT91C_ID_SUPC , // SUPPLY CONTROLLER
 IROn_RSTC                = AT91C_ID_RSTC , // RESET CONTROLLER
 IROn_RTC                 = AT91C_ID_RTC  , // REAL TIME CLOCK
 IROn_RTT                 = AT91C_ID_RTT  , // REAL TIME TIMER
 IROn_WDG                 = AT91C_ID_WDG  , // WATCHDOG TIMER
 IROn_PMC                 = AT91C_ID_PMC  , // PMC
 IROn_EFC0                = AT91C_ID_EFC0 , // EFC0
 IROn_EFC1                = AT91C_ID_EFC1 , // EFC1
 IROn_DBGU                = AT91C_ID_DBGU , // DBGU
 IROn_HSMC4               = AT91C_ID_HSMC4, // HSMC4
 IROn_PIOA                = AT91C_ID_PIOA , // Parallel IO Controller A
 IROn_PIOB                = AT91C_ID_PIOB , // Parallel IO Controller B
 IROn_PIOC                = AT91C_ID_PIOC , // Parallel IO Controller C
 IROn_US0                 = AT91C_ID_US0  , // USART 0
 IROn_US1                 = AT91C_ID_US1  , // USART 1
 IROn_US2                 = AT91C_ID_US2  , // USART 2
 IROn_US3                 = AT91C_ID_US3  , // USART 3
 IROn_MCI0                = AT91C_ID_MCI0 , // Multimedia Card Interface
 IROn_TWI0                = AT91C_ID_TWI0 , // TWI 0
 IROn_TWI1                = AT91C_ID_TWI1 , // TWI 1
 IROn_SPI0                = AT91C_ID_SPI0 , // Serial Peripheral Interface
 IROn_SSC0                = AT91C_ID_SSC0 , // Serial Synchronous Controller 0
 IROn_TC0                 = AT91C_ID_TC0  , // Timer Counter 0
 IROn_TC1                 = AT91C_ID_TC1  , // Timer Counter 1
 IROn_TC2                 = AT91C_ID_TC2  , // Timer Counter 2
 IROn_PWMC                = AT91C_ID_PWMC , // Pulse Width Modulation Controller
 IROn_ADCC0               = AT91C_ID_ADC12B, // ADC controller0
 IROn_ADCC1               = AT91C_ID_ADC, // ADC controller1
 IROn_HDMA                = AT91C_ID_HDMA , // HDMA
 IROn_UDPHS               = AT91C_ID_UDPHS // USB Device High Speed
} irqn_t;

#endif // SAM3UNVICHARDWARE_H
