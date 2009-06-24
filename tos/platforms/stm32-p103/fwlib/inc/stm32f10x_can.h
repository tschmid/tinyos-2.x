/******************** (C) COPYRIGHT 2007 STMicroelectronics ********************
* File Name          : stm32f10x_can.h
* Author             : MCD Application Team
* Version            : V1.0
* Date               : 10/08/2007
* Description        : This file contains all the functions prototypes for the
*                      CAN firmware library.
********************************************************************************
* THE PRESENT SOFTWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
* WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE TIME.
* AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY DIRECT,
* INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING FROM THE
* CONTENT OF SUCH SOFTWARE AND/OR THE USE MADE BY CUSTOMERS OF THE CODING
* INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
*******************************************************************************/

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __STM32F10x_CAN_H
#define __STM32F10x_CAN_H

/* Includes ------------------------------------------------------------------*/
#include "stm32f10x_map.h"

/* Exported types ------------------------------------------------------------*/
/* CAN init structure definition */
typedef struct
{
  FunctionalState CAN_TTCM;
  FunctionalState CAN_ABOM;
  FunctionalState CAN_AWUM;
  FunctionalState CAN_NART;
  FunctionalState CAN_RFLM;
  FunctionalState CAN_TXFP;
  uint8_t CAN_Mode;
  uint8_t CAN_SJW;
  uint8_t CAN_BS1;
  uint8_t CAN_BS2;
  uint16_t CAN_Prescaler;
} CAN_InitTypeDef;

/* CAN filter init structure definition */
typedef struct
{
  uint8_t CAN_FilterNumber;
  uint8_t CAN_FilterMode;
  uint8_t CAN_FilterScale;
  uint16_t CAN_FilterIdHigh;
  uint16_t CAN_FilterIdLow;
  uint16_t CAN_FilterMaskIdHigh;
  uint16_t CAN_FilterMaskIdLow;
  uint16_t CAN_FilterFIFOAssignment;
  FunctionalState CAN_FilterActivation;
} CAN_FilterInitTypeDef;

/* CAN Tx message structure definition */
typedef struct
{
  uint32_t StdId;
  uint32_t ExtId;
  uint8_t IDE;
  uint8_t RTR;
  uint8_t DLC;
  uint8_t Data[8];
} CanTxMsg;

/* CAN Rx message structure definition */
typedef struct
{
  uint32_t StdId;
  uint32_t ExtId;
  uint8_t IDE;
  uint8_t RTR;
  uint8_t DLC;
  uint8_t Data[8];
  uint8_t FMI;
} CanRxMsg;

/* Exported constants --------------------------------------------------------*/

/* CAN sleep constants */
#define CANINITFAILED              ((uint8_t)0x00) /* CAN initialization failed */
#define CANINITOK                  ((uint8_t)0x01) /* CAN initialization failed */

/* CAN operating mode */
#define CAN_Mode_Normal             ((uint8_t)0x00)  /* normal mode */
#define CAN_Mode_LoopBack           ((uint8_t)0x01)  /* loopback mode */
#define CAN_Mode_Silent             ((uint8_t)0x02)  /* silent mode */
#define CAN_Mode_Silent_LoopBack    ((uint8_t)0x03)  /* loopback combined with silent mode */

#define IS_CAN_MODE(MODE) ((MODE == CAN_Mode_Normal) || (MODE == CAN_Mode_LoopBack)|| \
                           (MODE == CAN_Mode_Silent) || (MODE == CAN_Mode_Silent_LoopBack))

/* CAN synchronisation jump width */
#define CAN_SJW_1tq                 ((uint8_t)0x00)  /* 1 time quantum */
#define CAN_SJW_2tq                 ((uint8_t)0x01)  /* 2 time quantum */
#define CAN_SJW_3tq                 ((uint8_t)0x02)  /* 3 time quantum */
#define CAN_SJW_4tq                 ((uint8_t)0x03)  /* 4 time quantum */

