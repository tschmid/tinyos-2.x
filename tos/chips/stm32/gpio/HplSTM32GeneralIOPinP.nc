/*
*/

/**
 * Generic bit access for pins mapped into I/O space.
 *
 * TODO:
 *  - More configuration options for the IOs are possible, but
 *    currently not implemented.
 *
 * @author Thomas Schmid
 */
#include <stm32hardware.h>

generic module HplSTM32GeneralIOPinP (uint32_t port_addr, uint8_t bit) @safe()
{
    provides interface GeneralIO as IO;
}
implementation
{
    inline async command bool IO.get() {
        gpio_t* port = (gpio_t*)port_addr;
        // this depends on the mode
        if(call IO.isInput())
            return (port->IDR >> bit) & 0x01;
        else
            return (port->ODR >> bit) & 0x01;
    }
    inline async command void IO.set() { 
        gpio_t* port = (gpio_t*)port_addr;
        port->BSRR = 1 << (bit << 1);
    }

    inline async command void IO.clr() {
        gpio_t* port = (gpio_t*)port_addr;
        port->BRR = 1 << bit;
    }
    async command void IO.toggle() {
        gpio_t* port = (gpio_t*)port_addr;
        // toggle only makes sense in output mode
        // if the bit is set, then reset through the BSRR, if it is reset,
        // then set it.
        port->BSRR = 1 << (bit << ((port->ODR >> bit) & 0x01)); 
    }

    inline async command void IO.makeInput()  {
        gpio_t* port = (gpio_t*)port_addr;
        // currently we only support analog input mode
        if(bit < 8)
        {
            // clear the corresponding controle registers
            port->CRL &= ~(0x0F << ( bit << 2 ));
            // write the mode
            port->CRL |= (0 << ( bit << 2 ));
        } else {
            // clear the corresponding controle registers
            port->CRH &= ~(0x0F << ( (bit-8) << 2 ));
            // write the mode
            port->CRH |= (0 << ( (bit-8) << 2 ));
        }
    }
    inline async command bool IO.isInput() {
        gpio_t* port = (gpio_t*)port_addr;
        // MODEx == 0 is input... everything else is output
        if(bit < 8)
        {
            return ( ( port->CRL & (0x03 << (bit << 2) ) ) == 0);
        } else {
            return ( ( port->CRH & (0x03 << (( bit-8) << 2) ) ) == 0);
        }
    }
    inline async command void IO.makeOutput() {
        gpio_t* port = (gpio_t*)port_addr;
        // currently we only support general purpose output push-pull at 50MHz
        if(bit < 8)
        {
            // clear the corresponding controle registers
            port->CRL &= ~(0x0F << ( bit << 2 ));
            // write the mode
            port->CRL |= (0x0C << ( bit << 2 ));
        } else {
            // clear the corresponding controle registers
            port->CRH &= ~(0x0F << ( (bit-8) << 2 ));
            // write the mode
            port->CRH |= (0x0C << ( (bit-8) << 2 ));
        }
    }
    inline async command bool IO.isOutput() {
        gpio_t* port = (gpio_t*)port_addr;
        // MODEx == 0 is input... everything else is output
        if(bit < 8)
        {
            return ((port->CRL&(0x03<<(bit<<2))) > 0);
        } else {
            return ((port->CRH&(0x03<<((bit-8)<<2))) > 0);
        }
    }
}

