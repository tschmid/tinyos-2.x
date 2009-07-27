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

void NmiHandler() __attribute__((weak, alias("DefaultHandler")));
void HardFaultHandler() __attribute__((weak, alias("DefaultHandler")));
void MpuFaultHandler() __attribute__((weak, alias("DefaultHandler")));
void BusFaultHandler() __attribute__((weak, alias("DefaultHandler")));
void UsageFaultHandler() __attribute__((weak, alias("DefaultHandler")));
void SVCallHandler() __attribute__((weak, alias("DefaultHandler")));
void DebugHandler() __attribute__((weak, alias("DefaultHandler")));
void PendSVHandler() __attribute__((weak, alias("DefaultHandler")));
void SysTickHandler() __attribute__((weak, alias("DefaultHandler")));
void SUPCIrqHandler() __attribute__((weak, alias("DefaultHandler")));
void RSTCIrqHandler() __attribute__((weak, alias("DefaultHandler")));
void RTCIrqHandler() __attribute__((weak, alias("DefaultHandler")));
void RTTIrqHandler() __attribute__((weak, alias("DefaultHandler")));
void WDTIrqHandler() __attribute__((weak, alias("DefaultHandler")));
void PMCIrqHandler() __attribute__((weak, alias("DefaultHandler")));
void EFC0IrqHandler() __attribute__((weak, alias("DefaultHandler")));
void EFC1IrqHandler() __attribute__((weak, alias("DefaultHandler")));
void DBGUIrqHandler() __attribute__((weak, alias("DefaultHandler")));
void HSMC4IrqHandler() __attribute__((weak, alias("DefaultHandler")));
void PIOAIrqHandler() __attribute__((weak, alias("DefaultHandler")));
void PIOBIrqHandler() __attribute__((weak, alias("DefaultHandler")));
void PIOCIrqHandler() __attribute__((weak, alias("DefaultHandler")));
void USART0IrqHandler() __attribute__((weak, alias("DefaultHandler")));
void USART1IrqHandler() __attribute__((weak, alias("DefaultHandler")));
void USART2IrqHandler() __attribute__((weak, alias("DefaultHandler")));
void USART3IrqHandler() __attribute__((weak, alias("DefaultHandler")));
void MCI0IrqHandler() __attribute__((weak, alias("DefaultHandler")));
void TWI0IrqHandler() __attribute__((weak, alias("DefaultHandler")));
void TWI1IrqHandler() __attribute__((weak, alias("DefaultHandler")));
void SPI0IrqHandler() __attribute__((weak, alias("DefaultHandler")));
void SSC0IrqHandler() __attribute__((weak, alias("DefaultHandler")));
void TC0IrqHandler() __attribute__((weak, alias("DefaultHandler")));
void TC1IrqHandler() __attribute__((weak, alias("DefaultHandler")));
void TC2IrqHandler() __attribute__((weak, alias("DefaultHandler")));
void PWMIrqHandler() __attribute__((weak, alias("DefaultHandler")));
void ADCC0IrqHandler() __attribute__((weak, alias("DefaultHandler")));
void ADCC1IrqHandler() __attribute__((weak, alias("DefaultHandler")));
void HDMAIrqHandler() __attribute__((weak, alias("DefaultHandler")));
void UDPDIrqHandler() __attribute__((weak, alias("DefaultHandler")));

__attribute__((section(".vectors"))) unsigned int *__vectors[] = {
	// Defined in AT91 ARM Cortex-M3 based Microcontrollers, SAM3U Series, Preliminary, p. 78
	// See also The Definitive Guide to the ARM Cortex-M3, p. 331
	&_estack,
	(unsigned int *) __init,
    (unsigned int *) NmiHandler,
    (unsigned int *) HardFaultHandler,
    (unsigned int *) MpuFaultHandler,
    (unsigned int *) BusFaultHandler,
	(unsigned int *) UsageFaultHandler,
	(unsigned int *) 0, // Reserved
	(unsigned int *) 0, // Reserved
	(unsigned int *) 0, // Reserved
	(unsigned int *) 0, // Reserved
	(unsigned int *) SVCallHandler,
	(unsigned int *) DebugHandler,
	(unsigned int *) 0, // Reserved
	(unsigned int *) PendSVHandler,
	(unsigned int *) SysTickHandler,
	// Defined by SAM3U-EK board
	// See at91lib/boards/at91sam3u-ek/board_cstartup_gnu.c
	(unsigned int *) SUPCIrqHandler,    // 0  SUPPLY CONTROLLER
	(unsigned int *) RSTCIrqHandler,    // 1  RESET CONTROLLER
	(unsigned int *) RTCIrqHandler,     // 2  REAL TIME CLOCK
	(unsigned int *) RTTIrqHandler,     // 3  REAL TIME TIMER
	(unsigned int *) WDTIrqHandler,     // 4  WATCHDOG TIMER
	(unsigned int *) PMCIrqHandler,     // 5  PMC
	(unsigned int *) EFC0IrqHandler,    // 6  EFC0
	(unsigned int *) EFC1IrqHandler,    // 7  EFC1
	(unsigned int *) DBGUIrqHandler,    // 8  DBGU
	(unsigned int *) HSMC4IrqHandler,   // 9  HSMC4
	(unsigned int *) PIOAIrqHandler,    // 10 Parallel IO Controller A
	(unsigned int *) PIOBIrqHandler,    // 11 Parallel IO Controller B
	(unsigned int *) PIOCIrqHandler,    // 12 Parallel IO Controller C
	(unsigned int *) USART0IrqHandler,  // 13 USART 0
	(unsigned int *) USART1IrqHandler,  // 14 USART 1
	(unsigned int *) USART2IrqHandler,  // 15 USART 2
	(unsigned int *) USART3IrqHandler,  // 16 USART 3
	(unsigned int *) MCI0IrqHandler,    // 17 Multimedia Card Interface
	(unsigned int *) TWI0IrqHandler,    // 18 TWI 0
	(unsigned int *) TWI1IrqHandler,    // 19 TWI 1
	(unsigned int *) SPI0IrqHandler,    // 20 Serial Peripheral Interface
	(unsigned int *) SSC0IrqHandler,    // 21 Serial Synchronous Controller 0
	(unsigned int *) TC0IrqHandler,     // 22 Timer Counter 0
	(unsigned int *) TC1IrqHandler,     // 23 Timer Counter 1
	(unsigned int *) TC2IrqHandler,     // 24 Timer Counter 2
	(unsigned int *) PWMIrqHandler,     // 25 Pulse Width Modulation Controller
	(unsigned int *) ADCC0IrqHandler,   // 26 ADC controller0
	(unsigned int *) ADCC1IrqHandler,   // 27 ADC controller1
	(unsigned int *) HDMAIrqHandler,    // 28 HDMA
	(unsigned int *) UDPDIrqHandler,    // 29 USB Device High Speed UDP_HS
	(unsigned int *) 0 // not used
};
