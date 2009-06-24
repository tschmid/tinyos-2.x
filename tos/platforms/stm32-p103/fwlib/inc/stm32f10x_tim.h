/******************** (C) COPYRIGHT 2007 STMicroelectronics ********************
* File Name          : stm32f10x_tim.h
* Author             : MCD Application Team
* Version            : V1.0
* Date               : 10/08/2007
* Description        : This file contains all the functions prototypes for the 
*                      TIM firmware library.
********************************************************************************
* THE PRESENT SOFTWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
* WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE TIME.
* AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY DIRECT,
* INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING FROM THE
* CONTENT OF SUCH SOFTWARE AND/OR THE USE MADE BY CUSTOMERS OF THE CODING
* INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
*******************************************************************************/

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __STM32F10x_TIM_H
#define __STM32F10x_TIM_H

/* Includes ------------------------------------------------------------------*/
#include "stm32f10x_map.h"

/* Exported types ------------------------------------------------------------*/

/* TIM Base Init structure definition */
typedef struct
{
  uint16_t TIM_Period;          /* Period value */
  uint16_t TIM_Prescaler;       /* Prescaler value */
  uint16_t TIM_ClockDivision;   /* Timer clock division */
  uint16_t TIM_CounterMode;     /* Timer Counter mode */
} TIM_TimeBaseInitTypeDef;

/* TIM Output Compare Init structure definition */
typedef struct
{
  uint16_t TIM_OCMode;          /* Timer Output Compare Mode */
  uint16_t TIM_Channel;          /* Timer Channel */
  uint16_t TIM_Pulse;           /* PWM or OC Channel pulse length */
  uint16_t TIM_OCPolarity;       /* PWM, OCM or OPM Channel polarity */
} TIM_OCInitTypeDef;

/* TIM Input Capture Init structure definition */
typedef struct
{
  uint16_t TIM_ICMode;            /* Timer Input Capture Mode */
  uint16_t TIM_Channel;           /* Timer Channel */
  uint16_t TIM_ICPolarity;        /* Input Capture polarity */ 
  uint16_t TIM_ICSelection;       /* Input Capture selection */
  uint16_t TIM_ICPrescaler;       /* Input Capture prescaler */
  uint8_t TIM_ICFilter;          /* Input Capture filter */
} TIM_ICInitTypeDef;

/* Exported constants -------------------------------------------------------*/
/* TIM Ouput Compare modes --------------------------------------------------*/
#define TIM_OCMode_Timing                 ((uint16_t)0x0000)
#define TIM_OCMode_Active                 ((uint16_t)0x0010)
#define TIM_OCMode_Inactive               ((uint16_t)0x0020)
#define TIM_OCMode_Toggle                 ((uint16_t)0x0030)
#define TIM_OCMode_PWM1                   ((uint16_t)0x0060)
#define TIM_OCMode_PWM2                   ((uint16_t)0x0070)

#define IS_TIM_OC_MODE(MODE) ((MODE == TIM_OCMode_Timing) || \
                              (MODE == TIM_OCMode_Active) || \
                              (MODE == TIM_OCMode_Inactive) || \
                              (MODE == TIM_OCMode_Toggle)|| \
                              (MODE == TIM_OCMode_PWM1) || \
                              (MODE == TIM_OCMode_PWM2))

/* TIM Input Capture modes --------------------------------------------------*/
#define TIM_ICMode_ICAP                   ((uint16_t)0x0007)
#define TIM_ICMode_PWMI                   ((uint16_t)0x0006)

#define IS_TIM_IC_MODE(MODE) ((MODE == TIM_ICMode_ICAP) || \
                              (MODE == TIM_ICMode_PWMI))

/* TIM One Pulse Mode -------------------------------------------------------*/
#define TIM_OPMode_Single                 ((uint16_t)0x0008)
#define TIM_OPMode_Repetitive             ((uint16_t)0x0000)

#define IS_TIM_OPM_MODE(MODE) ((MODE == TIM_OPMode_Single) || \
                               (MODE == TIM_OPMode_Repetitive))
                             
/* TIM Channel --------------------------------------------------------------*/
#define TIM_Channel_1                     ((uint16_t)0x0000)
#define TIM_Channel_2                     ((uint16_t)0x0001)
#define TIM_Channel_3                     ((uint16_t)0x0002)
#define TIM_Channel_4                     ((uint16_t)0x0003)

