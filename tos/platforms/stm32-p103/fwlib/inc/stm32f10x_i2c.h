/******************** (C) COPYRIGHT 2007 STMicroelectronics ********************
* File Name          : stm32f10x_i2c.h
* Author             : MCD Application Team
* Version            : V1.0
* Date               : 10/08/2007
* Description        : This file contains all the functions prototypes for the
*                      I2C firmware library.
********************************************************************************
* THE PRESENT SOFTWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
* WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE TIME.
* AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY DIRECT,
* INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING FROM THE
* CONTENT OF SUCH SOFTWARE AND/OR THE USE MADE BY CUSTOMERS OF THE CODING
* INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
*******************************************************************************/

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __STM32F10x_I2C_H
#define __STM32F10x_I2C_H

/* Includes ------------------------------------------------------------------*/
#include "stm32f10x_map.h"

/* Exported types ------------------------------------------------------------*/
/* I2C Init structure definition */
typedef struct
{
  uint16_t I2C_Mode;
  uint16_t I2C_DutyCycle;
  uint16_t I2C_OwnAddress1;
  uint16_t I2C_Ack;
  uint16_t I2C_AcknowledgedAddress;
  uint32_t I2C_ClockSpeed;
}I2C_InitTypeDef;

/* Exported constants --------------------------------------------------------*/
/* I2C modes */
#define I2C_Mode_I2C                    ((uint16_t)0x0000)
#define I2C_Mode_SMBusDevice            ((uint16_t)0x0002)
#define I2C_Mode_SMBusHost              ((uint16_t)0x000A)

#define IS_I2C_MODE(MODE) ((MODE == I2C_Mode_I2C) || \
                           (MODE == I2C_Mode_SMBusDevice) || \
                           (MODE == I2C_Mode_SMBusHost))
/* I2C duty cycle in fast mode */
#define I2C_DutyCycle_16_9              ((uint16_t)0x4000)
#define I2C_DutyCycle_2                 ((uint16_t)0xBFFF)

#define IS_I2C_DUTY_CYCLE(CYCLE) ((CYCLE == I2C_DutyCycle_16_9) || \
                                  (CYCLE == I2C_DutyCycle_2))

/* I2C cknowledgementy */
#define I2C_Ack_Enable                  ((uint16_t)0x0400)
#define I2C_Ack_Disable                 ((uint16_t)0x0000)

#define IS_I2C_ACK_STATE(STATE) ((STATE == I2C_Ack_Enable) || \
                                 (STATE == I2C_Ack_Disable))

/* I2C transfer direction */
#define  I2C_Direction_Transmitter      ((uint8_t)0x00)
#define  I2C_Direction_Receiver         ((uint8_t)0x01)

#define IS_I2C_DIRECTION(DIRECTION) ((DIRECTION == I2C_Direction_Transmitter) || \
                                     (DIRECTION == I2C_Direction_Receiver))

/* I2C acknowledged address defines */
#define I2C_AcknowledgedAddress_7bit    ((uint16_t)0x4000)
#define I2C_AcknowledgedAddress_10bit   ((uint16_t)0xC000)

#define IS_I2C_ACKNOWLEDGE_ADDRESS(ADDRESS) ((ADDRESS == I2C_AcknowledgedAddress_7bit) || \
                                             (ADDRESS == I2C_AcknowledgedAddress_10bit))

/* I2C registers */
#define I2C_Register_CR1                ((uint8_t)0x00)
#define I2C_Register_CR2                ((uint8_t)0x04)
#define I2C_Register_OAR1               ((uint8_t)0x08)
#define I2C_Register_OAR2               ((uint8_t)0x0C)
#define I2C_Register_DR                 ((uint8_t)0x10)
#define I2C_Register_SR1                ((uint8_t)0x14)
#define I2C_Register_SR2                ((uint8_t)0x18)
#define I2C_Register_CCR                ((uint8_t)0x1C)
#define I2C_Register_TRISE              ((uint8_t)0x20)

