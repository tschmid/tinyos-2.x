/******************** (C) COPYRIGHT 2007 STMicroelectronics ********************
* File Name          : stm32f10x_flash.c
* Author             : MCD Application Team
* Version            : V1.0
* Date               : 10/08/2007
* Description        : This file provides all the FLASH firmware functions.
********************************************************************************
* THE PRESENT SOFTWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
* WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE TIME.
* AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY DIRECT,
* INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING FROM THE
* CONTENT OF SUCH SOFTWARE AND/OR THE USE MADE BY CUSTOMERS OF THE CODING
* INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
*******************************************************************************/

/* Includes ------------------------------------------------------------------*/
#include "stm32f10x_flash.h"

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Flash Access Control Register bits */
#define ACR_LATENCY_Mask         ((uint32_t)0x00000038)
#define ACR_HLFCYA_Mask          ((uint32_t)0xFFFFFFF7)
#define ACR_PRFTBE_Mask          ((uint32_t)0xFFFFFFEF)

#ifdef _FLASH_PROG
/* Flash Access Control Register bits */
#define ACR_PRFTBS_Mask          ((uint32_t)0x00000020) 

/* Flash Control Register bits */
#define CR_PG_Set                ((uint32_t)0x00000001)
#define CR_PG_Reset              ((uint32_t)0x00001FFE) 

#define CR_PER_Set               ((uint32_t)0x00000002)
#define CR_PER_Reset             ((uint32_t)0x00001FFD)

#define CR_MER_Set               ((uint32_t)0x00000004)
#define CR_MER_Reset             ((uint32_t)0x00001FFB)

#define CR_OPTPG_Set             ((uint32_t)0x00000010)
#define CR_OPTPG_Reset           ((uint32_t)0x00001FEF)

#define CR_OPTER_Set             ((uint32_t)0x00000020)
#define CR_OPTER_Reset           ((uint32_t)0x00001FDF)

#define CR_STRT_Set              ((uint32_t)0x00000040)
							 
#define CR_LOCK_Set              ((uint32_t)0x00000080)

/* FLASH Mask */
#define RDPRT_Mask               ((uint32_t)0x00000002)
#define WRP0_Mask                ((uint32_t)0x000000FF)
#define WRP1_Mask                ((uint32_t)0x0000FF00)
#define WRP2_Mask                ((uint32_t)0x00FF0000)
#define WRP3_Mask                ((uint32_t)0xFF000000)

/* FLASH Keys */
#define RDP_Key                  ((uint16_t)0x00A5)
#define FLASH_KEY1               ((uint32_t)0x45670123)
#define FLASH_KEY2               ((uint32_t)0xCDEF89AB)

/* Delay definition */   
#define EraseTimeout             ((uint32_t)0x00000FFF)
#define ProgramTimeout           ((uint32_t)0x0000000F)
#endif

/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
#ifdef _FLASH_PROG
static void delay(void);
#endif

/* Private functions ---------------------------------------------------------*/
/*******************************************************************************
* Function Name  : FLASH_SetLatency
* Description    : Sets the code latency value.
* Input          : - FLASH_Latency: specifies the FLASH Latency value.
*                    This parameter can be one of the following values:
*                       - FLASH_Latency_0: FLASH Zero Latency cycle
*                       - FLASH_Latency_1: FLASH One Latency cycle
*                       - FLASH_Latency_2: FLASH Two Latency cycles
* Output         : None
* Return         : None
*******************************************************************************/
void FLASH_SetLatency(uint32_t FLASH_Latency)
{
  /* Check the parameters */
  assert_param(IS_FLASH_LATENCY(FLASH_Latency));
  
  /* Sets the Latency value */
  FLASH->ACR &= ACR_LATENCY_Mask;
  FLASH->ACR |= FLASH_Latency;
}