#define IS_TIM_CHANNEL(CHANNEL) ((CHANNEL == TIM_Channel_1) || \
                                 (CHANNEL == TIM_Channel_2) || \
                                 (CHANNEL == TIM_Channel_3) || \
                                 (CHANNEL == TIM_Channel_4))

/* TIM Clock Division CKD ---------------------------------------------------*/
#define TIM_CKD_DIV1                      ((uint16_t)0x0000)
#define TIM_CKD_DIV2                      ((uint16_t)0x0100)
#define TIM_CKD_DIV4                      ((uint16_t)0x0200)

#define IS_TIM_CKD_DIV(DIV) ((DIV == TIM_CKD_DIV1) || \
                             (DIV == TIM_CKD_DIV2) || \
                             (DIV == TIM_CKD_DIV4))

/* TIM Counter Mode ---------------------------------------------------------*/
#define TIM_CounterMode_Up                ((uint16_t)0x0000)
#define TIM_CounterMode_Down              ((uint16_t)0x0010)
#define TIM_CounterMode_CenterAligned1    ((uint16_t)0x0020)
#define TIM_CounterMode_CenterAligned2    ((uint16_t)0x0040)
#define TIM_CounterMode_CenterAligned3    ((uint16_t)0x0060)

#define IS_TIM_COUNTER_MODE(MODE) ((MODE == TIM_CounterMode_Up) ||  \
                                   (MODE == TIM_CounterMode_Down) || \
                                   (MODE == TIM_CounterMode_CenterAligned1) || \
                                   (MODE == TIM_CounterMode_CenterAligned2) || \
                                   (MODE == TIM_CounterMode_CenterAligned3))

/* TIM Output Compare Polarity ----------------------------------------------*/
#define TIM_OCPolarity_High               ((uint16_t)0x0000)
#define TIM_OCPolarity_Low                ((uint16_t)0x0002)

#define IS_TIM_OC_POLARITY(POLARITY) ((POLARITY == TIM_OCPolarity_High) || \
                                     (POLARITY == TIM_OCPolarity_Low))

/* TIM Input Capture Polarity -----------------------------------------------*/
#define  TIM_ICPolarity_Rising            ((uint16_t)0x0000)
#define  TIM_ICPolarity_Falling           ((uint16_t)0x0002)

#define IS_TIM_IC_POLARITY(POLARITY) ((POLARITY == TIM_ICPolarity_Rising) || \
                                     (POLARITY == TIM_ICPolarity_Falling))

/* TIM Input Capture Channel  Selection -------------------------------------*/
#define TIM_ICSelection_DirectTI          ((uint16_t)0x0001)
#define TIM_ICSelection_IndirectTI        ((uint16_t)0x0002)
#define TIM_ICSelection_TRC               ((uint16_t)0x0003)

#define IS_TIM_IC_SELECTION(SELECTION) ((SELECTION == TIM_ICSelection_DirectTI) || \
                                       (SELECTION == TIM_ICSelection_IndirectTI) || \
                                       (SELECTION == TIM_ICSelection_TRC))

/* TIM Input Capture Prescaler ----------------------------------------------*/
#define TIM_ICPSC_DIV1                    ((uint16_t)0x0000)
#define TIM_ICPSC_DIV2                    ((uint16_t)0x0004)
#define TIM_ICPSC_DIV4                    ((uint16_t)0x0008)
#define TIM_ICPSC_DIV8                    ((uint16_t)0x000C)

#define IS_TIM_IC_PRESCALER(PRESCALER) ((PRESCALER == TIM_ICPSC_DIV1) || \
                                       (PRESCALER == TIM_ICPSC_DIV2) || \
                                       (PRESCALER == TIM_ICPSC_DIV4) || \
                                       (PRESCALER == TIM_ICPSC_DIV8))

/* TIM Input Capture Filer Value ---------------------------------------------*/
#define IS_TIM_IC_FILTER(ICFILTER) (ICFILTER <= 0xF)                                      

/* TIM interrupt sources ----------------------------------------------------*/
#define TIM_IT_Update                     ((uint16_t)0x0001)
#define TIM_IT_CC1                        ((uint16_t)0x0002)
#define TIM_IT_CC2                        ((uint16_t)0x0004)
#define TIM_IT_CC3                        ((uint16_t)0x0008)
#define TIM_IT_CC4                        ((uint16_t)0x0010)
#define TIM_IT_Trigger                    ((uint16_t)0x0040)

#define IS_TIM_IT(IT) (((IT & (uint16_t)0xFFA0) == 0x0000) && (IT != 0x0000))

