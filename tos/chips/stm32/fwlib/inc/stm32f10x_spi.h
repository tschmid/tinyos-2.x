/******************** (C) COPYRIGHT 2007 STMicroelectronics ********************
* File Name          : stm32f10x_spi.h
* Author             : MCD Application Team
* Version            : V1.0
* Date               : 10/08/2007
* Description        : This file contains all the functions prototypes for the
*                      SPI firmware library.
********************************************************************************
* THE PRESENT SOFTWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
* WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE TIME.
* AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY DIRECT,
* INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING FROM THE
* CONTENT OF SUCH SOFTWARE AND/OR THE USE MADE BY CUSTOMERS OF THE CODING
* INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
*******************************************************************************/

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __STM32F10x_SPI_H
#define __STM32F10x_SPI_H

/* Includes ------------------------------------------------------------------*/
#include "stm32f10x_map.h"

/* Exported types ------------------------------------------------------------*/
/* SPI Init structure definition */
typedef struct
{
  uint16_t SPI_Direction;
  uint16_t SPI_Mode;
  uint16_t SPI_DataSize;
  uint16_t SPI_CPOL;
  uint16_t SPI_CPHA;
  uint16_t SPI_NSS;
  uint16_t SPI_BaudRatePrescaler;
  uint16_t SPI_FirstBit;
  uint16_t SPI_CRCPolynomial;
}SPI_InitTypeDef;

/* Exported constants --------------------------------------------------------*/
/* SPI data direction mode */
#define SPI_Direction_2Lines_FullDuplex    ((uint16_t)0x0000)
#define SPI_Direction_2Lines_RxOnly        ((uint16_t)0x0400)
#define SPI_Direction_1Line_Rx             ((uint16_t)0x8000)
#define SPI_Direction_1Line_Tx             ((uint16_t)0xC000)

#define IS_SPI_DIRECTION_MODE(MODE) ((MODE == SPI_Direction_2Lines_FullDuplex) || \
                                     (MODE == SPI_Direction_2Lines_RxOnly) || \
                                     (MODE == SPI_Direction_1Line_Rx) || \
						             (MODE == SPI_Direction_1Line_Tx))

/* SPI master/slave mode */
#define SPI_Mode_Master                    ((uint16_t)0x0104)
#define SPI_Mode_Slave                     ((uint16_t)0x0000)

#define IS_SPI_MODE(MODE) ((MODE == SPI_Mode_Master) || \
                           (MODE == SPI_Mode_Slave))

/* SPI data size */
#define SPI_DataSize_16b                   ((uint16_t)0x0800)
#define SPI_DataSize_8b                    ((uint16_t)0x0000)

#define IS_SPI_DATASIZE(DATASIZE) ((DATASIZE == SPI_DataSize_16b) || \
                                   (DATASIZE == SPI_DataSize_8b))

/* SPI Clock Polarity */
#define SPI_CPOL_Low                       ((uint16_t)0x0000)
#define SPI_CPOL_High                      ((uint16_t)0x0002)

#define IS_SPI_CPOL(CPOL) ((CPOL == SPI_CPOL_Low) || \
                           (CPOL == SPI_CPOL_High))

/* SPI Clock Phase */
#define SPI_CPHA_1Edge                     ((uint16_t)0x0000)
#define SPI_CPHA_2Edge                     ((uint16_t)0x0001)

#define IS_SPI_CPHA(CPHA) ((CPHA == SPI_CPHA_1Edge) || \
                           (CPHA == SPI_CPHA_2Edge))

/* SPI Slave Select management */
#define SPI_NSS_Soft                       ((uint16_t)0x0200)
#define SPI_NSS_Hard                       ((uint16_t)0x0000)

#define IS_SPI_NSS(NSS) ((NSS == SPI_NSS_Soft) || \
                         (NSS == SPI_NSS_Hard))