#define IS_I2C_REGISTER(REGISTER) ((REGISTER == I2C_Register_CR1) || \
                                   (REGISTER == I2C_Register_CR2) || \
                                   (REGISTER == I2C_Register_OAR1) || \
                                   (REGISTER == I2C_Register_OAR2) || \
                                   (REGISTER == I2C_Register_DR) || \
                                   (REGISTER == I2C_Register_SR1) || \
                                   (REGISTER == I2C_Register_SR2) || \
                                   (REGISTER == I2C_Register_CCR) || \
                                   (REGISTER == I2C_Register_TRISE))

/* I2C SMBus alert pin level */
#define I2C_SMBusAlert_Low              ((uint16_t)0x2000)
#define I2C_SMBusAlert_High             ((uint16_t)0xCFFF)

#define IS_I2C_SMBUS_ALERT(ALERT) ((ALERT == I2C_SMBusAlert_Low) || \
                                   (ALERT == I2C_SMBusAlert_High))

/* I2C PEC position */
#define I2C_PECPosition_Next            ((uint16_t)0x0800)
#define I2C_PECPosition_Current         ((uint16_t)0xF7FF)

#define IS_I2C_PEC_POSITION(POSITION) ((POSITION == I2C_PECPosition_Next) || \
                                       (POSITION == I2C_PECPosition_Current))

/* I2C interrupts definition */
#define I2C_IT_BUF                      ((uint16_t)0x0400)
#define I2C_IT_EVT                      ((uint16_t)0x0200)
#define I2C_IT_ERR                      ((uint16_t)0x0100)

#define IS_I2C_CONFIG_IT(IT) (((IT & (uint16_t)0xF8FF) == 0x00) && (IT != 0x00))

/* I2C interrupts definition */
#define I2C_IT_SMBALERT                 ((uint32_t)0x10008000)
#define I2C_IT_TIMEOUT                  ((uint32_t)0x10004000)
#define I2C_IT_PECERR                   ((uint32_t)0x10001000)
#define I2C_IT_OVR                      ((uint32_t)0x10000800)
#define I2C_IT_AF                       ((uint32_t)0x10000400)
#define I2C_IT_ARLO                     ((uint32_t)0x10000200)
#define I2C_IT_BERR                     ((uint32_t)0x10000100)
#define I2C_IT_TXE                      ((uint32_t)0x00000080)
#define I2C_IT_RXNE                     ((uint32_t)0x00000040)
#define I2C_IT_STOPF                    ((uint32_t)0x60000010)
#define I2C_IT_ADD10                    ((uint32_t)0x20000008)
#define I2C_IT_BTF                      ((uint32_t)0x60000004)
#define I2C_IT_ADDR                     ((uint32_t)0xA0000002)
#define I2C_IT_SB                       ((uint32_t)0x20000001)

#define IS_I2C_CLEAR_IT(IT) ((IT == I2C_IT_SMBALERT) || (IT == I2C_IT_TIMEOUT) || \
                             (IT == I2C_IT_PECERR) || (IT == I2C_IT_OVR) || \
                             (IT == I2C_IT_AF) || (IT == I2C_IT_ARLO) || \
                             (IT == I2C_IT_BERR) || (IT == I2C_IT_STOPF) || \
                             (IT == I2C_IT_ADD10) || (IT == I2C_IT_BTF) || \
                             (IT == I2C_IT_ADDR) || (IT == I2C_IT_SB))

#define IS_I2C_GET_IT(IT) ((IT == I2C_IT_SMBALERT) || (IT == I2C_IT_TIMEOUT) || \
                           (IT == I2C_IT_PECERR) || (IT == I2C_IT_OVR) || \
                           (IT == I2C_IT_AF) || (IT == I2C_IT_ARLO) || \
                           (IT == I2C_IT_BERR) || (IT == I2C_IT_TXE) || \
                           (IT == I2C_IT_RXNE) || (IT == I2C_IT_STOPF) || \
                           (IT == I2C_IT_ADD10) || (IT == I2C_IT_BTF) || \
                           (IT == I2C_IT_ADDR) || (IT == I2C_IT_SB))

