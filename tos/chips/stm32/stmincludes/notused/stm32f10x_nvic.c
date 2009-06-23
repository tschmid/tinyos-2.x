/******************** (C) COPYRIGHT 2007 STMicroelectronics ********************
* File Name          : stm32f10x_nvic.c
* Author             : MCD Application Team
* Date First Issued  : 09/29/2006
* Description        : This file provides all the NVIC firmware functions.
********************************************************************************
* History:
* 04/02/2007: V0.2
* 02/05/2007: V0.1
* 09/29/2006: V0.01
********************************************************************************
* THE PRESENT SOFTWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
* WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE TIME.
* AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY DIRECT,
* INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING FROM THE
* CONTENT OF SUCH SOFTWARE AND/OR THE USE MADE BY CUSTOMERS OF THE CODING
* INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
*******************************************************************************/

/* Includes ------------------------------------------------------------------*/
#include "stm32f10x_nvic.h"

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
#define AIRC_VECTKEY_MASK    ((uint32_t)0x05FA0000)

/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/

/*******************************************************************************
* Function Name  : NVIC_DeInit
* Description    : Deinitializes the NVIC peripheral registers to their default
*                  reset values.
* Input          : None
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_DeInit(void)
{
  uint32_t index = 0;
  
  NVIC->Disable[0] = 0xFFFFFFFF;
  NVIC->Disable[1] = 0x000007FF;
  NVIC->Clear[0] = 0xFFFFFFFF;
  NVIC->Clear[1] = 0x000007FF;
  
  for(index = 0; index < 0x0B; index++)
  {
     NVIC->Priority[index] = 0x00000000;
  } 
}

/*******************************************************************************
* Function Name  : NVIC_SCBDeInit
* Description    : Deinitializes the SCB peripheral registers to their default 
*                  reset values.
* Input          : None
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_SCBDeInit(void)
{
  uint32_t index = 0x00;
  
  SCB->IRQControlState = 0x0A000000;
  SCB->ExceptionTableOffset = 0x00000000;
  SCB->AIRC = AIRC_VECTKEY_MASK;
  SCB->SysCtrl = 0x00000000;
  SCB->ConfigCtrl = 0x00000000;
  for(index = 0; index < 0x03; index++)
  {
     SCB->SystemPriority[index] = 0;
  }
  SCB->SysHandlerCtrl = 0x00000000;
  SCB->ConfigFaultStatus = 0xFFFFFFFF;
  SCB->HardFaultStatus = 0xFFFFFFFF;
  SCB->DebugFaultStatus = 0xFFFFFFFF;
}

/*******************************************************************************
* Function Name  : NVIC_PriorityGroupConfig
* Description    : Configures the priority grouping: pre-emption priority
*                  and subpriority.
* Input          : - NVIC_PriorityGroup: specifies the priority grouping bits
*                    length. This parameter can be one of the following values:
*                       - NVIC_PriorityGroup_0: 0 bits for pre-emption priority
*                         4 bits for subpriority
*                       - NVIC_PriorityGroup_1: 1 bits for pre-emption priority
*                         3 bits for subpriority
*                       - NVIC_PriorityGroup_2: 2 bits for pre-emption priority
*                         2 bits for subpriority
*                       - NVIC_PriorityGroup_3: 3 bits for pre-emption priority
*                         1 bits for subpriority
*                       - NVIC_PriorityGroup_4: 4 bits for pre-emption priority
*                         0 bits for subpriority
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_PriorityGroupConfig(uint32_t NVIC_PriorityGroup)
{
  /* Check the parameters */
  assert(IS_NVIC_PRIORITY_GROUP(NVIC_PriorityGroup));
  
  /* Set the PRIGROUP[10:8] bits according to NVIC_PriorityGroup value */
  SCB->AIRC = AIRC_VECTKEY_MASK | NVIC_PriorityGroup;
}