/*******************************************************************************
* Function Name  : FLASH_HalfCycleAccessCmd
* Description    : Enables or disables the Half cycle flash access.
* Input          : - FLASH_HalfCycle: specifies the FLASH Half cycle Access mode.
*                    This parameter can be one of the following values:
*                       - FLASH_HalfCycleAccess_Enable: FLASH Half Cycle Enable
*                       - FLASH_HalfCycleAccess_Disable: FLASH Half Cycle Disable
* Output         : None
* Return         : None
*******************************************************************************/
void FLASH_HalfCycleAccessCmd(uint32_t FLASH_HalfCycleAccess)
{
  /* Check the parameters */
  assert_param(IS_FLASH_HALFCYCLEACCESS_STATE(FLASH_HalfCycleAccess));
  
  /* Enable or disable the Half cycle access */
  FLASH->ACR &= ACR_HLFCYA_Mask;
  FLASH->ACR |= FLASH_HalfCycleAccess;
}

/*******************************************************************************
* Function Name  : FLASH_PrefetchBufferCmd
* Description    : Enables or disables the Prefetch Buffer.
* Input          : - FLASH_PrefetchBuffer: specifies the Prefetch buffer status.
*                    This parameter can be one of the following values:
*                       - FLASH_PrefetchBuffer_Enable: FLASH Prefetch Buffer Enable
*                       - FLASH_PrefetchBuffer_Disable: FLASH Prefetch Buffer Disable
* Output         : None
* Return         : None
*******************************************************************************/
void FLASH_PrefetchBufferCmd(uint32_t FLASH_PrefetchBuffer)
{
  /* Check the parameters */
  assert_param(IS_FLASH_PREFETCHBUFFER_STATE(FLASH_PrefetchBuffer));
  
  /* Enable or disable the Prefetch Buffer */
  FLASH->ACR &= ACR_PRFTBE_Mask;
  FLASH->ACR |= FLASH_PrefetchBuffer;
}

#ifdef _FLASH_PROG
/*******************************************************************************
* Function Name  : FLASH_Unlock
* Description    : Unlocks the FLASH Program Erase Controller.
* Input          : None
* Output         : None
* Return         : None
*******************************************************************************/
void FLASH_Unlock(void)
{
  /* Authorize the FPEC Access */
  FLASH->KEYR = FLASH_KEY1;
  FLASH->KEYR = FLASH_KEY2;
}

/*******************************************************************************
* Function Name  : FLASH_Lock
* Description    : Locks the FLASH Program Erase Controller.
* Input          : None
* Output         : None
* Return         : None
*******************************************************************************/
void FLASH_Lock(void)
{
  /* Set the Lock Bit to lock the FPEC and the FCR */
  FLASH->CR |= CR_LOCK_Set;
}

/*******************************************************************************
* Function Name  : FLASH_ErasePage
* Description    : Erases a specified FLASH page.
* Input          : - Page_Address: The page address to be erased.
* Output         : None
* Return         : FLASH Status: The returned value can be: FLASH_BUSY, 
*                  FLASH_ERROR_PG or FLASH_ERROR_WRP or FLASH_COMPLETE or 
*                  FLASH_TIMEOUT.
*******************************************************************************/
FLASH_Status FLASH_ErasePage(uint32_t Page_Address)
{
  FLASH_Status status = FLASH_COMPLETE;

  /* Check the parameters */
  assert_param(IS_FLASH_ADDRESS(Page_Address));

  /* Wait for last operation to be completed */
  status = FLASH_WaitForLastOperation(EraseTimeout);
  
  if(status == FLASH_COMPLETE)
  { 
    /* if the previous operation is completed, proceed to erase the page */
    FLASH->CR|= CR_PER_Set;
    FLASH->AR = Page_Address; 
    FLASH->CR|= CR_STRT_Set;
    
    /* Wait for last operation to be completed */
    status = FLASH_WaitForLastOperation(EraseTimeout);

    if(status != FLASH_BUSY)
    {
      /* if the erase operation is completed, disable the PER Bit */
      FLASH->CR &= CR_PER_Reset;
    }
  }
  /* Return the Erase Status */
  return status;
}

