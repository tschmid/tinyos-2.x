#ifndef SAM3UNVIC_H
#define SAM3UNVIC_H

#ifndef __NVIC_PRIO_BITS
  #define __NVIC_PRIO_BITS    4               /*!< standard definition for NVIC Priority Bits */
#endif

#define NVIC_AIRCR_VECTKEY    (0x5FA << 16)   /*!< AIRCR Key for write access   */

/**
 *  * IO definitions
 *   *
 *    * define access restrictions to peripheral registers
 *     */

#define     __I     volatile const            /*!< defines 'read only' permissions      */
#define     __O     volatile                  /*!< defines 'write only' permissions     */
#define     __IO    volatile                  /*!< defines 'read / write' permissions   */


/* memory mapping struct for Nested Vectored Interrupt Controller (NVIC) */
typedef struct
{
  __IO uint32_t ISER[8];                      /*!< Interrupt Set Enable Register            */
       uint32_t RESERVED0[24];
  __IO uint32_t ICER[8];                      /*!< Interrupt Clear Enable Register          */
       uint32_t RSERVED1[24];
  __IO uint32_t ISPR[8];                      /*!< Interrupt Set Pending Register           */
       uint32_t RESERVED2[24];
  __IO uint32_t ICPR[8];                      /*!< Interrupt Clear Pending Register         */
       uint32_t RESERVED3[24];
  __IO uint32_t IABR[8];                      /*!< Interrupt Active bit Register            */
       uint32_t RESERVED4[56];
  __IO uint8_t  IP[240];                      /*!< Interrupt Priority Register, 8Bit wide   */
       uint32_t RESERVED5[644];
  __O  uint32_t STIR;                         /*!< Software Trigger Interrupt Register      */
}  nvic_t;

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
    __IO uint32_t SHCSR;                        /*!< System Handler Control and State Register                */
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
#define SCS_BASE            (0xE000E000)                  /*!< System Control Space Base Address    */
#define NVIC_BASE           (SCS_BASE +  0x0100)          /*!< NVIC Base Address                    */
#define SCB_BASE            (SCS_BASE +  0x0D00)          /*!< System Control Block Base Address    */

#define NVIC                ((nvic_t *) NVIC_BASE)        /*!< NVIC configuration struct            */
#define SCB                 ((scb_t*)   SCB_BASE)         /*!< SCB configuration struct             */

// *****************************************************************************
//               PERIPHERAL ID DEFINITIONS FOR AT91SAM3U4
// *****************************************************************************
#define AT91C_ID_SUPC   ( 0) // SUPPLY CONTROLLER
#define AT91C_ID_RSTC   ( 1) // RESET CONTROLLER
#define AT91C_ID_RTC    ( 2) // REAL TIME CLOCK
#define AT91C_ID_RTT    ( 3) // REAL TIME TIMER
#define AT91C_ID_WDG    ( 4) // WATCHDOG TIMER
#define AT91C_ID_PMC    ( 5) // PMC
#define AT91C_ID_EFC0   ( 6) // EFC0
#define AT91C_ID_EFC1   ( 7) // EFC1
#define AT91C_ID_DBGU   ( 8) // DBGU
#define AT91C_ID_HSMC4  ( 9) // HSMC4
#define AT91C_ID_PIOA   (10) // Parallel IO Controller A
#define AT91C_ID_PIOB   (11) // Parallel IO Controller B
#define AT91C_ID_PIOC   (12) // Parallel IO Controller C
#define AT91C_ID_US0    (13) // USART 0
#define AT91C_ID_US1    (14) // USART 1
#define AT91C_ID_US2    (15) // USART 2
#define AT91C_ID_US3    (16) // USART 3
#define AT91C_ID_MCI0   (17) // Multimedia Card Interface
#define AT91C_ID_TWI0   (18) // TWI 0
#define AT91C_ID_TWI1   (19) // TWI 1
#define AT91C_ID_SPI0   (20) // Serial Peripheral Interface
#define AT91C_ID_SSC0   (21) // Serial Synchronous Controller 0
#define AT91C_ID_TC0    (22) // Timer Counter 0
#define AT91C_ID_TC1    (23) // Timer Counter 1
#define AT91C_ID_TC2    (24) // Timer Counter 2
#define AT91C_ID_PWMC   (25) // Pulse Width Modulation Controller
#define AT91C_ID_ADC12B (26) // 12-bit ADC Controller (ADC12B)
#define AT91C_ID_ADC    (27) // 10-bit ADC Controller (ADC)
#define AT91C_ID_HDMA   (28) // HDMA
#define AT91C_ID_UDPHS  (29) // USB Device High Speed
#define AT91C_ALL_INT   (0x3FFFFFFF) // ALL VALID INTERRUPTS


/// Interrupt source
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

#endif // SAM3UNVIC
