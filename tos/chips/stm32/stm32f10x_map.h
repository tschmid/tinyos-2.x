/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __STM32F10x_MAP_H
#define __STM32F10x_MAP_H

/* Includes ------------------------------------------------------------------*/
#include "stm32f10x_conf.h"

/* Exported types ------------------------------------------------------------*/
/******************************************************************************/
/*                          IP registers structures                           */
/******************************************************************************/


/*------------------------ External Interrupt/Event Controller ---------------*/
typedef struct
{
  volatile uint32_t IMR;
  volatile uint32_t EMR;
  volatile uint32_t RTSR;
  volatile uint32_t FTSR;
  volatile uint32_t SWIER;
  volatile uint32_t PR;
} EXTI_TypeDef;

/*------------------------ FLASH and Option Bytes Registers ------------------*/
typedef struct
{
  volatile uint32_t ACR;
  volatile uint32_t KEYR;
  volatile uint32_t OPTKEYR;
  volatile uint32_t SR;
  volatile uint32_t CR;
  volatile uint32_t AR;
  volatile uint32_t RESERVED;
  volatile uint32_t OBR;
  volatile uint32_t WRPR;
} FLASH_TypeDef;

typedef struct
{
  volatile uint16_t RDP;
  volatile uint16_t USER;
  volatile uint16_t Data0;
  volatile uint16_t Data1;
  volatile uint16_t WRP0;
  volatile uint16_t WRP1;
  volatile uint16_t WRP2;
  volatile uint16_t WRP3;
} OB_TypeDef;

/*------------------------ General Purpose and Alternate Function IO ---------*/
typedef struct gpio
{
  volatile uint32_t CRL;
  volatile uint32_t CRH;
  volatile uint32_t IDR;
  volatile uint32_t ODR;
  volatile uint32_t BSRR;
  volatile uint32_t BRR;
  volatile uint32_t LCKR;
} gpio_t;

typedef struct
{
  volatile uint32_t EVCR;
  volatile uint32_t MAPR;
  volatile uint32_t EXTICR[4];
} AFIO_TypeDef;

/*------------------------ Inter-integrated Circuit Interface ----------------*/
typedef struct
{
  volatile uint16_t CR1;
  uint16_t RESERVED0;
  volatile uint16_t CR2;
  uint16_t RESERVED1;
  volatile uint16_t OAR1;
  uint16_t RESERVED2;
  volatile uint16_t OAR2;
  uint16_t RESERVED3;
  volatile uint16_t DR;
  uint16_t RESERVED4;
  volatile uint16_t SR1;
  uint16_t RESERVED5;
  volatile uint16_t SR2;
  uint16_t RESERVED6;
  volatile uint16_t CCR;
  uint16_t RESERVED7;
  volatile uint16_t TRISE;
  uint16_t RESERVED8;
} I2C_TypeDef;

/*------------------------ Independent WATCHDOG ------------------------------*/
typedef struct
{
  volatile uint32_t KR;
  volatile uint32_t PR;
  volatile uint32_t RLR;
  volatile uint32_t SR;
} IWDG_TypeDef;

/*------------------------ Nested Vectored Interrupt Controller --------------*/
typedef struct
{
  volatile uint32_t Enable[2];
  uint32_t RESERVED0[30];
  volatile uint32_t Disable[2];
  uint32_t RSERVED1[30];
  volatile uint32_t Set[2];
  uint32_t RESERVED2[30];
  volatile uint32_t Clear[2];
  uint32_t RESERVED3[30];
  volatile uint32_t Active[2];
  uint32_t RESERVED4[62];
  volatile uint32_t Priority[11];
} NVIC_TypeDef;

typedef struct
{
  volatile uint32_t CPUID;
  volatile uint32_t IRQControlState;
  volatile uint32_t ExceptionTableOffset;
  volatile uint32_t AIRC;
  volatile uint32_t SysCtrl;
  volatile uint32_t ConfigCtrl;
  volatile uint32_t SystemPriority[3];
  volatile uint32_t SysHandlerCtrl;
  volatile uint32_t ConfigFaultStatus;
  volatile uint32_t HardFaultStatus;
  volatile uint32_t DebugFaultStatus;
  volatile uint32_t MemoryManageFaultAddr;
  volatile uint32_t BusFaultAddr;
} SCB_TypeDef;

/*------------------------ Reset and Clock Controller ------------------------*/
typedef struct
{
  volatile uint32_t CR;
  volatile uint32_t CFGR;
  volatile uint32_t CIR;
  volatile uint32_t APB2RSTR;
  volatile uint32_t APB1RSTR;
  volatile uint32_t AHBENR;
  volatile uint32_t APB2ENR;
  volatile uint32_t APB1ENR;
  volatile uint32_t BDCR;
  volatile uint32_t CSR;
} RCC_TypeDef;