/*******************************************************************************
* Function Name  : NVIC_Init
* Description    : Initializes the NVIC peripheral according to the specified
*                  parameters in the NVIC_InitStruct.
* Input          : - NVIC_InitStruct: pointer to a NVIC_InitTypeDef structure
*                    that contains the configuration information for the
*                    specified NVIC peripheral.
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_Init(NVIC_InitTypeDef* NVIC_InitStruct)
{
  uint32_t tmppriority = 0x00, tmpreg = 0x00, tmpmask = 0x00;
  uint32_t tmppre = 0, tmpsub = 0x0F;

  /* Check the parameters */
  assert(IS_FUNCTIONAL_STATE(NVIC_InitStruct->NVIC_IRQChannelCmd));
  assert(IS_NVIC_IRQ_CHANNEL(NVIC_InitStruct->NVIC_IRQChannel));
  assert(IS_NVIC_PREEMPTION_PRIORITY(NVIC_InitStruct->NVIC_IRQChannelPreemptionPriority));  
  assert(IS_NVIC_SUB_PRIORITY(NVIC_InitStruct->NVIC_IRQChannelSubPriority));
    
  if (NVIC_InitStruct->NVIC_IRQChannelCmd != DISABLE)
  {
    /* Compute the Corresponding IRQ Priority --------------------------------*/    
    tmppriority = (0x700 - (SCB->AIRC & (uint32_t)0x700))>> 0x08;
    tmppre = (0x4 - tmppriority);
    tmpsub = tmpsub >> tmppriority;
    
    tmppriority = (uint32_t)NVIC_InitStruct->NVIC_IRQChannelPreemptionPriority << tmppre;
    tmppriority |=  NVIC_InitStruct->NVIC_IRQChannelSubPriority & tmpsub;

    tmppriority = tmppriority << 0x04;
    tmppriority = ((uint32_t)tmppriority) << ((NVIC_InitStruct->NVIC_IRQChannel & (uint8_t)0x03) * 0x08);
    
    tmpreg = NVIC->Priority[(NVIC_InitStruct->NVIC_IRQChannel >> 0x02)];
    tmpmask = (uint32_t)0xFF << ((NVIC_InitStruct->NVIC_IRQChannel & (uint8_t)0x03) * 0x08);
    tmpreg &= ~tmpmask;
    tmppriority &= tmpmask;  
    tmpreg |= tmppriority;

    NVIC->Priority[(NVIC_InitStruct->NVIC_IRQChannel >> 0x02)] = tmpreg;
    
    /* Enable the Selected IRQ Channels --------------------------------------*/
    NVIC->Enable[(NVIC_InitStruct->NVIC_IRQChannel >> 0x05)] =
      (uint32_t)0x01 << (NVIC_InitStruct->NVIC_IRQChannel & (uint8_t)0x1F);
  }
  else
  {
    /* Disable the Selected IRQ Channels -------------------------------------*/
    NVIC->Disable[(NVIC_InitStruct->NVIC_IRQChannel >> 0x05)] =
      (uint32_t)0x01 << (NVIC_InitStruct->NVIC_IRQChannel & (uint8_t)0x1F);
  }
}

/*******************************************************************************
* Function Name  : NVIC_StructInit
* Description    : Fills each NVIC_InitStruct member with its default value.
* Input          : - NVIC_InitStruct: pointer to a NVIC_InitTypeDef structure which
*                    will be initialized.
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_StructInit(NVIC_InitTypeDef* NVIC_InitStruct)
{
  /* NVIC_InitStruct members default value */
  NVIC_InitStruct->NVIC_IRQChannel = 0x00;
  NVIC_InitStruct->NVIC_IRQChannelPreemptionPriority = 0x00;
  NVIC_InitStruct->NVIC_IRQChannelSubPriority = 0x00;
  NVIC_InitStruct->NVIC_IRQChannelCmd = DISABLE;
}

/*******************************************************************************
* Function Name  : NVIC_SETPRIMASK
* Description    : Enables the PRIMASK priority: Raises the execution priority to 0.
* Input          : None
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_SETPRIMASK(void)
{
  __SETPRIMASK();
}

/*******************************************************************************
* Function Name  : NVIC_RESETPRIMASK
* Description    : Disables the PRIMASK priority.
* Input          : None
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_RESETPRIMASK(void)
{
  __RESETPRIMASK();
}

/*******************************************************************************
* Function Name  : NVIC_SETFAULTMASK
* Description    : Enables the FAULTMASK priority: Raises the execution priority to -1.
* Input          : None
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_SETFAULTMASK(void)
{
  __SETFAULTMASK();
}

/*******************************************************************************
* Function Name  : NVIC_RESETFAULTMASK
* Description    : Disables the FAULTMASK priority.
* Input          : None
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_RESETFAULTMASK(void)
{
  __RESETFAULTMASK();
}

/*******************************************************************************
* Function Name  : NVIC_BASEPRICONFIG
* Description    : The execution priority can be changed from 15 (lowest 
                   configurable priority) to 1.
* Input          : None
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_BASEPRICONFIG(uint32_t NewPriority)
{
  /* Check the parameters */
  assert(IS_NVIC_BASE_PRI(NewPriority));
  
  __BASEPRICONFIG(NewPriority << 0x04);
}