#define IS_TIM_GET_IT(IT) ((IT == TIM_IT_Update) || \
                           (IT == TIM_IT_CC1) || \
                           (IT == TIM_IT_CC2) || \
                           (IT == TIM_IT_CC3) || \
                           (IT == TIM_IT_CC4) || \
                           (IT == TIM_IT_Trigger))

/* TIM DMA Base address -----------------------------------------------------*/
#define TIM_DMABase_CR1                   ((uint16_t)0x0000)
#define TIM_DMABase_CR2                   ((uint16_t)0x0001)
#define TIM_DMABase_SMCR                  ((uint16_t)0x0002)
#define TIM_DMABase_DIER                  ((uint16_t)0x0003)
#define TIM_DMABase_SR                    ((uint16_t)0x0004)
#define TIM_DMABase_EGR                   ((uint16_t)0x0005)
#define TIM_DMABase_CCMR1                 ((uint16_t)0x0006)
#define TIM_DMABase_CCMR2                 ((uint16_t)0x0007)
#define TIM_DMABase_CCER                  ((uint16_t)0x0008)
#define TIM_DMABase_CNT                   ((uint16_t)0x0009)
#define TIM_DMABase_PSC                   ((uint16_t)0x000A)
#define TIM_DMABase_ARR                   ((uint16_t)0x000B)
#define TIM_DMABase_CCR1                  ((uint16_t)0x000D)
#define TIM_DMABase_CCR2                  ((uint16_t)0x000E)
#define TIM_DMABase_CCR3                  ((uint16_t)0x000F)
#define TIM_DMABase_CCR4                  ((uint16_t)0x0010)
#define TIM_DMABase_DCR                   ((uint16_t)0x0012)

#define IS_TIM_DMA_BASE(BASE) ((BASE == TIM_DMABase_CR1) || \
                               (BASE == TIM_DMABase_CR2) || \
                               (BASE == TIM_DMABase_SMCR) || \
                               (BASE == TIM_DMABase_DIER) || \
                               (BASE == TIM_DMABase_SR) || \
                               (BASE == TIM_DMABase_EGR) || \
                               (BASE == TIM_DMABase_CCMR1) || \
                               (BASE == TIM_DMABase_CCMR2) || \
                               (BASE == TIM_DMABase_CCER) || \
                               (BASE == TIM_DMABase_CNT) || \
                               (BASE == TIM_DMABase_PSC) || \
                               (BASE == TIM_DMABase_ARR) || \
                               (BASE == TIM_DMABase_CCR1) || \
                               (BASE == TIM_DMABase_CCR2) || \
                               (BASE == TIM_DMABase_CCR3) || \
                               (BASE == TIM_DMABase_CCR4) || \
                               (BASE == TIM_DMABase_DCR))

/* TIM DMA Burst Length -----------------------------------------------------*/
#define TIM_DMABurstLength_1Byte          ((uint16_t)0x0000)
#define TIM_DMABurstLength_2Bytes         ((uint16_t)0x0100)
#define TIM_DMABurstLength_3Bytes         ((uint16_t)0x0200)
#define TIM_DMABurstLength_4Bytes         ((uint16_t)0x0300)
#define TIM_DMABurstLength_5Bytes         ((uint16_t)0x0400)
#define TIM_DMABurstLength_6Bytes         ((uint16_t)0x0500)
#define TIM_DMABurstLength_7Bytes         ((uint16_t)0x0600)
#define TIM_DMABurstLength_8Bytes         ((uint16_t)0x0700)
#define TIM_DMABurstLength_9Bytes         ((uint16_t)0x0800)
#define TIM_DMABurstLength_10Bytes        ((uint16_t)0x0900)
#define TIM_DMABurstLength_11Bytes        ((uint16_t)0x0A00)
#define TIM_DMABurstLength_12Bytes        ((uint16_t)0x0B00)
#define TIM_DMABurstLength_13Bytes        ((uint16_t)0x0C00)
#define TIM_DMABurstLength_14Bytes        ((uint16_t)0x0D00)
#define TIM_DMABurstLength_15Bytes        ((uint16_t)0x0E00)
#define TIM_DMABurstLength_16Bytes        ((uint16_t)0x0F00)
#define TIM_DMABurstLength_17Bytes        ((uint16_t)0x1000)
#define TIM_DMABurstLength_18Bytes        ((uint16_t)0x1100)