/* I2C flags definition */
#define I2C_FLAG_DUALF                  ((uint32_t)0x00800000)
#define I2C_FLAG_SMBHOST                ((uint32_t)0x00400000)
#define I2C_FLAG_SMBDEFAULT             ((uint32_t)0x00200000)
#define I2C_FLAG_GENCALL                ((uint32_t)0x00100000)
#define I2C_FLAG_TRA                    ((uint32_t)0x00040000)
#define I2C_FLAG_BUSY                   ((uint32_t)0x00020000)
#define I2C_FLAG_MSL                    ((uint32_t)0x00010000)
#define I2C_FLAG_SMBALERT               ((uint32_t)0x10008000)
#define I2C_FLAG_TIMEOUT                ((uint32_t)0x10004000)
#define I2C_FLAG_PECERR                 ((uint32_t)0x10001000)
#define I2C_FLAG_OVR                    ((uint32_t)0x10000800)
#define I2C_FLAG_AF                     ((uint32_t)0x10000400)
#define I2C_FLAG_ARLO                   ((uint32_t)0x10000200)
#define I2C_FLAG_BERR                   ((uint32_t)0x10000100)
#define I2C_FLAG_TXE                    ((uint32_t)0x00000080)
#define I2C_FLAG_RXNE                   ((uint32_t)0x00000040)
#define I2C_FLAG_STOPF                  ((uint32_t)0x60000010)
#define I2C_FLAG_ADD10                  ((uint32_t)0x20000008)
#define I2C_FLAG_BTF                    ((uint32_t)0x60000004)
#define I2C_FLAG_ADDR                   ((uint32_t)0xA0000002)
#define I2C_FLAG_SB                     ((uint32_t)0x20000001)

#define IS_I2C_CLEAR_FLAG(FLAG) ((FLAG == I2C_FLAG_SMBALERT) || (FLAG == I2C_FLAG_TIMEOUT) || \
                                 (FLAG == I2C_FLAG_PECERR) || (FLAG == I2C_FLAG_OVR) || \
                                 (FLAG == I2C_FLAG_AF) || (FLAG == I2C_FLAG_ARLO) || \
                                 (FLAG == I2C_FLAG_BERR) || (FLAG == I2C_FLAG_STOPF) || \
                                 (FLAG == I2C_FLAG_ADD10) || (FLAG == I2C_FLAG_BTF) || \
                                 (FLAG == I2C_FLAG_ADDR) || (FLAG == I2C_FLAG_SB))

#define IS_I2C_GET_FLAG(FLAG) ((FLAG == I2C_FLAG_DUALF) || (FLAG == I2C_FLAG_SMBHOST) || \
                               (FLAG == I2C_FLAG_SMBDEFAULT) || (FLAG == I2C_FLAG_GENCALL) || \
                               (FLAG == I2C_FLAG_TRA) || (FLAG == I2C_FLAG_BUSY) || \
                               (FLAG == I2C_FLAG_MSL) || (FLAG == I2C_FLAG_SMBALERT) || \
                               (FLAG == I2C_FLAG_TIMEOUT) || (FLAG == I2C_FLAG_PECERR) || \
							   (FLAG == I2C_FLAG_OVR) || (FLAG == I2C_FLAG_AF) || \
							   (FLAG == I2C_FLAG_ARLO) || (FLAG == I2C_FLAG_BERR) || \
							   (FLAG == I2C_FLAG_TXE) || (FLAG == I2C_FLAG_RXNE) || \
							   (FLAG == I2C_FLAG_STOPF) || (FLAG == I2C_FLAG_ADD10) || \
							   (FLAG == I2C_FLAG_BTF) || (FLAG == I2C_FLAG_ADDR) || \
							   (FLAG == I2C_FLAG_SB))