/* SPI BaudRate Prescaler  */
#define SPI_BaudRatePrescaler_2            ((uint16_t)0x0000)
#define SPI_BaudRatePrescaler_4            ((uint16_t)0x0008)
#define SPI_BaudRatePrescaler_8            ((uint16_t)0x0010)
#define SPI_BaudRatePrescaler_16           ((uint16_t)0x0018)
#define SPI_BaudRatePrescaler_32           ((uint16_t)0x0020)
#define SPI_BaudRatePrescaler_64           ((uint16_t)0x0028)
#define SPI_BaudRatePrescaler_128          ((uint16_t)0x0030)
#define SPI_BaudRatePrescaler_256          ((uint16_t)0x0038)

#define IS_SPI_BAUDRATE_PRESCALER(PRESCALER) ((PRESCALER == SPI_BaudRatePrescaler_2) || \
                                              (PRESCALER == SPI_BaudRatePrescaler_4) || \
                                              (PRESCALER == SPI_BaudRatePrescaler_8) || \
                                              (PRESCALER == SPI_BaudRatePrescaler_16) || \
                                              (PRESCALER == SPI_BaudRatePrescaler_32) || \
                                              (PRESCALER == SPI_BaudRatePrescaler_64) || \
                                              (PRESCALER == SPI_BaudRatePrescaler_128) || \
                                              (PRESCALER == SPI_BaudRatePrescaler_256))

/* SPI MSB/LSB transmission */
#define SPI_FirstBit_MSB                   ((uint16_t)0x0000)
#define SPI_FirstBit_LSB                   ((uint16_t)0x0080)

#define IS_SPI_FIRST_BIT(BIT) ((BIT == SPI_FirstBit_MSB) || \
                               (BIT == SPI_FirstBit_LSB))

/* SPI DMA transfer requests */
#define SPI_DMAReq_Tx                      ((uint16_t)0x0002)
#define SPI_DMAReq_Rx                      ((uint16_t)0x0001)

#define IS_SPI_DMA_REQ(REQ) (((REQ & (uint16_t)0xFFFC) == 0x00) && (REQ != 0x00))

/* SPI NSS internal software mangement */
#define SPI_NSSInternalSoft_Set            ((uint16_t)0x0100)
#define SPI_NSSInternalSoft_Reset          ((uint16_t)0xFEFF)

#define IS_SPI_NSS_INTERNAL(INTERNAL) ((INTERNAL == SPI_NSSInternalSoft_Set) || \
                                       (INTERNAL == SPI_NSSInternalSoft_Reset))

/* SPI CRC Transmit/Receive */
#define SPI_CRC_Tx                         ((uint8_t)0x00)
#define SPI_CRC_Rx                         ((uint8_t)0x01)

#define IS_SPI_CRC(CRC) ((CRC == SPI_CRC_Tx) || (CRC == SPI_CRC_Rx))

/* SPI direction transmit/receive */
#define SPI_Direction_Rx                   ((uint16_t)0xBFFF)
#define SPI_Direction_Tx                   ((uint16_t)0x4000)

#define IS_SPI_DIRECTION(DIRECTION) ((DIRECTION == SPI_Direction_Rx) || \
                                     (DIRECTION == SPI_Direction_Tx))

/* SPI interrupts definition */
#define SPI_IT_TXE                         ((uint8_t)0x71)
#define SPI_IT_RXNE                        ((uint8_t)0x60)
#define SPI_IT_ERR                         ((uint8_t)0x50)

#define IS_SPI_CONFIG_IT(IT) ((IT == SPI_IT_TXE) || (IT == SPI_IT_RXNE) || \
                              (IT == SPI_IT_ERR))

#define SPI_IT_OVR                         ((uint8_t)0x56)
#define SPI_IT_MODF                        ((uint8_t)0x55)
#define SPI_IT_CRCERR                      ((uint8_t)0x54)

#define IS_SPI_CLEAR_IT(IT) ((IT == SPI_IT_OVR) || (IT == SPI_IT_MODF) || \
                             (IT == SPI_IT_CRCERR))