#define IS_TIM_DMA_LENGTH(LENGTH) ((LENGTH == TIM_DMABurstLength_1Byte) || \
                                   (LENGTH == TIM_DMABurstLength_2Bytes) || \
                                   (LENGTH == TIM_DMABurstLength_3Bytes) || \
                                   (LENGTH == TIM_DMABurstLength_4Bytes) || \
                                   (LENGTH == TIM_DMABurstLength_5Bytes) || \
                                   (LENGTH == TIM_DMABurstLength_6Bytes) || \
                                   (LENGTH == TIM_DMABurstLength_7Bytes) || \
                                   (LENGTH == TIM_DMABurstLength_8Bytes) || \
                                   (LENGTH == TIM_DMABurstLength_9Bytes) || \
                                   (LENGTH == TIM_DMABurstLength_10Bytes) || \
                                   (LENGTH == TIM_DMABurstLength_11Bytes) || \
                                   (LENGTH == TIM_DMABurstLength_12Bytes) || \
                                   (LENGTH == TIM_DMABurstLength_13Bytes) || \
                                   (LENGTH == TIM_DMABurstLength_14Bytes) || \
                                   (LENGTH == TIM_DMABurstLength_15Bytes) || \
                                   (LENGTH == TIM_DMABurstLength_16Bytes) || \
                                   (LENGTH == TIM_DMABurstLength_17Bytes) || \
                                   (LENGTH == TIM_DMABurstLength_18Bytes))
                                                        
/* TIM DMA sources ----------------------------------------------------------*/
#define TIM_DMA_Update                    ((uint16_t)0x0100)
#define TIM_DMA_CC1                       ((uint16_t)0x0200)
#define TIM_DMA_CC2                       ((uint16_t)0x0400)
#define TIM_DMA_CC3                       ((uint16_t)0x0800)
#define TIM_DMA_CC4                       ((uint16_t)0x1000)
#define TIM_DMA_Trigger                   ((uint16_t)0x4000)

#define IS_TIM_DMA_SOURCE(SOURCE) (((SOURCE & (uint16_t)0xA0FF) == 0x0000) && (SOURCE != 0x0000))

/* TIM External Trigger Prescaler -------------------------------------------*/
#define TIM_ExtTRGPSC_OFF                 ((uint16_t)0x0000)
#define TIM_ExtTRGPSC_DIV2                ((uint16_t)0x1000) 
#define TIM_ExtTRGPSC_DIV4                ((uint16_t)0x2000)
#define TIM_ExtTRGPSC_DIV8                ((uint16_t)0x3000)

#define IS_TIM_EXT_PRESCALER(PRESCALER) ((PRESCALER == TIM_ExtTRGPSC_OFF) || \
                                         (PRESCALER == TIM_ExtTRGPSC_DIV2) || \
                                         (PRESCALER == TIM_ExtTRGPSC_DIV4) || \
                                         (PRESCALER == TIM_ExtTRGPSC_DIV8))

/* TIM Input Trigger Selection ---------------------------------------------*/
#define TIM_TS_ITR0                       ((uint16_t)0x0000)
#define TIM_TS_ITR1                       ((uint16_t)0x0010)
#define TIM_TS_ITR2                       ((uint16_t)0x0020)
#define TIM_TS_ITR3                       ((uint16_t)0x0030)
#define TIM_TS_TI1F_ED                    ((uint16_t)0x0040)
#define TIM_TS_TI1FP1                     ((uint16_t)0x0050)
#define TIM_TS_TI2FP2                     ((uint16_t)0x0060)
#define TIM_TS_ETRF                       ((uint16_t)0x0070)

#define IS_TIM_TRIGGER_SELECTION(SELECTION) ((SELECTION == TIM_TS_ITR0) || \
                                             (SELECTION == TIM_TS_ITR1) || \
                                             (SELECTION == TIM_TS_ITR2) || \
                                             (SELECTION == TIM_TS_ITR3) || \
                                             (SELECTION == TIM_TS_TI1F_ED) || \
                                             (SELECTION == TIM_TS_TI1FP1) || \
                                             (SELECTION == TIM_TS_TI2FP2) || \
                                             (SELECTION == TIM_TS_ETRF))

#define IS_TIM_INTERNAL_TRIGGER_SELECTION(SELECTION) ((SELECTION == TIM_TS_ITR0) || \
                                                      (SELECTION == TIM_TS_ITR1) || \
                                                      (SELECTION == TIM_TS_ITR2) || \
                                                      (SELECTION == TIM_TS_ITR3))