/*******************************************************************************
* Function Name  : FLASH_EraseAllPages
* Description    : Erases all FLASH pages.
* Input          : None
* Output         : None
* Return         : FLASH Status: The returned value can be: FLASH_BUSY, 
*                  FLASH_ERROR_PG or FLASH_ERROR_WRP or FLASH_COMPLETE or 
*                  FLASH_TIMEOUT.
*******************************************************************************/
FLASH_Status FLASH_EraseAllPages(void)
{
  FLASH_Status status = FLASH_COMPLETE;

  /* Wait for last operation to be completed */
  status = FLASH_WaitForLastOperation(EraseTimeout);
  
  if(status == FLASH_COMPLETE)
  {
    /* if the previous operation is completed, proceed to erase all pages */
     FLASH->CR |= CR_MER_Set;
     FLASH->CR |= CR_STRT_Set;
    
    /* Wait for last operation to be completed */
    status = FLASH_WaitForLastOperation(EraseTimeout);

    if(status != FLASH_BUSY)
    {
      /* if the erase operation is completed, disable the MER Bit */
      FLASH->CR &= CR_MER_Reset;
    }
  }	   
  /* Return the Erase Status */
  return status;
}

/*******************************************************************************
* Function Name  : FLASH_EraseOptionBytes
* Description    : Erases the FLASH option bytes.
* Input          : None
* Output         : None
* Return         : FLASH Status: The returned value can be: FLASH_BUSY, 
*                  FLASH_ERROR_PG or FLASH_ERROR_WRP or FLASH_COMPLETE or 
*                  FLASH_TIMEOUT.
*******************************************************************************/
FLASH_Status FLASH_EraseOptionBytes(void)
{
  FLASH_Status status = FLASH_COMPLETE;
  
  /* Wait for last operation to be completed */
  status = FLASH_WaitForLastOperation(EraseTimeout);

  if(status == FLASH_COMPLETE)
  {
    /* Authorize the small information block programming */
    FLASH->OPTKEYR = FLASH_KEY1;
    FLASH->OPTKEYR = FLASH_KEY2;
    
    /* if the previous operation is completed, proceed to erase the option bytes */
    FLASH->CR |= CR_OPTER_Set;
    FLASH->CR |= CR_STRT_Set;

    /* Wait for last operation to be completed */
    status = FLASH_WaitForLastOperation(EraseTimeout);
    
    if(status == FLASH_COMPLETE)
    {
      /* if the erase operation is completed, disable the OPTER Bit */
      FLASH->CR &= CR_OPTER_Reset;
       
      /* Enable the Option Bytes Programming operation */
      FLASH->CR |= CR_OPTPG_Set;

      /* Enable the readout access */
      OB->RDP= RDP_Key; 

      /* Wait for last operation to be completed */
      status = FLASH_WaitForLastOperation(ProgramTimeout);
 
      if(status != FLASH_BUSY)
      {
        /* if the program operation is completed, disable the OPTPG Bit */
        FLASH->CR &= CR_OPTPG_Reset;
      }
    }
    else
    {
      if (status != FLASH_BUSY)
      {
        /* Disable the OPTPG Bit */
        FLASH->CR &= CR_OPTPG_Reset;
      }
    }  
  }
  /* Return the erase status */
  return status;
}

/*******************************************************************************
* Function Name  : FLASH_ProgramWord
* Description    : Programs a word at a specified address.
* Input          : - Address: specifies the address to be programmed.
*                  - Data: specifies the data to be programmed.
* Output         : None
* Return         : FLASH Status: The returned value can be: FLASH_BUSY, 
*                  FLASH_ERROR_PG or FLASH_ERROR_WRP or FLASH_COMPLETE or 
*                  FLASH_TIMEOUT. 
*******************************************************************************/
FLASH_Status FLASH_ProgramWord(uint32_t Address, uint32_t Data)
{
  FLASH_Status status = FLASH_COMPLETE;

  /* Check the parameters */
  assert_param(IS_FLASH_ADDRESS(Address));

  /* Wait for last operation to be completed */
  status = FLASH_WaitForLastOperation(ProgramTimeout);
  
  if(status == FLASH_COMPLETE)
  {
    /* if the previous operation is completed, proceed to program the new first 
    half word */
    FLASH->CR |= CR_PG_Set;
  
    *(vuint16_t*)Address = (uint16_t)Data;

    /* Wait for last operation to be completed */
    status = FLASH_WaitForLastOperation(ProgramTimeout);
 
    if(status == FLASH_COMPLETE)
    {
      /* if the previous operation is completed, proceed to program the new second 
      half word */
      *(vuint16_t*)(Address + 2) = Data >> 16;
    
      /* Wait for last operation to be completed */
      status = FLASH_WaitForLastOperation(ProgramTimeout);
        
      if(status != FLASH_BUSY)
      {
        /* Disable the PG Bit */
        FLASH->CR &= CR_PG_Reset;
      }
    }
    else
    {
      if (status != FLASH_BUSY)
      {
        /* Disable the PG Bit */
        FLASH->CR &= CR_PG_Reset;
      }
     }
  }
  /* Return the Program Status */
  return status;
}