#define IS_CAN_SJW(SJW) ((SJW == CAN_SJW_1tq) || (SJW == CAN_SJW_2tq)|| \
                         (SJW == CAN_SJW_3tq) || (SJW == CAN_SJW_4tq))

/* time quantum in bit segment 1 */
#define CAN_BS1_1tq                 ((uint8_t)0x00)  /* 1 time quantum */
#define CAN_BS1_2tq                 ((uint8_t)0x01)  /* 2 time quantum */
#define CAN_BS1_3tq                 ((uint8_t)0x02)  /* 3 time quantum */
#define CAN_BS1_4tq                 ((uint8_t)0x03)  /* 4 time quantum */
#define CAN_BS1_5tq                 ((uint8_t)0x04)  /* 5 time quantum */
#define CAN_BS1_6tq                 ((uint8_t)0x05)  /* 6 time quantum */
#define CAN_BS1_7tq                 ((uint8_t)0x06)  /* 7 time quantum */
#define CAN_BS1_8tq                 ((uint8_t)0x07)  /* 8 time quantum */
#define CAN_BS1_9tq                 ((uint8_t)0x08)  /* 9 time quantum */
#define CAN_BS1_10tq                ((uint8_t)0x09)  /* 10 time quantum */
#define CAN_BS1_11tq                ((uint8_t)0x0A)  /* 11 time quantum */
#define CAN_BS1_12tq                ((uint8_t)0x0B)  /* 12 time quantum */
#define CAN_BS1_13tq                ((uint8_t)0x0C)  /* 13 time quantum */
#define CAN_BS1_14tq                ((uint8_t)0x0D)  /* 14 time quantum */
#define CAN_BS1_15tq                ((uint8_t)0x0E)  /* 15 time quantum */
#define CAN_BS1_16tq                ((uint8_t)0x0F)  /* 16 time quantum */

#define IS_CAN_BS1(BS1) (BS1 <= CAN_BS1_16tq)

/* time quantum in bit segment 2 */
#define CAN_BS2_1tq                 ((uint8_t)0x00)  /* 1 time quantum */
#define CAN_BS2_2tq                 ((uint8_t)0x01)  /* 2 time quantum */
#define CAN_BS2_3tq                 ((uint8_t)0x02)  /* 3 time quantum */
#define CAN_BS2_4tq                 ((uint8_t)0x03)  /* 4 time quantum */
#define CAN_BS2_5tq                 ((uint8_t)0x04)  /* 5 time quantum */
#define CAN_BS2_6tq                 ((uint8_t)0x05)  /* 6 time quantum */
#define CAN_BS2_7tq                 ((uint8_t)0x06)  /* 7 time quantum */
#define CAN_BS2_8tq                 ((uint8_t)0x07)  /* 8 time quantum */

#define IS_CAN_BS2(BS2) (BS2 <= CAN_BS2_8tq)

/* CAN clock prescaler */
#define IS_CAN_PRESCALER(PRESCALER) ((PRESCALER >= 1) && (PRESCALER <= 1024))

/* CAN filter number */
#define IS_CAN_FILTER_NUMBER(NUMBER) (NUMBER <= 13)

/* CAN filter mode */
#define CAN_FilterMode_IdMask       ((uint8_t)0x00)  /* id/mask mode */
#define CAN_FilterMode_IdList       ((uint8_t)0x01)  /* identifier list mode */

#define IS_CAN_FILTER_MODE(MODE) ((MODE == CAN_FilterMode_IdMask) || \
                                       (MODE == CAN_FilterMode_IdList))

/* CAN filter scale */
#define CAN_FilterScale_16bit       ((uint8_t)0x00) /* 16-bit filter scale */
#define CAN_FilterScale_32bit       ((uint8_t)0x01) /* 2-bit filter scale */

#define IS_CAN_FILTER_SCALE(SCALE) ((SCALE == CAN_FilterScale_16bit) || \
                                         (SCALE == CAN_FilterScale_32bit))