/*******************************************************************************
* Function Name  : NVIC_GetBASEPRI
* Description    : Returns the BASEPRI mask value.
* Input          : None
* Output         : None
* Return         : BASEPRI register value
*******************************************************************************/
uint32_t NVIC_GetBASEPRI(void)
{
  return (__GetBASEPRI());
}

/*******************************************************************************
* Function Name  : NVIC_GetCurrentPendingIRQChannel
* Description    : Returns the current pending IRQ channel identifier.
* Input          : None
* Output         : None
* Return         : Pending IRQ Channel Identifier.
*******************************************************************************/
u16 NVIC_GetCurrentPendingIRQChannel(void)
{
  return ((u16)((SCB->IRQControlState & (uint32_t)0x003FF000) >> 0x0C));
}

/*******************************************************************************
* Function Name  : NVIC_GetIRQChannelPendingBitStatus
* Description    : Checks whether the specified IRQ Channel pending bit is set
*                  or not.
* Input          : - NVIC_IRQChannel: specifies the interrupt pending bit to check.
* Output         : None
* Return         : The new state of IRQ Channel pending bit(SET or RESET).
*******************************************************************************/
ITStatus NVIC_GetIRQChannelPendingBitStatus(uint8_t NVIC_IRQChannel)
{
  ITStatus pendingirqstatus = RESET;
  uint32_t tmp = 0x00;
  
  /* Check the parameters */
  assert(IS_NVIC_IRQ_CHANNEL(NVIC_IRQChannel));
  
  tmp = ((uint32_t)0x01 << (NVIC_IRQChannel & (u32)0x1F));

  if (((NVIC->Set[(NVIC_IRQChannel >> 0x05)]) & tmp) == tmp)
  {
    pendingirqstatus = SET;
  }
  else
  {
    pendingirqstatus = RESET;
  }
  return pendingirqstatus;
}

/*******************************************************************************
* Function Name  : NVIC_SetIRQChannelPendingBit
* Description    : Sets the NVIC’s interrupt pending bit.
* Input          : - NVIC_IRQChannel: specifies the interrupt pending bit to Set.
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_SetIRQChannelPendingBit(uint8_t NVIC_IRQChannel)
{
  /* Check the parameters */
  assert(IS_NVIC_IRQ_CHANNEL(NVIC_IRQChannel));
  
  *(uint32_t*)0xE000EF00 = (u32)NVIC_IRQChannel;
}

/*******************************************************************************
* Function Name  : NVIC_ClearIRQChannelPendingBit
* Description    : Clears the NVIC’s interrupt pending bit.
* Input          : - NVIC_IRQChannel: specifies the interrupt pending bit to clear.
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_ClearIRQChannelPendingBit(uint8_t NVIC_IRQChannel)
{
  /* Check the parameters */
  assert(IS_NVIC_IRQ_CHANNEL(NVIC_IRQChannel));
  
  NVIC->Clear[(NVIC_IRQChannel >> 0x05)] = (uint32_t)0x01 << (NVIC_IRQChannel & (u32)0x1F);
}

/*******************************************************************************
* Function Name  : NVIC_GetCurrentActiveHandler
* Description    : Returns the current active Handler (IRQ Channel and
*                  SystemHandler) identifier.
* Input          : None
* Output         : None
* Return         : Active Handler Identifier.
*******************************************************************************/
u16 NVIC_GetCurrentActiveHandler(void)
{
  return ((u16)(SCB->IRQControlState & (uint32_t)0x3FF));
}

/*******************************************************************************
* Function Name  : NVIC_GetIRQChannelActiveBitStatus
* Description    : Checks whether the specified IRQ Channel active bit is set
*                  or not.
* Input          : - NVIC_IRQChannel: specifies the interrupt active bit to check.
* Output         : None
* Return         : The new state of IRQ Channel active bit(SET or RESET).
*******************************************************************************/
ITStatus NVIC_GetIRQChannelActiveBitStatus(uint8_t NVIC_IRQChannel)
{
  ITStatus activeirqstatus = RESET;
  uint32_t tmp = 0x00;

  /* Check the parameters */
  assert(IS_NVIC_IRQ_CHANNEL(NVIC_IRQChannel));
  
  tmp = ((uint32_t)0x01 << (NVIC_IRQChannel & (u32)0x1F));

  if (((NVIC->Active[(NVIC_IRQChannel >> 0x05)]) & tmp) == tmp )
  {
    activeirqstatus = SET;
  }
  else
  {
    activeirqstatus = RESET;
  }
  return activeirqstatus;
}