/*----------------- Universal Synchronous Asynchronous Receiver Transmitter --*/
typedef struct
{
  volatile uint16_t SR;
  uint16_t RESERVED0;
  volatile uint16_t DR;
  uint16_t RESERVED1;
  volatile uint16_t BRR;
  uint16_t RESERVED2;
  volatile uint16_t CR1;
  uint16_t RESERVED3;
  volatile uint16_t CR2;
  uint16_t RESERVED4;
  volatile uint16_t CR3;
  uint16_t RESERVED5;
  volatile uint16_t GTPR;
  uint16_t RESERVED6;
} USART_TypeDef;

/******************************************************************************/
/*                       Peripheral memory map                                */
/******************************************************************************/
/* Peripheral and SRAM base address in the alias region */
#define PERIPH_BB_BASE        ((uint32_t)0x42000000)
#define SRAM_BB_BASE          ((uint32_t)0x22000000)

/* Peripheral and SRAM base address in the bit-band region */
#define SRAM_BASE             ((uint32_t)0x20000000)
#define PERIPH_BASE           ((uint32_t)0x40000000)

/* Flash refisters base address */
#define FLASH_BASE            ((uint32_t)0x40022000)
/* Flash Option Bytes base address */
#define OB_BASE               ((uint32_t)0x1FFFF800)

/* Peripheral memory map */
#define APB1PERIPH_BASE       PERIPH_BASE
#define APB2PERIPH_BASE       (PERIPH_BASE + 0x10000)
#define AHBPERIPH_BASE        (PERIPH_BASE + 0x20000)

#define TIM2_BASE             (APB1PERIPH_BASE + 0x0000)
#define TIM3_BASE             (APB1PERIPH_BASE + 0x0400)
#define TIM4_BASE             (APB1PERIPH_BASE + 0x0800)
#define RTC_BASE              (APB1PERIPH_BASE + 0x2800)
#define WWDG_BASE             (APB1PERIPH_BASE + 0x2C00)
#define IWDG_BASE             (APB1PERIPH_BASE + 0x3000)
#define SPI2_BASE             (APB1PERIPH_BASE + 0x3800)
#define USART2_BASE           (APB1PERIPH_BASE + 0x4400)
#define USART3_BASE           (APB1PERIPH_BASE + 0x4800)
#define I2C1_BASE             (APB1PERIPH_BASE + 0x5400)
#define I2C2_BASE             (APB1PERIPH_BASE + 0x5800)
#define CAN_BASE              (APB1PERIPH_BASE + 0x6400)
#define BKP_BASE              (APB1PERIPH_BASE + 0x6C00)
#define PWR_BASE              (APB1PERIPH_BASE + 0x7000)

#define AFIO_BASE             (APB2PERIPH_BASE + 0x0000)
#define EXTI_BASE             (APB2PERIPH_BASE + 0x0400)
#define GPIOA_BASE            (APB2PERIPH_BASE + 0x0800)
#define GPIOB_BASE            (APB2PERIPH_BASE + 0x0C00)
#define GPIOC_BASE            (APB2PERIPH_BASE + 0x1000)
#define GPIOD_BASE            (APB2PERIPH_BASE + 0x1400)
#define GPIOE_BASE            (APB2PERIPH_BASE + 0x1800)
#define ADC1_BASE             (APB2PERIPH_BASE + 0x2400)
#define ADC2_BASE             (APB2PERIPH_BASE + 0x2800)
#define TIM1_BASE             (APB2PERIPH_BASE + 0x2C00)
#define SPI1_BASE             (APB2PERIPH_BASE + 0x3000)
#define USART1_BASE           (APB2PERIPH_BASE + 0x3800)

#define DMA_BASE              (AHBPERIPH_BASE + 0x0000)
#define DMA_Channel1_BASE     (AHBPERIPH_BASE + 0x0008)
#define DMA_Channel2_BASE     (AHBPERIPH_BASE + 0x001C)
#define DMA_Channel3_BASE     (AHBPERIPH_BASE + 0x0030)
#define DMA_Channel4_BASE     (AHBPERIPH_BASE + 0x0044)
#define DMA_Channel5_BASE     (AHBPERIPH_BASE + 0x0058)
#define DMA_Channel6_BASE     (AHBPERIPH_BASE + 0x006C)
#define DMA_Channel7_BASE     (AHBPERIPH_BASE + 0x0080)
#define RCC_BASE              (AHBPERIPH_BASE + 0x1000)

/* System Control Space memory map */
#define SCS_BASE              ((uint32_t)0xE000E000)

