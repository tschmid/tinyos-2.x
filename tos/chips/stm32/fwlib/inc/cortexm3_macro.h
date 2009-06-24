/******************** (C) COPYRIGHT 2007 STMicroelectronics ********************
* File Name          : cortexm3_macro.h
* Author             : MCD Application Team
* Version            : V1.0
* Date               : 10/08/2007
* Description        : Header file for cortexm3_macro.s.
********************************************************************************
* THE PRESENT SOFTWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
* WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE TIME.
* AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY DIRECT,
* INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING FROM THE
* CONTENT OF SUCH SOFTWARE AND/OR THE USE MADE BY CUSTOMERS OF THE CODING
* INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
*******************************************************************************/

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __CORTEXM3_MACRO_H
#define __CORTEXM3_MACRO_H

/* Includes ------------------------------------------------------------------*/
#include "stm32f10x_type.h"

/* Exported types ------------------------------------------------------------*/
/* Exported constants --------------------------------------------------------*/
/* Exported macro ------------------------------------------------------------*/
/* Exported functions ------------------------------------------------------- */
void __WFI(void);
void __WFE(void);
void __SEV(void);
void __ISB(void);
void __DSB(void);
void __DMB(void);
void __SVC(void);
uint32_t __MRS_CONTROL(void);
void __MSR_CONTROL(uint32_t Control);
uint32_t __MRS_PSP(void);
void __MSR_PSP(uint32_t TopOfProcessStack);
uint32_t __MRS_MSP(void);
void __MSR_MSP(uint32_t TopOfMainStack);
void __SETPRIMASK(void);
void __RESETPRIMASK(void);
void __SETFAULTMASK(void);
void __RESETFAULTMASK(void);
void __BASEPRICONFIG(uint32_t NewPriority);
uint32_t __GetBASEPRI(void);
uint16_t __REV_HalfWord(uint16_t Data);
uint32_t __REV_Word(uint32_t Data);

#endif /* __CORTEXM3_MACRO_H */

/******************* (C) COPYRIGHT 2007 STMicroelectronics *****END OF FILE****/
