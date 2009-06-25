#define STACK_TOP 0x20005000
#define NVIC_CCR ((volatile unsigned long *)(0xE000ED14))
//Declarations
void HardFaultException(void);
void NMIException(void);
void MemManageException(void);
void BusFaultException(void);
void UsageFaultException(void);
void __STM32ReservedException7(void);
void __STM32ReservedException8(void);
void __STM32ReservedException9(void);
void __STM32ReservedException10(void);
void SVCHandler(void);
void DebugMonitor(void);
void __STM32ReservedException13(void);
void PendSVC(void);
void SysTickHandler(void);
void WWDG_IRQHandler(void);
void PVD_IRQHandler(void);
void TAMPER_IRQHandler(void);
void RTC_IRQHandler(void);
void FLASH_IRQHandler(void);
void RCC_IRQHandler(void);
void EXTI0_IRQHandler(void);
void EXTI1_IRQHandler(void);
void EXTI2_IRQHandler(void);
void EXTI3_IRQHandler(void);
void EXTI4_IRQHandler(void);
void DMAChannel1_IRQHandler(void);
void DMAChannel2_IRQHandler(void);
void DMAChannel3_IRQHandler(void);
void DMAChannel4_IRQHandler(void);
void DMAChannel5_IRQHandler(void);
void DMAChannel6_IRQHandler(void);
void DMAChannel7_IRQHandler(void);
void ADC_IRQHandler(void);
void USB_HP_CAN_TX_IRQHandler(void);
void USB_LP_CAN_RX0_IRQHandler(void);
void CAN_RX1_IRQHandler(void);
void CAN_SCE_IRQHandler(void);
void EXTI9_5_IRQHandler(void);
void TIM1_BRK_IRQHandler(void);
void TIM1_UP_IRQHandler(void);
void TIM1_TRG_COM_IRQHandler(void);
void TIM1_CC_IRQHandler(void);
void TIM2_IRQHandler(void);
void TIM3_IRQHandler(void);
void TIM4_IRQHandler(void);
void I2C1_EV_IRQHandler(void);
void I2C1_ER_IRQHandler(void);
void I2C2_EV_IRQHandler(void);
void I2C2_ER_IRQHandler(void);
void SPI1_IRQHandler(void);
void SPI2_IRQHandler(void);
void USART1_IRQHandler(void);
void USART2_IRQHandler(void);
void USART3_IRQHandler(void);
void EXTI15_10_IRQHandler(void);
void RTCAlarm_IRQHandler(void);
void USBWakeUp_IRQHandler(void);


int main(void);
void c_startup(void);

extern unsigned long _etext, _sdata, _edata, _sbss, _ebss;

unsigned int * myvectors[59]
__attribute__ ((section("vectors")))= {
    (unsigned int *)    STACK_TOP, // stack pointer
    (unsigned int *)    c_startup,       // code entry point
    (unsigned int *)    NMIException,        // NMI handler 
    (unsigned int *)    HardFaultException,       // hard fault handler 
    (unsigned int *)   MemManageException,
    (unsigned int *)   BusFaultException,
    (unsigned int *)   UsageFaultException,
    (unsigned int *)   __STM32ReservedException7,
    (unsigned int *)   __STM32ReservedException8,
    (unsigned int *)   __STM32ReservedException9,
    (unsigned int *)   __STM32ReservedException10,
    (unsigned int *)   SVCHandler,
    (unsigned int *)   DebugMonitor,
    (unsigned int *)   __STM32ReservedException13,
    (unsigned int *)   PendSVC,
    (unsigned int *)   SysTickHandler,
    (unsigned int *)   WWDG_IRQHandler,
    (unsigned int *)   PVD_IRQHandler,
    (unsigned int *)   TAMPER_IRQHandler,
    (unsigned int *)   RTC_IRQHandler,
    (unsigned int *)   FLASH_IRQHandler,
    (unsigned int *)   RCC_IRQHandler,
    (unsigned int *)   EXTI0_IRQHandler,
    (unsigned int *)   EXTI1_IRQHandler,
    (unsigned int *)   EXTI2_IRQHandler,
    (unsigned int *)   EXTI3_IRQHandler,
    (unsigned int *)   EXTI4_IRQHandler,
    (unsigned int *)   DMAChannel1_IRQHandler,
    (unsigned int *)   DMAChannel2_IRQHandler,
    (unsigned int *)   DMAChannel3_IRQHandler,
    (unsigned int *)   DMAChannel4_IRQHandler,
    (unsigned int *)   DMAChannel5_IRQHandler,
    (unsigned int *)   DMAChannel6_IRQHandler,
    (unsigned int *)   DMAChannel7_IRQHandler,
    (unsigned int *)   ADC_IRQHandler,
    (unsigned int *)   USB_HP_CAN_TX_IRQHandler,
    (unsigned int *)   USB_LP_CAN_RX0_IRQHandler,
    (unsigned int *)   CAN_RX1_IRQHandler,
    (unsigned int *)   CAN_SCE_IRQHandler,
    (unsigned int *)   EXTI9_5_IRQHandler,
    (unsigned int *)   TIM1_BRK_IRQHandler,
    (unsigned int *)   TIM1_UP_IRQHandler,
    (unsigned int *)   TIM1_TRG_COM_IRQHandler,
    (unsigned int *)   TIM1_CC_IRQHandler,
    (unsigned int *)   TIM2_IRQHandler,
    (unsigned int *)   TIM3_IRQHandler,
    (unsigned int *)   TIM4_IRQHandler,
    (unsigned int *)   I2C1_EV_IRQHandler,
    (unsigned int *)   I2C1_ER_IRQHandler,
    (unsigned int *)   I2C2_EV_IRQHandler,
    (unsigned int *)   I2C2_ER_IRQHandler,
    (unsigned int *)   SPI1_IRQHandler,
    (unsigned int *)   SPI2_IRQHandler,
    (unsigned int *)   USART1_IRQHandler,
    (unsigned int *)   USART2_IRQHandler,
    (unsigned int *)   USART3_IRQHandler,
    (unsigned int *)   EXTI15_10_IRQHandler,
    (unsigned int *)   RTCAlarm_IRQHandler,
    (unsigned int *)   USBWakeUp_IRQHandler
};

void c_startup(void)
{
    unsigned long *src, *dst;
             
    src = &_etext;
    dst = &_sdata;
    while(dst < &_edata) 
        *(dst++) = *(src++);

    src = &_sbss;
    while(src < &_ebss) 
        *(src++) = 0;
                                                     
    main();
}