/*******************************************************************************
* Function Name  : FLASH_ProgramHalfWord
* Description    : Programs a half word at a specified address.
* Input          : - Address: specifies the address to be programmed.
*                  - Data: specifies the data to be programmed.
* Output         : None
* Return         : FLASH Status: The returned value can be: FLASH_BUSY, 
*                  FLASH_ERROR_PG or FLASH_ERROR_WRP or FLASH_COMPLETE or 
*                  FLASH_TIMEOUT. 
*******************************************************************************/
FLASH_Status FLASH_ProgramHalfWord(uint32_t Address, uint16_t Data)
{
  FLASH_Status status = FLASH_COMPLETE;

  /* Check the parameters */
  assert_param(IS_FLASH_ADDRESS(Address));

  /* Wait for last operation to be completed */
  status = FLASH_WaitForLastOperation(ProgramTimeout);
  
  if(status == FLASH_COMPLETE)
  {
    /* if the previous operation is completed, proceed to program the new data */
    FLASH->CR |= CR_PG_Set;
  
    *(vuint16_t*)Address = Data;
    /* Wait for last operation to be completed */
    status = FLASH_WaitForLastOperation(ProgramTimeout);

    if(status != FLASH_BUSY)
    {
      /* if the program operation is completed, disable the PG Bit */
      FLASH->CR &= CR_PG_Reset;
    }
  } 
  /* Return the Program Status */
  return status;
}

/*******************************************************************************
* Function Name  : FLASH_ProgramOptionByteData
* Description    : Programs a half word at a specified Option Byte Data address.
* Input          : - Address: specifies the address to be programmed.
*                    This parameter can be 0x1FFFF804 or 0x1FFFF806. 
*                  - Data: specifies the data to be programmed.
* Output         : None
* Return         : FLASH Status: The returned value can be: FLASH_BUSY, 
*                  FLASH_ERROR_PG or FLASH_ERROR_WRP or FLASH_COMPLETE or 
*                  FLASH_TIMEOUT. 
*******************************************************************************/
FLASH_Status FLASH_ProgramOptionByteData(uint32_t Address, uint8_t Data)
{
  FLASH_Status status = FLASH_COMPLETE;

  /* Check the parameters */
  assert_param(IS_OB_DATA_ADDRESS(Address));

  status = FLASH_WaitForLastOperation(ProgramTimeout);

  if(status == FLASH_COMPLETE)
  {
    /* Authorize the small information block programming */
    FLASH->OPTKEYR = FLASH_KEY1;
    FLASH->OPTKEYR = FLASH_KEY2;

    /* Enables the Option Bytes Programming operation */
    FLASH->CR |= CR_OPTPG_Set; 
    *(vuint16_t*)Address = Data;
    
    /* Wait for last operation to be completed */
    status = FLASH_WaitForLastOperation(ProgramTimeout);

    if(status != FLASH_BUSY)
    {
      /* if the program operation is completed, disable the OPTPG Bit */
      FLASH->CR &= CR_OPTPG_Reset;
    }
  }    
  /* Return the Option Byte Data Program Status */
  return status;      
}