/*#define IS_TIM_TIX_TRIGGER_SELECTION(SELECTION) ((SELECTION == TIM_TS_TI1F_ED) || \
                                                 (SELECTION == TIM_TS_TI1FP1) || \
                                                 (SELECTION == TIM_TS_TI2FP2))*/

/* TIM External Trigger Polarity --------------------------------------------*/
#define TIM_ExtTRGPolarity_Inverted       ((uint16_t)0x8000)
#define TIM_ExtTRGPolarity_NonInverted    ((uint16_t)0x0000)

#define IS_TIM_EXT_POLARITY(POLARITY) ((POLARITY == TIM_ExtTRGPolarity_Inverted) || \
                                       (POLARITY == TIM_ExtTRGPolarity_NonInverted)) 

/* TIM Prescaler Reload Mode ------------------------------------------------*/
#define TIM_PSCReloadMode_Update          ((uint16_t)0x0000)
#define TIM_PSCReloadMode_Immediate       ((uint16_t)0x0001)

#define IS_TIM_PRESCALER_RELOAD(RELOAD) ((RELOAD == TIM_PSCReloadMode_Update) || \
                                         (RELOAD == TIM_PSCReloadMode_Immediate))

/* TIM Forced Action --------------------------------------------------------*/
#define TIM_ForcedAction_Active           ((uint16_t)0x0050)
#define TIM_ForcedAction_InActive         ((uint16_t)0x0040)

#define IS_TIM_FORCED_ACTION(ACTION) ((ACTION == TIM_ForcedAction_Active) || \
                                      (ACTION == TIM_ForcedAction_InActive))

/* TIM Encoder Mode ---------------------------------------------------------*/ 
#define TIM_EncoderMode_TI1               ((uint16_t)0x0001)
#define TIM_EncoderMode_TI2               ((uint16_t)0x0002)
#define TIM_EncoderMode_TI12              ((uint16_t)0x0003)

#define IS_TIM_ENCODER_MODE(MODE) ((MODE == TIM_EncoderMode_TI1) || \
                                   (MODE == TIM_EncoderMode_TI2) || \
                                   (MODE == TIM_EncoderMode_TI12))

/* TIM Event Source ---------------------------------------------------------*/
#define TIM_EventSource_Update            ((uint16_t)0x0001)
#define TIM_EventSource_CC1               ((uint16_t)0x0002)
#define TIM_EventSource_CC2               ((uint16_t)0x0004)
#define TIM_EventSource_CC3               ((uint16_t)0x0008)
#define TIM_EventSource_CC4               ((uint16_t)0x0010)
#define TIM_EventSource_Trigger           ((uint16_t)0x0040)

#define IS_TIM_EVENT_SOURCE(SOURCE) (((SOURCE & (uint16_t)0xFFA0) == 0x0000) && (SOURCE != 0x0000))
                                     

/* TIM Update Source --------------------------------------------------------*/
#define TIM_UpdateSource_Global           ((uint16_t)0x0000)
#define TIM_UpdateSource_Regular          ((uint16_t)0x0001)

#define IS_TIM_UPDATE_SOURCE(SOURCE) ((SOURCE == TIM_UpdateSource_Global) || \
                                      (SOURCE == TIM_UpdateSource_Regular))

/* TIM Ouput Compare Preload State ------------------------------------------*/
#define TIM_OCPreload_Enable              ((uint16_t)0x0008)
#define TIM_OCPreload_Disable             ((uint16_t)0x0000)

#define IS_TIM_OCPRELOAD_STATE(STATE) ((STATE == TIM_OCPreload_Enable) || \
                                       (STATE == TIM_OCPreload_Disable))

/* TIM Ouput Compare Fast State ---------------------------------------------*/
#define TIM_OCFast_Enable                 ((uint16_t)0x0004)
#define TIM_OCFast_Disable                ((uint16_t)0x0000)

#define IS_TIM_OCFAST_STATE(STATE) ((STATE == TIM_OCFast_Enable) || \
                                    (STATE == TIM_OCFast_Disable))
                                    
/* TIM Ouput Compare Clear State ---------------------------------------------*/
#define TIM_OCClear_Enable                ((uint16_t)0x0080)
#define TIM_OCClear_Disable               ((uint16_t)0x0000)

#define IS_TIM_OCCLEAR_STATE(STATE) ((STATE == TIM_OCClear_Enable) || \
                                     (STATE == TIM_OCClear_Disable))