/* I2C Events */
/* EV1 */
#define  I2C_EVENT_SLAVE_TRANSMITTER_ADDRESS_MATCHED ((uint32_t)0x00060082) /* TRA, BUSY, TXE and ADDR flags */
#define  I2C_EVENT_SLAVE_RECEIVER_ADDRESS_MATCHED  ((uint32_t)0x00020002) /* BUSY and ADDR flags */
#define  I2C_EVENT_SLAVE_TRANSMITTER_SECONDADDRESS_MATCHED ((uint32_t)0x00860080)  /* DUALF, TRA, BUSY and TXE flags */
#define  I2C_EVENT_SLAVE_RECEIVER_SECONDADDRESS_MATCHED ((uint32_t)0x00820000)  /* DUALF and BUSY flags */
#define  I2C_EVENT_SLAVE_GENERALCALLADDRESS_MATCHED ((uint32_t)0x00120000)  /* GENCALL and BUSY flags */

/* EV2 */
#define  I2C_EVENT_SLAVE_BYTE_RECEIVED  ((uint32_t)0x00020040)  /* BUSY and RXNE flags */
     
/* EV3 */
#define  I2C_EVENT_SLAVE_BYTE_TRANSMITTED  ((uint32_t)0x00060084)  /* TRA, BUSY, TXE and BTF flags */

/* EV4 */
#define  I2C_EVENT_SLAVE_STOP_DETECTED  ((uint32_t)0x00000010)  /* STOPF flag */

/* EV5 */
#define  I2C_EVENT_MASTER_MODE_SELECT  ((uint32_t)0x00030001)  /* BUSY, MSL and SB flag */

/* EV6 */
#define  I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED  ((uint32_t)0x00070082)  /* BUSY, MSL, ADDR, TXE and TRA flags */
#define  I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED  ((uint32_t)0x00030002)  /* BUSY, MSL and ADDR flags */

/* EV7 */
#define  I2C_EVENT_MASTER_BYTE_RECEIVED  ((uint32_t)0x00030040)  /* BUSY, MSL and RXNE flags */

/* EV8 */
#define  I2C_EVENT_MASTER_BYTE_TRANSMITTED  ((uint32_t)0x00070084)  /* TRA, BUSY, MSL, TXE and BTF flags */
      
/* EV9 */
#define  I2C_EVENT_MASTER_MODE_ADDRESS10  ((uint32_t)0x00030008)  /* BUSY, MSL and ADD10 flags */
                                          
/* EV3_1 */
#define  I2C_EVENT_SLAVE_ACK_FAILURE  ((uint32_t)0x00000400)  /* AF flag */

#define IS_I2C_EVENT(EVENT) ((EVENT == I2C_EVENT_SLAVE_TRANSMITTER_ADDRESS_MATCHED) || \
                             (EVENT == I2C_EVENT_SLAVE_RECEIVER_ADDRESS_MATCHED) || \
                             (EVENT == I2C_EVENT_SLAVE_TRANSMITTER_SECONDADDRESS_MATCHED) || \
                             (EVENT == I2C_EVENT_SLAVE_RECEIVER_SECONDADDRESS_MATCHED) || \
                             (EVENT == I2C_EVENT_SLAVE_GENERALCALLADDRESS_MATCHED) || \
                             (EVENT == I2C_EVENT_SLAVE_BYTE_RECEIVED) || \
                             (EVENT == (I2C_EVENT_SLAVE_BYTE_RECEIVED | I2C_FLAG_DUALF)) || \
                             (EVENT == (I2C_EVENT_SLAVE_BYTE_RECEIVED | I2C_FLAG_GENCALL)) || \
                             (EVENT == I2C_EVENT_SLAVE_BYTE_TRANSMITTED) || \
                             (EVENT == (I2C_EVENT_SLAVE_BYTE_TRANSMITTED | I2C_FLAG_DUALF)) || \
                             (EVENT == (I2C_EVENT_SLAVE_BYTE_TRANSMITTED | I2C_FLAG_GENCALL)) || \
                             (EVENT == I2C_EVENT_SLAVE_STOP_DETECTED) || \
                             (EVENT == I2C_EVENT_MASTER_MODE_SELECT) || \
                             (EVENT == I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED) || \
                             (EVENT == I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED) || \
                             (EVENT == I2C_EVENT_MASTER_BYTE_RECEIVED) || \
                             (EVENT == I2C_EVENT_MASTER_BYTE_TRANSMITTED) || \
                             (EVENT == I2C_EVENT_MASTER_MODE_ADDRESS10) || \
                             (EVENT == I2C_EVENT_SLAVE_ACK_FAILURE))