/*******************************************************************************
* Function Name  : FLASH_EnableWriteProtection
* Description    : Write protects the desired pages
* Input          : - FLASH_Pages: specifies the address of the pages to be 
*                    write protected. This parameter can be:
*                    - A value between FLASH_WRProt_Pages0to3 and 
*                      FLASH_WRProt_Pages124to127 
*                    - FLASH_WRProt_AllPages
* Output         : None
* Return         : FLASH Status: The returned value can be: FLASH_BUSY, 
*                  FLASH_ERROR_PG or FLASH_ERROR_WRP or FLASH_COMPLETE or 
*                  FLASH_TIMEOUT.
*******************************************************************************/
FLASH_Status FLASH_EnableWriteProtection(uint32_t FLASH_Pages)
{
  uint16_t WRP0_Data = 0xFFFF, WRP1_Data = 0xFFFF, WRP2_Data = 0xFFFF, WRP3_Data = 0xFFFF;
  
  FLASH_Status status = FLASH_COMPLETE;
  
  /* Check the parameters */
  assert_param(IS_FLASH_WRPROT_PAGE(FLASH_Pages));
  
  FLASH_Pages = (uint32_t)(~FLASH_Pages);
  WRP0_Data = (vuint16_t)(FLASH_Pages & WRP0_Mask);
  WRP1_Data = (vuint16_t)((FLASH_Pages & WRP1_Mask) >> 8);
  WRP2_Data = (vuint16_t)((FLASH_Pages & WRP2_Mask) >> 16);
  WRP3_Data = (vuint16_t)((FLASH_Pages & WRP3_Mask) >> 24);
  
  /* Wait for last operation to be completed */
  status = FLASH_WaitForLastOperation(ProgramTimeout);
  
  if(status == FLASH_COMPLETE)
  {
    /* Authorizes the small information block programming */
    FLASH->OPTKEYR = FLASH_KEY1;
    FLASH->OPTKEYR = FLASH_KEY2;
    FLASH->CR |= CR_OPTPG_Set;

    if(WRP0_Data != 0xFF)
    {
      OB->WRP0 = WRP0_Data;
      
      /* Wait for last operation to be completed */
      status = FLASH_WaitForLastOperation(ProgramTimeout);
    }
    if((status == FLASH_COMPLETE) && (WRP1_Data != 0xFF))
    {
      OB->WRP1 = WRP1_Data;
      
      /* Wait for last operation to be completed */
      status = FLASH_WaitForLastOperation(ProgramTimeout);
    }

    if((status == FLASH_COMPLETE) && (WRP2_Data != 0xFF))
    {
      OB->WRP2 = WRP2_Data;
      
      /* Wait for last operation to be completed */
      status = FLASH_WaitForLastOperation(ProgramTimeout);
    }
    
    if((status == FLASH_COMPLETE)&& (WRP3_Data != 0xFF))
    {
      OB->WRP3 = WRP3_Data;
     
      /* Wait for last operation to be completed */
      status = FLASH_WaitForLastOperation(ProgramTimeout);
    }
          
    if(status != FLASH_BUSY)
    {
      /* if the program operation is completed, disable the OPTPG Bit */
      FLASH->CR &= CR_OPTPG_Reset;
    }
  } 
  /* Return the write protection operation Status */
  return status;       
}