/*******************************************************************************
* Function Name  : NVIC_GetCPUID
* Description    : Returns the ID number, the version number and the implementation
*                  details of the Cortex-M3 core.
* Input          : None
* Output         : None
* Return         : CPU ID.
*******************************************************************************/
uint32_t NVIC_GetCPUID(void)
{
  return (SCB->CPUID);
}

/*******************************************************************************
* Function Name  : NVIC_SetVectorTable
* Description    : Sets the vector table location and Offset.
* Input          : - NVIC_VectTab: specifies if the vector table is in RAM or
*                    code memory.
*                    This parameter can be one of the following values:
*                       - NVIC_VectTab_RAM
*                       - NVIC_VectTab_FLASH
*                  - Offset: Vector Table base offset field.
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_SetVectorTable(uint32_t NVIC_VectTab, u32 Offset)
{ 
  /* Check the parameters */
  assert(IS_NVIC_VECTTAB(NVIC_VectTab));
  assert(IS_NVIC_OFFSET(Offset));  
   
  SCB->ExceptionTableOffset = (((uint32_t)Offset << 0x07) & (u32)0x1FFFFF80);

  SCB->ExceptionTableOffset |= NVIC_VectTab;
}

/*******************************************************************************
* Function Name  : NVIC_GenerateSystemReset
* Description    : Generates a system reset.
* Input          : None
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_GenerateSystemReset(void)
{
  SCB->AIRC = AIRC_VECTKEY_MASK | (uint32_t)0x04;
}

/*******************************************************************************
* Function Name  : NVIC_GenerateCoreReset
* Description    : Generates a Core (Core + NVIC) reset.
* Input          : None
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_GenerateCoreReset(void)
{
  SCB->AIRC = AIRC_VECTKEY_MASK | (uint32_t)0x01;
}

/*******************************************************************************
* Function Name  : NVIC_SystemLPConfig
* Description    : Selects the condition for the system to enter low power mode.
* Input          : - LowPowerMode: Specifies the new mode for the system to enter
*                    low power mode.
*                    This parameter can be one of the following values:
*                       - NVIC_LP_SEVONPEND
*                       - NVIC_LP_SLEEPDEEP
*                       - NVIC_LP_SLEEPONEXIT
*                  - NewState: new state of LP condition.
*                    This parameter can be: ENABLE or DISABLE.
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_SystemLPConfig(uint8_t LowPowerMode, FunctionalState NewState)
{
  /* Check the parameters */
  assert(IS_NVIC_LP(LowPowerMode));
  assert(IS_FUNCTIONAL_STATE(NewState));  
  
  if (NewState != DISABLE)
  {
    SCB->SysCtrl |= LowPowerMode;
  }
  else
  {
    SCB->SysCtrl &= (uint32_t)(~(u32)LowPowerMode);
  }
}

/*******************************************************************************
* Function Name  : NVIC_SystemHandlerConfig
* Description    : Enables or disables the specified System Handlers.
* Input          : - SystemHandler: specifies the system handler to be enabled
*                    or disabled.
*                    This parameter can be one of the following values:
*                       - SystemHandler_MemoryManage
*                       - SystemHandler_BusFault
*                       - SystemHandler_UsageFault
*                  - NewState: new state of  specified System Handlers.
*                    This parameter can be: ENABLE or DISABLE.
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_SystemHandlerConfig(uint32_t SystemHandler, FunctionalState NewState)
{
  uint32_t tmpreg = 0x00;

  /* Check the parameters */
  assert(IS_CONFIG_SYSTEM_HANDLER(SystemHandler));
  assert(IS_FUNCTIONAL_STATE(NewState)); 
  
  tmpreg =  (uint32_t)0x01 << (SystemHandler & (u32)0x1F);

  if (NewState != DISABLE)
  {
    SCB->SysHandlerCtrl |= tmpreg;
  }
  else
  {
    SCB->SysHandlerCtrl &= ~tmpreg;
  }
}