/* CAN filter FIFO assignation */
#define CAN_FilterFIFO0             ((uint8_t)0x00)  /* Filter FIFO 0 assignment for filter x */
#define CAN_FilterFIFO1             ((uint8_t)0x01)  /* Filter FIFO 1 assignment for filter x */

#define IS_CAN_FILTER_FIFO(FIFO) ((FIFO == CAN_FilterFIFO0) || \
                                       (FIFO == CAN_FilterFIFO1))

/* CAN Tx */
#define IS_CAN_TRANSMITMAILBOX(TRANSMITMAILBOX) (TRANSMITMAILBOX <= ((uint8_t)0x02))
#define IS_CAN_STDID(STDID)   (STDID <= ((uint32_t)0x7FF))
#define IS_CAN_EXTID(EXTID)   (EXTID <= ((uint32_t)0x3FFFF))
#define IS_CAN_DLC(DLC)       (DLC <= ((uint8_t)0x08))

/* CAN identifier type */
#define CAN_ID_STD                 ((uint32_t)0x00000000)  /* Standard Id */
#define CAN_ID_EXT                 ((uint32_t)0x00000004)  /* Extended Id */

#define IS_CAN_IDTYPE(IDTYPE) ((IDTYPE == CAN_ID_STD) || (IDTYPE == CAN_ID_EXT))

/* CAN remote transmission request */
#define CAN_RTR_DATA                ((uint32_t)0x00000000)  /* Data frame */
#define CAN_RTR_REMOTE              ((uint32_t)0x00000002)  /* Remote frame */

#define IS_CAN_RTR(RTR) ((RTR == CAN_RTR_DATA) || (RTR == CAN_RTR_REMOTE))

/* CAN transmit constants */
#define CANTXFAILED                 ((uint8_t)0x00) /* CAN transmission failed */
#define CANTXOK                     ((uint8_t)0x01) /* CAN transmission succeeded */
#define CANTXPENDING                ((uint8_t)0x02) /* CAN transmission pending */
#define CAN_NO_MB                   ((uint8_t)0x04) /* CAN cell did not provide an empty mailbox */

/* CAN receive FIFO number constants */
#define CAN_FIFO0                 ((uint8_t)0x00) /* CAN FIFO0 used to receive */
#define CAN_FIFO1                 ((uint8_t)0x01) /* CAN FIFO1 used to receive */

#define IS_CAN_FIFO(FIFO) ((FIFO == CAN_FIFO0) || (FIFO == CAN_FIFO1))

/* CAN sleep constants */
#define CANSLEEPFAILED              ((uint8_t)0x00) /* CAN did not enter the sleep mode */
#define CANSLEEPOK                  ((uint8_t)0x01) /* CAN entered the sleep mode */

/* CAN wake up constants */
#define CANWAKEUPFAILED             ((uint8_t)0x00) /* CAN did not leave the sleep mode */
#define CANWAKEUPOK                 ((uint8_t)0x01) /* CAN leaved the sleep mode */

/* CAN flags */
#define CAN_FLAG_EWG                ((uint32_t)0x00000001) /* Error Warning Flag */
#define CAN_FLAG_EPV                ((uint32_t)0x00000002) /* Error Passive Flag */
#define CAN_FLAG_BOF                ((uint32_t)0x00000004) /* Bus-Off Flag */

#define IS_CAN_FLAG(FLAG) ((FLAG == CAN_FLAG_EWG) || (FLAG == CAN_FLAG_EPV) ||\
                           (FLAG == CAN_FLAG_BOF))

