#ifndef HARDWARE_H
#define HARDWARE_H

#include "sam3uhardware.h"

/* Section symbols defined in linker script
 * sam3u-ek-flash.x
 */
extern unsigned int _stext;
extern unsigned int _etext;
extern unsigned int _sdata;
extern unsigned int _edata;
extern unsigned int _sbss;
extern unsigned int _ebss;
extern unsigned int _estack;

/* main() symbol defined in RealMainP
 */
int main();

volatile unsigned int *PIOB_BASE = (volatile unsigned int *) 0x400e0e00;
volatile unsigned int *PIOB_PER = (volatile unsigned int *) 0x400e0e00;
volatile unsigned int *PIOB_OER = (volatile unsigned int *) 0x400e0e10;
volatile unsigned int *PIOB_SODR = (volatile unsigned int *) 0x400e0e30;
volatile unsigned int *PIOB_CODR = (volatile unsigned int *) 0x400e0e34;
volatile unsigned int *PIOB_PUDR = (volatile unsigned int *) 0x400e0e60;
volatile unsigned int *PIOB_MDDR = (volatile unsigned int *) 0x400e0e54;

/* Start-up code to copy data into RAM
 * and zero BSS segment
 * and call main()
 * and "exit"
 */
void __init() @spontaneous()
{
	unsigned int *from;
	unsigned int *to;
	unsigned int *i;
	volatile int j;
	volatile unsigned int value = 0x0;

	// Copy pre-initialized data into RAM
	from = &_etext;
	to = &_sdata;
	while (to < &_edata) {
		*to = *from;
		to++;
		from++;
	}

	// Fill BSS data with 0
	i = &_sbss;
	while (i < &_ebss) {
		*i = 0;
		i++;
	}

	// FIXME
	// test GPIO and LEDs
	*PIOB_PUDR = 0x0007; // disable all pull-up resistors
	*PIOB_MDDR = 0x0007; // disable all multi-drives
	*PIOB_PER = 0x0007; // enable PB0 and PB1 and PB2 to be controlled by PIO controller
	*PIOB_OER = 0x0007; // enable PB0 and PB1 and PB2 to be driven by PIO controller
	*PIOB_SODR = 0x0000; // drive PB0-2 at low level
	*PIOB_CODR = 0x0007; // drive PB0-2 at low level

	while (1) {
		for (j = 0; j < 200000; j++);
		value++;
		value = value % 2;
		if (value == 0) {
			*PIOB_SODR = 0x0003;
			*PIOB_CODR = 0x0004;
		} else if (value == 1) {
			*PIOB_SODR = 0x0004;
			*PIOB_CODR = 0x0003;
		}
	}

	// Call main()
	main();

	// "Exit"
	while (1);
}

#endif // HARDWARE_H