/*******************************************************************************
* Function Name  : NVIC_SystemHandlerPriorityConfig
* Description    : Configures the specified System Handlers priority.
* Input          : - SystemHandler: specifies the system handler to be
*                    enabled or disabled.
*                    This parameter can be one of the following values:
*                       - SystemHandler_MemoryManage
*                       - SystemHandler_BusFault
*                       - SystemHandler_UsageFault
*                       - SystemHandler_SVCall
*                       - SystemHandler_DebugMonitor
*                       - SystemHandler_PSV
*                       - SystemHandler_SysTick
*                  - SystemHandlerPreemptionPriority: new priority group of the
*                    specified system handlers.
*                  - SystemHandlerSubPriority: new sub priority of the specified
*                    system handlers.
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_SystemHandlerPriorityConfig(uint32_t SystemHandler, uint8_t SystemHandlerPreemptionPriority,
                                      uint8_t SystemHandlerSubPriority)
{
  uint32_t tmp1 = 0x00, tmp2 = 0xFF, handlermask = 0x00;
  uint32_t tmppriority = 0x00;

  /* Check the parameters */
  assert(IS_PRIORITY_SYSTEM_HANDLER(SystemHandler));
  assert(IS_NVIC_PREEMPTION_PRIORITY(SystemHandlerPreemptionPriority));  
  assert(IS_NVIC_SUB_PRIORITY(SystemHandlerSubPriority));
    
  tmppriority = (0x700 - (SCB->AIRC & (uint32_t)0x700))>> 0x08;
  tmp1 = (0x4 - tmppriority);
  tmp2 = tmp2 >> tmppriority;
    
  tmppriority = (uint32_t)SystemHandlerPreemptionPriority << tmp1;
  tmppriority |=  SystemHandlerSubPriority & tmp2;

  tmppriority = tmppriority << 0x04;
  tmp1 = SystemHandler & (uint32_t)0xC0;
  tmp1 = tmp1 >> 0x06; 
  tmp2 = (SystemHandler >> 0x08) & (uint32_t)0x03;
  tmppriority = tmppriority << (tmp2 * 0x08);
  handlermask = (uint32_t)0xFF << (tmp2 * 0x08);
  
  SCB->SystemPriority[tmp1] &= ~handlermask;
  SCB->SystemPriority[tmp1] |= tmppriority;
}

/*******************************************************************************
* Function Name  : NVIC_GetSystemHandlerPendingBitStatus
* Description    : Checks whether the specified System handlers pending bit is
*                  set or not.
* Input          : - SystemHandler: specifies the system handler pending bit to
*                    check.
*                    This parameter can be one of the following values:
*                       - SystemHandler_MemoryManage
*                       - SystemHandler_BusFault
*                       - SystemHandler_SVCall
* Output         : None
* Return         : The new state of System Handler pending bit(SET or RESET).
*******************************************************************************/
ITStatus NVIC_GetSystemHandlerPendingBitStatus(uint32_t SystemHandler)
{
  ITStatus bitstatus  = RESET;
  uint32_t tmp = 0x00, tmppos = 0x00;

  /* Check the parameters */
  assert(IS_GET_PENDING_SYSTEM_HANDLER(SystemHandler));
  
  tmppos = (SystemHandler >> 0x0A);
  tmppos &= (uint32_t)0x0F;

  tmppos = (uint32_t)0x01 << tmppos;

  tmp = SCB->SysHandlerCtrl & tmppos;

  if (tmp == tmppos)
  {
    bitstatus = SET;
  }
  else
  {
    bitstatus = RESET;
  }
  return bitstatus;
}

/*******************************************************************************
* Function Name  : NVIC_SetSystemHandlerPendingBit
* Description    : Sets System Handler pending bit.
* Input          : - SystemHandler: specifies the system handler pending bit
*                    to be set.
*                    This parameter can be one of the following values:
*                       - SystemHandler_NMI
*                       - SystemHandler_PSV
*                       - SystemHandler_SysTick
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_SetSystemHandlerPendingBit(uint32_t SystemHandler)
{
  uint32_t tmp = 0x00;

  /* Check the parameters */
  assert(IS_SET_PENDING_SYSTEM_HANDLER(SystemHandler));
  
  /* Get the System Handler pending bit position */
  tmp = SystemHandler & (uint32_t)0x1F;
  /* Set the corresponding System Handler pending bit */
  SCB->IRQControlState |= ((uint32_t)0x01 << tmp);
}

/*******************************************************************************
* Function Name  : NVIC_ClearSystemHandlerPendingBit
* Description    : Clears System Handler pending bit.
* Input          : - SystemHandler: specifies the system handler pending bit to
*                    be clear.
*                    This parameter can be one of the following values:
*                       - SystemHandler_PSV
*                       - SystemHandler_SysTick
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_ClearSystemHandlerPendingBit(uint32_t SystemHandler)
{
  uint32_t tmp = 0x00;

  /* Check the parameters */
  assert(IS_CLEAR_SYSTEM_HANDLER(SystemHandler));
  
  /* Get the System Handler pending bit position */
  tmp = SystemHandler & (uint32_t)0x1F;
  /* Clear the corresponding System Handler pending bit */
  SCB->IRQControlState |= ((uint32_t)0x01 << (tmp - 0x01));
}