/* CAN interrupts */
#define CAN_IT_RQCP0                ((uint32_t)0x00000005) /* Request completed mailbox 0 */
#define CAN_IT_RQCP1                ((uint32_t)0x00000006) /* Request completed mailbox 1 */
#define CAN_IT_RQCP2                ((uint32_t)0x00000007) /* Request completed mailbox 2 */
#define CAN_IT_TME                  ((uint32_t)0x00000001) /* Transmit mailbox empty */
#define CAN_IT_FMP0                 ((uint32_t)0x00000002) /* FIFO 0 message pending */
#define CAN_IT_FF0                  ((uint32_t)0x00000004) /* FIFO 0 full */
#define CAN_IT_FOV0                 ((uint32_t)0x00000008) /* FIFO 0 overrun */
#define CAN_IT_FMP1                 ((uint32_t)0x00000010) /* FIFO 1 message pending */
#define CAN_IT_FF1                  ((uint32_t)0x00000020) /* FIFO 1 full */
#define CAN_IT_FOV1                 ((uint32_t)0x00000040) /* FIFO 1 overrun */
#define CAN_IT_EWG                  ((uint32_t)0x00000100) /* Error warning */
#define CAN_IT_EPV                  ((uint32_t)0x00000200) /* Error passive */
#define CAN_IT_BOF                  ((uint32_t)0x00000400) /* Bus-off */
#define CAN_IT_LEC                  ((uint32_t)0x00000800) /* Last error code */
#define CAN_IT_ERR                  ((uint32_t)0x00008000) /* Error */
#define CAN_IT_WKU                  ((uint32_t)0x00010000) /* Wake-up */
#define CAN_IT_SLK                  ((uint32_t)0x00020000) /* Sleep */

#define IS_CAN_ITConfig(IT) ((IT == CAN_IT_TME)   || (IT == CAN_IT_FMP0)  ||\
                             (IT == CAN_IT_FF0)   || (IT == CAN_IT_FOV0)  ||\
                             (IT == CAN_IT_FMP1)  || (IT == CAN_IT_FF1)   ||\
                             (IT == CAN_IT_FOV1)  || (IT == CAN_IT_EWG)   ||\
                             (IT == CAN_IT_EPV)   || (IT == CAN_IT_BOF)   ||\
                             (IT == CAN_IT_LEC)   || (IT == CAN_IT_ERR)   ||\
                             (IT == CAN_IT_WKU)   || (IT == CAN_IT_SLK))

#define IS_CAN_ITStatus(IT) ((IT == CAN_IT_RQCP0)  || (IT == CAN_IT_RQCP1)  ||\
                             (IT == CAN_IT_RQCP2)  || (IT == CAN_IT_FF0)    ||\
                             (IT == CAN_IT_FOV0)   || (IT == CAN_IT_FF1)    ||\
                             (IT == CAN_IT_FOV1)   || (IT == CAN_IT_EWG)    ||\
                             (IT == CAN_IT_EPV)    || (IT == CAN_IT_BOF)    ||\
                             (IT == CAN_IT_WKU)    || (IT == CAN_IT_SLK))

/* Exported macro ------------------------------------------------------------*/
/* Exported function protypes ----------------------------------------------- */
void CAN_DeInit(void);
uint8_t CAN_Init(CAN_InitTypeDef* CAN_InitStruct);
void CAN_FilterInit(CAN_FilterInitTypeDef* CAN_FilterInitStruct);
void CAN_StructInit(CAN_InitTypeDef* CAN_InitStruct);
void CAN_ITConfig(uint32_t CAN_IT, FunctionalState NewState);
uint8_t CAN_Transmit(CanTxMsg* TxMessage);
uint8_t CAN_TransmitStatus(uint8_t TransmitMailbox);
void CAN_CancelTransmit(uint8_t Mailbox);
void CAN_FIFORelease(uint8_t FIFONumber);
uint8_t CAN_MessagePending(uint8_t FIFONumber);
void CAN_Receive(uint8_t FIFONumber, CanRxMsg* RxMessage);
uint8_t CAN_Sleep(void);
uint8_t CAN_WakeUp(void);
FlagStatus CAN_GetFlagStatus(uint32_t CAN_FLAG);
void CAN_ClearFlag(uint32_t CAN_FLAG);
ITStatus CAN_GetITStatus(uint32_t CAN_IT);
void CAN_ClearITPendingBit(uint32_t CAN_IT);

#endif /* __STM32F10x_CAN_H */

/******************* (C) COPYRIGHT 2007 STMicroelectronics *****END OF FILE****/
