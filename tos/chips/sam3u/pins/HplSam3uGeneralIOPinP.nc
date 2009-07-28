generic module HplSam3uGeneralIOPinP(uint32_t pio_addr, uint8_t bit)
{
	provides interface GeneralIO as IO;
}
implementation
{
	async command bool IO.get()
	{
		if ((call IO.isInput()) == 1) {
			/* Read bit from Pin Data Status Register */
			uint32_t currentport = *((volatile uint32_t *) (pio_addr + 0x03c));
			uint32_t currentpin = (currentport & (1 << bit)) >> bit;
			return ((currentpin & 1) == 1);
		} else {
			/* Read bit from Output Data Status Register */
			uint32_t currentport = *((volatile uint32_t *) (pio_addr + 0x038));
			uint32_t currentpin = (currentport & (1 << bit)) >> bit;
			return ((currentpin & 1) == 1);
		}
	}

	async command void IO.set()
	{
		/* Set bit in Set Output Data Register */
		*((volatile uint32_t *) (pio_addr + 0x030)) = (1 << bit);
	}

	async command void IO.clr()
	{
		/* Set bit in Clear Output Data Register */
		*((volatile uint32_t *) (pio_addr + 0x034)) = (1 << bit);
	}

	async command void IO.toggle()
	{
		if ((call IO.get()) == 1) {
			call IO.clr();
		} else {
			call IO.set();
		}
	}

	async command void IO.makeInput()
	{
		/* Set bit in Output Disable Register */
		*((volatile uint32_t *) (pio_addr + 0x014)) = (1 << bit);
    }

	async command void IO.makeOutput()
	{
		/* Set bit in Output Enable Register */
		*((volatile uint32_t *) (pio_addr + 0x010)) = (1 << bit);
    }

	async command bool IO.isOutput() {
		/* Read bit from Output Status Register */
		uint32_t currentport = *((volatile uint32_t *) (pio_addr + 0x018));
		uint32_t currentpin = (currentport & (1 << bit)) >> bit;
		return ((currentpin & 1) == 1);
	}

	async command bool IO.isInput() {
		return (! (call IO.isOutput()));
	}
}