#define SysTick_BASE          (SCS_BASE + 0x0010)
#define NVIC_BASE             (SCS_BASE + 0x0100)
#define SCB_BASE              (SCS_BASE + 0x0D00)


/******************************************************************************/
/*                            IPs' declaration                                */
/******************************************************************************/

/*------------------- Non Debug Mode -----------------------------------------*/
#ifndef DEBUG

#ifdef _USART2
  #define USART2                ((USART_TypeDef *) USART2_BASE)
#endif /*_USART2 */

#ifdef _USART3
  #define USART3                ((USART_TypeDef *) USART3_BASE)
#endif /*_USART3 */


#ifdef _AFIO
  #define AFIO                  ((AFIO_TypeDef *) AFIO_BASE)
#endif /*_AFIO */

#ifdef _EXTI
  #define EXTI                  ((EXTI_TypeDef *) EXTI_BASE)
#endif /*_EXTI */

#ifdef _GPIOA
  #define GPIOA                 ((gpio_t *) GPIOA_BASE)
#endif /*_GPIOA */

#ifdef _GPIOB
  #define GPIOB                 ((gpio_t *) GPIOB_BASE)
#endif /*_GPIOB */

#ifdef _GPIOC
  #define GPIOC                 ((gpio_t *) GPIOC_BASE)
#endif /*_GPIOC */

#ifdef _GPIOD
  #define GPIOD                 ((gpio_t *) GPIOD_BASE)
#endif /*_GPIOD */

#ifdef _GPIOE
  #define GPIOE                 ((gpio_t *) GPIOE_BASE)
#endif /*_GPIOE */

#ifdef _USART1
  #define USART1                ((USART_TypeDef *) USART1_BASE)
#endif /*_USART1 */

#ifdef _DMA
  #define DMA                   ((DMA_TypeDef *) DMA_BASE)
#endif /*_DMA */


#ifdef _FLASH
  #define FLASH                 ((FLASH_TypeDef *) FLASH_BASE)
  #define OB                    ((OB_TypeDef *) OB_BASE) 
#endif /*_FLASH */

#ifdef _RCC
  #define RCC                   ((RCC_TypeDef *) RCC_BASE)
#endif /*_RCC */

#ifdef _SysTick
  #define SysTick               ((SysTick_TypeDef *) SysTick_BASE)
#endif /*_SysTick */

#ifdef _NVIC
  #define NVIC                  ((NVIC_TypeDef *) NVIC_BASE)
#endif /*_NVIC */

#ifdef _SCB
  #define SCB                   ((SCB_TypeDef *) SCB_BASE)
#endif /*_SCB */
/*----------------------  Debug Mode -----------------------------------------*/
#else   /* DEBUG */

#ifdef _USART2
  EXT USART_TypeDef           *USART2;
#endif /*_USART2 */

#ifdef _USART3
  EXT USART_TypeDef           *USART3;
#endif /*_USART3 */

#ifdef _AFIO
  EXT AFIO_TypeDef            *AFIO;
#endif /*_AFIO */

#ifdef _EXTI
  EXT EXTI_TypeDef            *EXTI;
#endif /*_EXTI */

#ifdef _GPIOA
  EXT gpio_t            *GPIOA;
#endif /*_GPIOA */

#ifdef _GPIOB
  EXT gpio_t            *GPIOB;
#endif /*_GPIOB */

#ifdef _GPIOC
  EXT gpio_t            *GPIOC;
#endif /*_GPIOC */

#ifdef _GPIOD
  EXT gpio_t            *GPIOD;
#endif /*_GPIOD */

#ifdef _GPIOE
  EXT gpio_t            *GPIOE;
#endif /*_GPIOE */

#ifdef _USART1
  EXT USART_TypeDef           *USART1;
#endif /*_USART1 */


#ifdef _FLASH
  EXT FLASH_TypeDef            *FLASH;
  EXT OB_TypeDef               *OB;  
#endif /*_FLASH */

#ifdef _RCC
  EXT RCC_TypeDef             *RCC;
#endif /*_RCC */

#ifdef _SysTick
  EXT SysTick_TypeDef         *SysTick;
#endif /*_SysTick */

#ifdef _NVIC
  EXT NVIC_TypeDef            *NVIC;
#endif /*_NVIC */

#ifdef _SCB
  EXT SCB_TypeDef             *SCB;
#endif /*_SCB */

#endif  /* DEBUG */

/* Exported constants --------------------------------------------------------*/
/* Exported macro ------------------------------------------------------------*/
/* Exported functions ------------------------------------------------------- */

#endif /* __STM32F10x_MAP_H */

/******************* (C) COPYRIGHT 2007 STMicroelectronics *****END OF FILE****/