/*******************************************************************************
* Function Name  : FLASH_ReadOutProtection
* Description    : Enables or disables the read out protection.
*                  If the user has already programmed the other option bytes before 
*                  calling this function, he must re-program them since this 
*                  function erases all option bytes.
* Input          : - Newstate: new state of the ReadOut Protection.
*                    This parameter can be: ENABLE or DISABLE.
* Output         : None
* Return         : FLASH Status: The returned value can be: FLASH_BUSY, 
*                  FLASH_ERROR_PG or FLASH_ERROR_WRP or FLASH_COMPLETE or 
*                  FLASH_TIMEOUT.
*******************************************************************************/
FLASH_Status FLASH_ReadOutProtection(FunctionalState NewState)
{
  FLASH_Status status = FLASH_COMPLETE;

  /* Check the parameters */
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  status = FLASH_WaitForLastOperation(EraseTimeout);

  if(status == FLASH_COMPLETE)
  {
    /* Authorizes the small information block programming */
    FLASH->OPTKEYR = FLASH_KEY1;
    FLASH->OPTKEYR = FLASH_KEY2;

    FLASH->CR |= CR_OPTER_Set;
    FLASH->CR |= CR_STRT_Set;

    /* Wait for last operation to be completed */
    status = FLASH_WaitForLastOperation(EraseTimeout);

    if(status == FLASH_COMPLETE)
    {
      /* if the erase operation is completed, disable the OPTER Bit */
      FLASH->CR &= CR_OPTER_Reset;

      /* Enable the Option Bytes Programming operation */
      FLASH->CR |= CR_OPTPG_Set; 

      if(NewState != DISABLE)
      {
        OB->RDP = 0x00;
      }
      else
      {
        OB->RDP = RDP_Key;  
      }

      /* Wait for last operation to be completed */
      status = FLASH_WaitForLastOperation(EraseTimeout); 
    
      if(status != FLASH_BUSY)
      {
        /* if the program operation is completed, disable the OPTPG Bit */
        FLASH->CR &= CR_OPTPG_Reset;
      }
    }
    else 
    {
      if(status != FLASH_BUSY)
      {
        /* Disable the OPTER Bit */
        FLASH->CR &= CR_OPTER_Reset;
      }
    }
  }
  /* Return the protection operation Status */
  return status;      
}
  	
/*******************************************************************************
* Function Name  : FLASH_UserOptionByteConfig
* Description    : Programs the FLASH User Option Byte: IWDG_SW / RST_STOP /
*                  RST_STDBY.
* Input          : - OB_IWDG: Selects the IWDG mode
*                     This parameter can be one of the following values:
*                     - OB_IWDG_SW: Software IWDG selected
*                     - OB_IWDG_HW: Hardware IWDG selected
*                  - OB_STOP: Reset event when entering STOP mode.
*                     This parameter can be one of the following values:
*                     - OB_STOP_NoRST: No reset generated when entering in STOP
*                     - OB_STOP_RST: Reset generated when entering in STOP
*                  - OB_STDBY: Reset event when entering Standby mode.
*                    This parameter can be one of the following values:
*                     - OB_STDBY_NoRST: No reset generated when entering in STANDBY
*                     - OB_STDBY_RST: Reset generated when entering in STANDBY
* Output         : None
* Return         : FLASH Status: The returned value can be: FLASH_BUSY, 
*                  FLASH_ERROR_PG or FLASH_ERROR_WRP or FLASH_COMPLETE or 
*                  FLASH_TIMEOUT.
*******************************************************************************/
FLASH_Status FLASH_UserOptionByteConfig(uint16_t OB_IWDG, uint16_t OB_STOP, uint16_t OB_STDBY)
{
  FLASH_Status status = FLASH_COMPLETE; 

  /* Check the parameters */
  assert_param(IS_OB_IWDG_SOURCE(OB_IWDG));
  assert_param(IS_OB_STOP_SOURCE(OB_STOP));
  assert_param(IS_OB_STDBY_SOURCE(OB_STDBY));

  /* Authorize the small information block programming */
  FLASH->OPTKEYR = FLASH_KEY1;
  FLASH->OPTKEYR = FLASH_KEY2;
  
  /* Wait for last operation to be completed */
  status = FLASH_WaitForLastOperation(ProgramTimeout);
  
  if(status == FLASH_COMPLETE)
  {  
    /* Enable the Option Bytes Programming operation */
    FLASH->CR |= CR_OPTPG_Set; 
           
    OB->USER = ( OB_IWDG | OB_STOP |OB_STDBY) | (uint16_t)0xF8; 
  
    /* Wait for last operation to be completed */
    status = FLASH_WaitForLastOperation(ProgramTimeout);

    if(status != FLASH_BUSY)
    {
      /* if the program operation is completed, disable the OPTPG Bit */
      FLASH->CR &= CR_OPTPG_Reset;
    }
  }    
  /* Return the Option Byte program Status */
  return status;
}

