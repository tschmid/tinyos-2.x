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

	// Call main()
	main();

	// "Exit"
	while (1);
}

#endif // HARDWARE_H