/*******************************************************************************
* Function Name  : NVIC_GetSystemHandlerActiveBitStatus
* Description    : Checks whether the specified System handlers active bit is
*                  set or not.
* Input          : - SystemHandler: specifies the system handler active bit to
*                    check.
*                    This parameter can be one of the following values:
*                       - SystemHandler_MemoryManage
*                       - SystemHandler_BusFault
*                       - SystemHandler_UsageFault
*                       - SystemHandler_SVCall
*                       - SystemHandler_DebugMonitor
*                       - SystemHandler_PSV
*                       - SystemHandler_SysTick
* Output         : None
* Return         : The new state of System Handler active bit(SET or RESET).
*******************************************************************************/
ITStatus NVIC_GetSystemHandlerActiveBitStatus(uint32_t SystemHandler)
{
  ITStatus bitstatus  = RESET;

  uint32_t tmp = 0x00, tmppos = 0x00;

  /* Check the parameters */
  assert(IS_GET_ACTIVE_SYSTEM_HANDLER(SystemHandler));
  
  tmppos = (SystemHandler >> 0x0E) & (uint32_t)0x0F;

  tmppos = (uint32_t)0x01 << tmppos;

  tmp = SCB->SysHandlerCtrl & tmppos;

  if (tmp == tmppos)
  {
    bitstatus = SET;
  }
  else
  {
    bitstatus = RESET;
  }
  return bitstatus;
}

/*******************************************************************************
* Function Name  : NVIC_GetFaultHandlerSources
* Description    : Returns the system fault handlers sources.
* Input          : - SystemHandler: specifies the system handler to get its fault
*                    sources.
*                    This parameter can be one of the following values:
*                       - SystemHandler_HardFault
*                       - SystemHandler_MemoryManage
*                       - SystemHandler_BusFault
*                       - SystemHandler_UsageFault
*                       - SystemHandler_DebugMonitor
* Output         : None
* Return         : Source of the fault handler.
*******************************************************************************/
uint32_t NVIC_GetFaultHandlerSources(u32 SystemHandler)
{
  uint32_t faultsources = 0x00;
  uint32_t tmpreg = 0x00, tmppos = 0x00;

  /* Check the parameters */
  assert(IS_FAULT_SOURCE_SYSTEM_HANDLER(SystemHandler));
  
  tmpreg = (SystemHandler >> 0x12) & (uint32_t)0x03;
  tmppos = (SystemHandler >> 0x14) & (uint32_t)0x03;

  if (tmpreg == 0x00)
  {
    faultsources = SCB->HardFaultStatus;
  }
  else if (tmpreg == 0x01)
  {
    faultsources = SCB->ConfigFaultStatus >> (tmppos * 0x08);
    if (tmppos != 0x02)
    {
      faultsources &= (uint32_t)0x0F;
    }
    else
    {
      faultsources &= (uint32_t)0xFF;
    }
  }
  else
  {
    faultsources = SCB->DebugFaultStatus;
  }
  return faultsources;
}

/*******************************************************************************
* Function Name  : NVIC_GetFaultAddress
* Description    : Returns the address of the location that generated a fault
*                  handler.
* Input          : - SystemHandler: specifies the system handler to get its
*                    fault address.
*                    This parameter can be one of the following values:
*                       - SystemHandler_MemoryManage
*                       - SystemHandler_BusFault
* Output         : None
* Return         : Fault address.
*******************************************************************************/
uint32_t NVIC_GetFaultAddress(u32 SystemHandler)
{
  uint32_t faultaddress = 0x00;
  uint32_t tmp = 0x00;

  /* Check the parameters */
  assert(IS_FAULT_ADDRESS_SYSTEM_HANDLER(SystemHandler));
  
  tmp = (SystemHandler >> 0x16) & (uint32_t)0x01;

  if (tmp == 0x00)
  {
    faultaddress = SCB->MemoryManageFaultAddr;
  }
  else
  {
    faultaddress = SCB->BusFaultAddr;
  }
  return faultaddress;
}

/******************* (C) COPYRIGHT 2007 STMicroelectronics *****END OF FILE****/