/* TIM Trigger Output Source ------------------------------------------------*/ 
#define TIM_TRGOSource_Reset              ((uint16_t)0x0000)
#define TIM_TRGOSource_Enable             ((uint16_t)0x0010)
#define TIM_TRGOSource_Update             ((uint16_t)0x0020)
#define TIM_TRGOSource_OC1                ((uint16_t)0x0030)
#define TIM_TRGOSource_OC1Ref             ((uint16_t)0x0040)
#define TIM_TRGOSource_OC2Ref             ((uint16_t)0x0050)
#define TIM_TRGOSource_OC3Ref             ((uint16_t)0x0060)
#define TIM_TRGOSource_OC4Ref             ((uint16_t)0x0070)

#define IS_TIM_TRGO_SOURCE(SOURCE) ((SOURCE == TIM_TRGOSource_Reset) || \
                                    (SOURCE == TIM_TRGOSource_Enable) || \
                                    (SOURCE == TIM_TRGOSource_Update) || \
                                    (SOURCE == TIM_TRGOSource_OC1) || \
                                    (SOURCE == TIM_TRGOSource_OC1Ref) || \
                                    (SOURCE == TIM_TRGOSource_OC2Ref) || \
                                    (SOURCE == TIM_TRGOSource_OC3Ref) || \
                                    (SOURCE == TIM_TRGOSource_OC4Ref))

/* TIM Slave Mode -----------------------------------------------------------*/
#define TIM_SlaveMode_Reset               ((uint16_t)0x0004)
#define TIM_SlaveMode_Gated               ((uint16_t)0x0005)
#define TIM_SlaveMode_Trigger             ((uint16_t)0x0006)
#define TIM_SlaveMode_External1           ((uint16_t)0x0007)


#define IS_TIM_SLAVE_MODE(MODE) ((MODE == TIM_SlaveMode_Reset) || \
                                 (MODE == TIM_SlaveMode_Gated) || \
                                 (MODE == TIM_SlaveMode_Trigger) || \
                                 (MODE == TIM_SlaveMode_External1))

/* TIM TIx External Clock Source --------------------------------------------*/
#define TIM_TIxExternalCLK1Source_TI1     ((uint16_t)0x0050)
#define TIM_TIxExternalCLK1Source_TI2     ((uint16_t)0x0060)
#define TIM_TIxExternalCLK1Source_TI1ED   ((uint16_t)0x0040)

#define IS_TIM_TIXCLK_SOURCE(SOURCE) ((SOURCE == TIM_TIxExternalCLK1Source_TI1) || \
                                      (SOURCE == TIM_TIxExternalCLK1Source_TI2) || \
                                      (SOURCE == TIM_TIxExternalCLK1Source_TI1ED))


/* TIM Master Slave Mode ----------------------------------------------------*/
#define TIM_MasterSlaveMode_Enable        ((uint16_t)0x0080)
#define TIM_MasterSlaveMode_Disable       ((uint16_t)0x0000)

#define IS_TIM_MSM_STATE(STATE) ((STATE == TIM_MasterSlaveMode_Enable) || \
                                 (STATE == TIM_MasterSlaveMode_Disable))

/* TIM Flags ----------------------------------------------------------------*/
#define TIM_FLAG_Update                   ((uint16_t)0x0001)
#define TIM_FLAG_CC1                      ((uint16_t)0x0002)
#define TIM_FLAG_CC2                      ((uint16_t)0x0004)
#define TIM_FLAG_CC3                      ((uint16_t)0x0008)
#define TIM_FLAG_CC4                      ((uint16_t)0x0010)
#define TIM_FLAG_Trigger                  ((uint16_t)0x0040)
#define TIM_FLAG_CC1OF                    ((uint16_t)0x0200)
#define TIM_FLAG_CC2OF                    ((uint16_t)0x0400)
#define TIM_FLAG_CC3OF                    ((uint16_t)0x0800)
#define TIM_FLAG_CC4OF                    ((uint16_t)0x1000)

#define IS_TIM_GET_FLAG(FLAG) ((FLAG == TIM_FLAG_Update) || \
                               (FLAG == TIM_FLAG_CC1) || \
                               (FLAG == TIM_FLAG_CC2) || \
                               (FLAG == TIM_FLAG_CC3) || \
                               (FLAG == TIM_FLAG_CC4) || \
                               (FLAG == TIM_FLAG_Trigger) || \
                               (FLAG == TIM_FLAG_CC1OF) || \
                               (FLAG == TIM_FLAG_CC2OF) || \
                               (FLAG == TIM_FLAG_CC3OF) || \
                               (FLAG == TIM_FLAG_CC4OF))

