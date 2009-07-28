generic module HplSam3uGeneralIOPinP(uint32_t pio_addr, uint8_t bit)
{
	provides interface GeneralIO as IO;
}
implementation
{
	async command bool IO.get()
	{
		if ((call IO.isInput()) == true) {
			/* Read bit from Pin Data Status Register */
			uint32_t currentport = *((uint32_t *) (pio_addr + 0x03c));
			uint32_t currentpin = (currentport & (1 << bit)) >> bit;
			return ((currentpin & 1) == 1);
		} else {
			/* Read bit from Output Data Status Register */
			uint32_t currentport = *((uint32_t *) (pio_addr + 0x038));
			uint32_t currentpin = (currentport & (1 << bit)) >> bit;
			return ((currentpin & 1) == 1);
	}

	async command void IO.set()
	{
		/* Set bit in Set Output Data Register */
		*((uint32_t *) (pio_addr + 0x030)) = (1 << bit);
	}

	async command void IO.clr()
	{
		/* Set bit in Clear Output Data Register */
		*((uint32_t *) (pio_addr + 0x034)) = (1 << bit);
	}

	async command void IO.toggle()
	{
		if ((call IO.get()) == true) {
			call IO.clr();
		} else {
			call IO.set();
		}
	}

    async command void IO.makeInput()  {
        GPIO_TypeDef* port = (GPIO_TypeDef*)port_addr;

        GPIO_InitTypeDef gpioi = {
            (uint16_t) 1 << bit, // select the pin
            GPIO_Speed_10MHz,
            GPIO_Mode_IN_FLOATING
        };
        GPIO_Init(port, &gpioi);
    }

	/*
    async command bool IO.isInput() {
       GPIO_TypeDef* port = (GPIO_TypeDef*)port_addr;
    }

    async command void IO.makeOutput() {
        GPIO_TypeDef* port = (GPIO_TypeDef*)port_addr;

        GPIO_InitTypeDef gpioi = {
            (uint16_t) 1 << bit, // select the pin
            GPIO_Speed_10MHz,
            GPIO_Mode_Out_PP
        };
        GPIO_Init(port, &gpioi);
    }

    async command bool IO.isOutput() {
        GPIO_TypeDef* port = (GPIO_TypeDef*)port_addr;
        // MODEx == 0 is input... everything else is output
        if(bit < 8)
        {
            return ((port->CRL&(0x03<<(bit<<2))) > 0);
        } else {
            return ((port->CRH&(0x03<<((bit-8)<<2))) > 0);
        }
    }
	*/
}