#define IS_SPI_GET_IT(IT) ((IT == SPI_IT_TXE) || (IT == SPI_IT_RXNE) || \
                           (IT == SPI_IT_OVR) || (IT == SPI_IT_MODF) || \
                           (IT == SPI_IT_CRCERR))

/* SPI flags definition */
#define SPI_FLAG_RXNE                      ((uint16_t)0x0001)
#define SPI_FLAG_TXE                       ((uint16_t)0x0002)
#define SPI_FLAG_CRCERR                    ((uint16_t)0x0010)
#define SPI_FLAG_MODF                      ((uint16_t)0x0020)
#define SPI_FLAG_OVR                       ((uint16_t)0x0040)
#define SPI_FLAG_BSY                       ((uint16_t)0x0080)

#define IS_SPI_CLEAR_FLAG(FLAG) (((FLAG & (uint16_t)0xFF8F) == 0x00) && (FLAG != 0x00))
#define IS_SPI_GET_FLAG(FLAG) ((FLAG == SPI_FLAG_BSY) || (FLAG == SPI_FLAG_OVR) || \
                               (FLAG == SPI_FLAG_MODF) || (FLAG == SPI_FLAG_CRCERR) || \
                               (FLAG == SPI_FLAG_TXE) || (FLAG == SPI_FLAG_RXNE))

/* SPI CRC polynomial --------------------------------------------------------*/
#define IS_SPI_CRC_POLYNOMIAL(POLYNOMIAL) (POLYNOMIAL >= 0x1)

/* Exported macro ------------------------------------------------------------*/
/* Exported functions ------------------------------------------------------- */
void SPI_DeInit(SPI_TypeDef* SPIx);
void SPI_Init(SPI_TypeDef* SPIx, SPI_InitTypeDef* SPI_InitStruct);
void SPI_StructInit(SPI_InitTypeDef* SPI_InitStruct);
void SPI_Cmd(SPI_TypeDef* SPIx, FunctionalState NewState);
void SPI_ITConfig(SPI_TypeDef* SPIx, uint8_t SPI_IT, FunctionalState NewState);
void SPI_DMACmd(SPI_TypeDef* SPIx, uint16_t SPI_DMAReq, FunctionalState NewState);
void SPI_SendData(SPI_TypeDef* SPIx, uint16_t Data);
uint16_t SPI_ReceiveData(SPI_TypeDef* SPIx);
void SPI_NSSInternalSoftwareConfig(SPI_TypeDef* SPIx, uint16_t SPI_NSSInternalSoft);
void SPI_SSOutputCmd(SPI_TypeDef* SPIx, FunctionalState NewState);
void SPI_DataSizeConfig(SPI_TypeDef* SPIx, uint16_t SPI_DataSize);
void SPI_TransmitCRC(SPI_TypeDef* SPIx);
void SPI_CalculateCRC(SPI_TypeDef* SPIx, FunctionalState NewState);
uint16_t SPI_GetCRC(SPI_TypeDef* SPIx, uint8_t SPI_CRC);
uint16_t SPI_GetCRCPolynomial(SPI_TypeDef* SPIx);
void SPI_BiDirectionalLineConfig(SPI_TypeDef* SPIx, uint16_t SPI_Direction);
FlagStatus SPI_GetFlagStatus(SPI_TypeDef* SPIx, uint16_t SPI_FLAG);
void SPI_ClearFlag(SPI_TypeDef* SPIx, uint16_t SPI_FLAG);
ITStatus SPI_GetITStatus(SPI_TypeDef* SPIx, uint8_t SPI_IT);
void SPI_ClearITPendingBit(SPI_TypeDef* SPIx, uint8_t SPI_IT);

#endif /*__STM32F10x_SPI_H */

/******************* (C) COPYRIGHT 2007 STMicroelectronics *****END OF FILE****/