#define IS_TIM_CLEAR_FLAG(FLAG) (((FLAG & (uint16_t)0xE1A0) == 0x0000) && (FLAG != 0x0000)) 
                                 


/* Exported macro ------------------------------------------------------------*/
/* Exported functions --------------------------------------------------------*/
void TIM_DeInit(TIM_TypeDef* TIMx);
void TIM_TimeBaseInit(TIM_TypeDef* TIMx, TIM_TimeBaseInitTypeDef* TIM_TimeBaseInitStruct);
void TIM_OCInit(TIM_TypeDef* TIMx, TIM_OCInitTypeDef* TIM_OCInitStruct);
void TIM_ICInit(TIM_TypeDef* TIMx, TIM_ICInitTypeDef* TIM_ICInitStruct);
void TIM_TimeBaseStructInit(TIM_TimeBaseInitTypeDef* TIM_TimeBaseInitStruct);
void TIM_OCStructInit(TIM_OCInitTypeDef* TIM_OCInitStruct);
void TIM_ICStructInit(TIM_ICInitTypeDef* TIM_ICInitStruct);
void TIM_Cmd(TIM_TypeDef* TIMx, FunctionalState NewState);
void TIM_ITConfig(TIM_TypeDef* TIMx, uint16_t TIM_IT, FunctionalState NewState);
void TIM_DMAConfig(TIM_TypeDef* TIMx, uint16_t TIM_DMABase, uint16_t TIM_DMABurstLength);
void TIM_DMACmd(TIM_TypeDef* TIMx, uint16_t TIM_DMASource, FunctionalState Newstate);
void TIM_InternalClockConfig(TIM_TypeDef* TIMx);
void TIM_ITRxExternalClockConfig(TIM_TypeDef* TIMx, uint16_t TIM_InputTriggerSource);
void TIM_TIxExternalClockConfig(TIM_TypeDef* TIMx, uint16_t TIM_TIxExternalCLKSource, 
                                uint16_t TIM_ICPolarity, uint8_t ICFilter);
void TIM_ETRClockMode1Config(TIM_TypeDef* TIMx, uint16_t TIM_ExtTRGPrescaler, uint16_t TIM_ExtTRGPolarity, 
                             uint8_t ExtTRGFilter);
void TIM_ETRClockMode2Config(TIM_TypeDef* TIMx, uint16_t TIM_ExtTRGPrescaler, uint16_t TIM_ExtTRGPolarity, 
                             uint8_t ExtTRGFilter);
void TIM_ETRConfig(TIM_TypeDef* TIMx, uint16_t TIM_ExtTRGPrescaler, uint16_t TIM_ExtTRGPolarity,
                   uint8_t ExtTRGFilter);							 					   
void TIM_SelectInputTrigger(TIM_TypeDef* TIMx, uint16_t TIM_InputTriggerSource);
void TIM_PrescalerConfig(TIM_TypeDef* TIMx, uint16_t Prescaler, uint16_t TIM_PSCReloadMode);
void TIM_CounterModeConfig(TIM_TypeDef* TIMx, uint16_t TIM_CounterMode);
void TIM_ForcedOC1Config(TIM_TypeDef* TIMx, uint16_t TIM_ForcedAction);
void TIM_ForcedOC2Config(TIM_TypeDef* TIMx, uint16_t TIM_ForcedAction);
void TIM_ForcedOC3Config(TIM_TypeDef* TIMx, uint16_t TIM_ForcedAction);
void TIM_ForcedOC4Config(TIM_TypeDef* TIMx, uint16_t TIM_ForcedAction);
void TIM_ARRPreloadConfig(TIM_TypeDef* TIMx, FunctionalState Newstate);
void TIM_SelectCCDMA(TIM_TypeDef* TIMx, FunctionalState Newstate);
void TIM_OC1PreloadConfig(TIM_TypeDef* TIMx, uint16_t TIM_OCPreload);
void TIM_OC2PreloadConfig(TIM_TypeDef* TIMx, uint16_t TIM_OCPreload);
void TIM_OC3PreloadConfig(TIM_TypeDef* TIMx, uint16_t TIM_OCPreload);
void TIM_OC4PreloadConfig(TIM_TypeDef* TIMx, uint16_t TIM_OCPreload);
void TIM_OC1FastConfig(TIM_TypeDef* TIMx, uint16_t TIM_OCFast);
void TIM_OC2FastConfig(TIM_TypeDef* TIMx, uint16_t TIM_OCFast);
void TIM_OC3FastConfig(TIM_TypeDef* TIMx, uint16_t TIM_OCFast);
void TIM_OC4FastConfig(TIM_TypeDef* TIMx, uint16_t TIM_OCFast);
void TIM_ClearOC1Ref(TIM_TypeDef* TIMx, uint16_t TIM_OCClear);
void TIM_ClearOC2Ref(TIM_TypeDef* TIMx, uint16_t TIM_OCClear);
void TIM_ClearOC3Ref(TIM_TypeDef* TIMx, uint16_t TIM_OCClear);
void TIM_ClearOC4Ref(TIM_TypeDef* TIMx, uint16_t TIM_OCClear);
void TIM_UpdateDisableConfig(TIM_TypeDef* TIMx, FunctionalState Newstate);
void TIM_EncoderInterfaceConfig(TIM_TypeDef* TIMx, uint16_t TIM_EncoderMode, 
                                uint16_t TIM_IC1Polarity, uint16_t TIM_IC2Polarity);