/*******************************************************************************
* Function Name  : FLASH_GetUserOptionByte
* Description    : Returns the FLASH User Option Bytes values.
* Input          : None
* Output         : None
* Return         : The FLASH User Option Bytes values:IWDG_SW(Bit0), RST_STOP(Bit1)
*                  and RST_STDBY(Bit2).
*******************************************************************************/
uint32_t FLASH_GetUserOptionByte(void)
{
  /* Return the User Option Byte */
  return (uint32_t)(FLASH->OBR >> 2);
}

/*******************************************************************************
* Function Name  : FLASH_GetWriteProtectionOptionByte
* Description    : Returns the FLASH Write Protection Option Bytes Register value.
* Input          : None
* Output         : None
* Return         : The FLASH Write Protection  Option Bytes Register value
*******************************************************************************/
uint32_t FLASH_GetWriteProtectionOptionByte(void)
{
  /* Return the Falsh write protection Register value */
  return (uint32_t)(FLASH->WRPR);
}

/*******************************************************************************
* Function Name  : FLASH_GetReadOutProtectionStatus
* Description    : Checks whether the FLASH Read Out Protection Status is set 
*                  or not.
* Input          : None
* Output         : None
* Return         : FLASH ReadOut Protection Status(SET or RESET)
*******************************************************************************/
FlagStatus FLASH_GetReadOutProtectionStatus(void)
{
  FlagStatus readoutstatus = RESET;

  if ((FLASH->OBR & RDPRT_Mask) != (uint32_t)RESET)
  {
    readoutstatus = SET;
  }
  else
  {
    readoutstatus = RESET;
  }
  return readoutstatus;
}

/*******************************************************************************
* Function Name  : FLASH_GetPrefetchBufferStatus
* Description    : Checks whether the FLASH Prefetch Buffer status is set or not.
* Input          : None
* Output         : None
* Return         : FLASH Prefetch Buffer Status (SET or RESET).
*******************************************************************************/
FlagStatus FLASH_GetPrefetchBufferStatus(void)
{
  FlagStatus bitstatus = RESET;
  
  if ((FLASH->ACR & ACR_PRFTBS_Mask) != (uint32_t)RESET)
  {
    bitstatus = SET;
  }
  else
  {
    bitstatus = RESET;
  }
  /* Return the new state of FLASH Prefetch Buffer Status (SET or RESET) */
  return bitstatus; 
}

/*******************************************************************************
* Function Name  : FLASH_ITConfig
* Description    : Enables or disables the specified FLASH interrupts.
* Input          : - FLASH_IT: specifies the FLASH interrupt sources to be 
*                    enabled or disabled.
*                    This parameter can be any combination of the following values:
*                       - FLASH_IT_ERROR: FLASH Error Interrupt
*                       - FLASH_IT_EOP: FLASH end of operation Interrupt
* Output         : None
* Return         : None 
*******************************************************************************/
void FLASH_ITConfig(uint16_t FLASH_IT, FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_FLASH_IT(FLASH_IT)); 
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if(NewState != DISABLE)
  {
    /* Enable the interrupt sources */
    FLASH->CR |= FLASH_IT;
  }
  else
  {
    /* Disable the interrupt sources */
    FLASH->CR &= ~(uint32_t)FLASH_IT;
  }
}

/*******************************************************************************
* Function Name  : FLASH_GetFlagStatus
* Description    : Checks whether the specified FLASH flag is set or not.
* Input          : - FLASH_FLAG: specifies the FLASH flag to check.
*                     This parameter can be one of the following values:
*                    - FLASH_FLAG_BSY: FLASH Busy flag           
*                    - FLASH_FLAG_PGERR: FLASH Program error flag       
*                    - FLASH_FLAG_WRPRTERR: FLASH Write protected error flag      
*                    - FLASH_FLAG_EOP: FLASH End of Operation flag           
*                    - FLASH_FLAG_OPTERR:  FLASH Option Byte error flag     
* Output         : None
* Return         : The new state of FLASH_FLAG (SET or RESET).
*******************************************************************************/
FlagStatus FLASH_GetFlagStatus(uint16_t FLASH_FLAG)
{
  FlagStatus bitstatus = RESET;

  /* Check the parameters */
  assert_param(IS_FLASH_GET_FLAG(FLASH_FLAG)) ;

  if(FLASH_FLAG == FLASH_FLAG_OPTERR) 
  {
    if((FLASH->OBR & FLASH_FLAG_OPTERR) != (uint32_t)RESET)
    {
      bitstatus = SET;
    }
    else
    {
      bitstatus = RESET;
    }
  }
  else
  {
   if((FLASH->SR & FLASH_FLAG) != (uint32_t)RESET)
    {
      bitstatus = SET;
    }
    else
    {
      bitstatus = RESET;
    }
  }
  /* Return the new state of FLASH_FLAG (SET or RESET) */
  return bitstatus;
}