/* I2C own address1 -----------------------------------------------------------*/
#define IS_I2C_OWN_ADDRESS1(ADDRESS1) (ADDRESS1 <= 0x3FF)
/* I2C clock speed ------------------------------------------------------------*/
#define IS_I2C_CLOCK_SPEED(SPEED) ((SPEED >= 0x1) && (SPEED <= 400000))

/* Exported macro ------------------------------------------------------------*/
/* Exported functions ------------------------------------------------------- */
void I2C_DeInit(I2C_TypeDef* I2Cx);
void I2C_Init(I2C_TypeDef* I2Cx, I2C_InitTypeDef* I2C_InitStruct);
void I2C_StructInit(I2C_InitTypeDef* I2C_InitStruct);
void I2C_Cmd(I2C_TypeDef* I2Cx, FunctionalState NewState);
void I2C_DMACmd(I2C_TypeDef* I2Cx, FunctionalState NewState);
void I2C_DMALastTransferCmd(I2C_TypeDef* I2Cx, FunctionalState NewState);
void I2C_GenerateSTART(I2C_TypeDef* I2Cx, FunctionalState NewState);
void I2C_GenerateSTOP(I2C_TypeDef* I2Cx, FunctionalState NewState);
void I2C_AcknowledgeConfig(I2C_TypeDef* I2Cx, FunctionalState NewState);
void I2C_OwnAddress2Config(I2C_TypeDef* I2Cx, uint8_t Address);
void I2C_DualAddressCmd(I2C_TypeDef* I2Cx, FunctionalState NewState);
void I2C_GeneralCallCmd(I2C_TypeDef* I2Cx, FunctionalState NewState);
void I2C_ITConfig(I2C_TypeDef* I2Cx, uint16_t I2C_IT, FunctionalState NewState);
void I2C_SendData(I2C_TypeDef* I2Cx, uint8_t Data);
uint8_t I2C_ReceiveData(I2C_TypeDef* I2Cx);
void I2C_Send7bitAddress(I2C_TypeDef* I2Cx, uint8_t Address, uint8_t I2C_Direction);
uint16_t I2C_ReadRegister(I2C_TypeDef* I2Cx, uint8_t I2C_Register);
void I2C_SoftwareResetCmd(I2C_TypeDef* I2Cx, FunctionalState NewState);
void I2C_SMBusAlertConfig(I2C_TypeDef* I2Cx, uint16_t I2C_SMBusAlert);
void I2C_TransmitPEC(I2C_TypeDef* I2Cx, FunctionalState NewState);
void I2C_PECPositionConfig(I2C_TypeDef* I2Cx, uint16_t I2C_PECPosition);
void I2C_CalculatePEC(I2C_TypeDef* I2Cx, FunctionalState NewState);
uint8_t I2C_GetPEC(I2C_TypeDef* I2Cx);
void I2C_ARPCmd(I2C_TypeDef* I2Cx, FunctionalState NewState);
void I2C_StretchClockCmd(I2C_TypeDef* I2Cx, FunctionalState NewState);
void I2C_FastModeDutyCycleConfig(I2C_TypeDef* I2Cx, uint16_t I2C_DutyCycle);
uint32_t I2C_GetLastEvent(I2C_TypeDef* I2Cx);
ErrorStatus I2C_CheckEvent(I2C_TypeDef* I2Cx, uint32_t I2C_EVENT);
FlagStatus I2C_GetFlagStatus(I2C_TypeDef* I2Cx, uint32_t I2C_FLAG);
void I2C_ClearFlag(I2C_TypeDef* I2Cx, uint32_t I2C_FLAG);
ITStatus I2C_GetITStatus(I2C_TypeDef* I2Cx, uint32_t I2C_IT);
void I2C_ClearITPendingBit(I2C_TypeDef* I2Cx, uint32_t I2C_IT);

#endif /*__STM32F10x_I2C_H */

/******************* (C) COPYRIGHT 2007 STMicroelectronics *****END OF FILE****/