void TIM_GenerateEvent(TIM_TypeDef* TIMx, uint16_t TIM_EventSource);
void TIM_OC1PolarityConfig(TIM_TypeDef* TIMx, uint16_t TIM_OCPolarity);
void TIM_OC2PolarityConfig(TIM_TypeDef* TIMx, uint16_t TIM_OCPolarity);
void TIM_OC3PolarityConfig(TIM_TypeDef* TIMx, uint16_t TIM_OCPolarity);
void TIM_OC4PolarityConfig(TIM_TypeDef* TIMx, uint16_t TIM_OCPolarity);  
void TIM_UpdateRequestConfig(TIM_TypeDef* TIMx, uint16_t TIM_UpdateSource);
void TIM_SelectHallSensor(TIM_TypeDef* TIMx, FunctionalState Newstate);
void TIM_SelectOnePulseMode(TIM_TypeDef* TIMx, uint16_t TIM_OPMode);
void TIM_SelectOutputTrigger(TIM_TypeDef* TIMx, uint16_t TIM_TRGOSource);
void TIM_SelectSlaveMode(TIM_TypeDef* TIMx, uint16_t TIM_SlaveMode);
void TIM_SelectMasterSlaveMode(TIM_TypeDef* TIMx, uint16_t TIM_MasterSlaveMode);
void TIM_SetCounter(TIM_TypeDef* TIMx, uint16_t Counter);
void TIM_SetAutoreload(TIM_TypeDef* TIMx, uint16_t Autoreload);
void TIM_SetCompare1(TIM_TypeDef* TIMx, uint16_t Compare1);
void TIM_SetCompare2(TIM_TypeDef* TIMx, uint16_t Compare2);
void TIM_SetCompare3(TIM_TypeDef* TIMx, uint16_t Compare3);
void TIM_SetCompare4(TIM_TypeDef* TIMx, uint16_t Compare4);
void TIM_SetIC1Prescaler(TIM_TypeDef* TIMx, uint16_t TIM_IC1Prescaler);
void TIM_SetIC2Prescaler(TIM_TypeDef* TIMx, uint16_t TIM_IC2Prescaler);
void TIM_SetIC3Prescaler(TIM_TypeDef* TIMx, uint16_t TIM_IC3Prescaler);
void TIM_SetIC4Prescaler(TIM_TypeDef* TIMx, uint16_t TIM_IC4Prescaler);
void TIM_SetClockDivision(TIM_TypeDef* TIMx, uint16_t TIM_CKD);
uint16_t TIM_GetCapture1(TIM_TypeDef* TIMx);
uint16_t TIM_GetCapture2(TIM_TypeDef* TIMx);
uint16_t TIM_GetCapture3(TIM_TypeDef* TIMx);
uint16_t TIM_GetCapture4(TIM_TypeDef* TIMx);
uint16_t TIM_GetCounter(TIM_TypeDef* TIMx);
uint16_t TIM_GetPrescaler(TIM_TypeDef* TIMx);
FlagStatus TIM_GetFlagStatus(TIM_TypeDef* TIMx, uint16_t TIM_FLAG); 
void TIM_ClearFlag(TIM_TypeDef* TIMx, uint16_t TIM_FLAG);
ITStatus TIM_GetITStatus(TIM_TypeDef* TIMx, uint16_t TIM_IT);
void TIM_ClearITPendingBit(TIM_TypeDef* TIMx, uint16_t TIM_IT);

#endif /*__STM32F10x_TIM_H */

/******************* (C) COPYRIGHT 2007 STMicroelectronics *****END OF FILE****/