/*******************************************************************************
* Function Name  : FLASH_ClearFlag
* Description    : Clears the FLASH’s pending flags.
* Input          : - FLASH_FLAG: specifies the FLASH flags to clear.
*                    This parameter can be any combination of the following values:
*                    - FLASH_FLAG_BSY: FLASH Busy flag           
*                    - FLASH_FLAG_PGERR: FLASH Program error flag       
*                    - FLASH_FLAG_WRPRTERR: FLASH Write protected error flag      
*                    - FLASH_FLAG_EOP: FLASH End of Operation flag           
* Output         : None
* Return         : None
*******************************************************************************/
void FLASH_ClearFlag(uint16_t FLASH_FLAG)
{
  /* Check the parameters */
  assert_param(IS_FLASH_CLEAR_FLAG(FLASH_FLAG)) ;
  
  /* Clear the flags */
  FLASH->SR = FLASH_FLAG;
}

/*******************************************************************************
* Function Name  : FLASH_GetStatus
* Description    : Returns the FLASH Status.
* Input          : None
* Output         : None
* Return         : FLASH Status: The returned value can be: FLASH_BUSY, 
*                  FLASH_ERROR_PG or FLASH_ERROR_WRP or FLASH_COMPLETE
*******************************************************************************/
FLASH_Status FLASH_GetStatus(void)
{
  FLASH_Status flashstatus = FLASH_COMPLETE;
  
  if((FLASH->SR & FLASH_FLAG_BSY) == FLASH_FLAG_BSY) 
  {
    flashstatus = FLASH_BUSY;
  }
  else 
  {  
    if(FLASH->SR & FLASH_FLAG_PGERR)
    { 
      flashstatus = FLASH_ERROR_PG;
    }
    else 
    {
      if(FLASH->SR & FLASH_FLAG_WRPRTERR)
      {
        flashstatus = FLASH_ERROR_WRP;
      }
      else
      {
        flashstatus = FLASH_COMPLETE;
      }
    }
  }
  /* Return the Flash Status */
  return flashstatus;
}

/*******************************************************************************
* Function Name  : FLASH_WaitForLastOperation
* Description    : Waits for a Flash operation to complete or a TIMEOUT to occur.
* Input          : - Timeout: FLASH progamming Timeout
* Output         : None
* Return         : FLASH Status: The returned value can be: FLASH_BUSY, 
*                  FLASH_ERROR_PG or FLASH_ERROR_WRP or FLASH_COMPLETE or 
*                  FLASH_TIMEOUT.
*******************************************************************************/
FLASH_Status FLASH_WaitForLastOperation(uint32_t Timeout)
{ 
  FLASH_Status status = FLASH_COMPLETE;
   
  /* Check for the Flash Status */
  status = FLASH_GetStatus();

  /* Wait for a Flash operation to complete or a TIMEOUT to occur */
  while((status == FLASH_BUSY) && (Timeout != 0x00))
  {
    delay();
    status = FLASH_GetStatus();
    Timeout--;
  }

  if(Timeout == 0x00 )
  {
    status = FLASH_TIMEOUT;
  }

  /* Return the operation status */
  return status;
}

/*******************************************************************************
* Function Name  : delay
* Description    : Inserts a time delay.
* Input          : None
* Output         : None
* Return         : None
*******************************************************************************/
static void delay(void)
{
  volatile uint32_t i = 0;

  for(i = 0xFF; i != 0; i--)
  {
  }
}
#endif

/******************* (C) COPYRIGHT 2007 STMicroelectronics *****END OF FILE****/
