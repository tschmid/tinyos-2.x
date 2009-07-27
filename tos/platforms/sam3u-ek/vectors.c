extern unsigned int _estack;
extern void __init();

void DefaultHandler()
{
	// do nothing, just return
}

/* By default, every exception and IRQ is handled by the default handler.
 * The handler functions are provided by weak aliases; thus, a regular
 * handler definition will override this.
 */

void NmiHandler() __attribute__((weak, alias ("DefaultHandler")));
void HardFaultHandler() __attribute__((weak, alias ("DefaultHandler")));
void MpuFaultHandler() __attribute__((weak, alias ("DefaultHandler")));
void BusFaultHandler() __attribute__((weak, alias ("DefaultHandler")));

__attribute__((section(".vectors"))) unsigned int *__vectors[] = {
	// Defined by Cortex-M3
	&_estack,
	(unsigned int *) __init,
    (unsigned int *) NmiHandler,
    (unsigned int *) HardFaultHandler,
    (unsigned int *) MpuFaultHandler,
    (unsigned int *) BusFaultHandler,
//    UsageFault_Handler,
//    0, 0, 0, 0,             // Reserved
//    SVC_Handler,
//    DebugMon_Handler,
//    0,                      // Reserved
//    PendSV_Handler,
//    SysTick_Handler,
//    // Defined by board
//    SUPC_IrqHandler,    // 0  SUPPLY CONTROLLER
//    RSTC_IrqHandler,    // 1  RESET CONTROLLER
//    RTC_IrqHandler,     // 2  REAL TIME CLOCK
//    RTT_IrqHandler,     // 3  REAL TIME TIMER
//    WDT_IrqHandler,     // 4  WATCHDOG TIMER
//    PMC_IrqHandler,     // 5  PMC
//    EFC0_IrqHandler,    // 6  EFC0
//    EFC1_IrqHandler,    // 7  EFC1
//    DBGU_IrqHandler,    // 8  DBGU
//    HSMC4_IrqHandler,   // 9  HSMC4
//    PIOA_IrqHandler,    // 10 Parallel IO Controller A
//    PIOB_IrqHandler,    // 11 Parallel IO Controller B
//    PIOC_IrqHandler,    // 12 Parallel IO Controller C
//    USART0_IrqHandler,  // 13 USART 0
//    USART1_IrqHandler,  // 14 USART 1
//    USART2_IrqHandler,  // 15 USART 2
//    USART3_IrqHandler,  // 16 USART 3
//    MCI0_IrqHandler,    // 17 Multimedia Card Interface
//    TWI0_IrqHandler,    // 18 TWI 0
//    TWI1_IrqHandler,    // 19 TWI 1
//    SPI0_IrqHandler,    // 20 Serial Peripheral Interface
//    SSC0_IrqHandler,    // 21 Serial Synchronous Controller 0
//    TC0_IrqHandler,     // 22 Timer Counter 0
//    TC1_IrqHandler,     // 23 Timer Counter 1
//    TC2_IrqHandler,     // 24 Timer Counter 2
//    PWM_IrqHandler,     // 25 Pulse Width Modulation Controller
//    ADCC0_IrqHandler,   // 26 ADC controller0
//    ADCC1_IrqHandler,   // 27 ADC controller1
//    HDMA_IrqHandler,    // 28 HDMA
//    UDPD_IrqHandler,   // 29 USB Device High Speed UDP_HS
//    IrqHandlerNotUsed   // 30 not used
};
