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
        GPIO_TypeDef* port = (GPIO_TypeDef*)port_addr;
        // this depends on the mode
        if(call IO.isInput())
            return (port->IDR >> bit) & 0x01;
        else
            return (port->ODR >> bit) & 0x01;
    }
    inline async command void IO.set() { 
        GPIO_TypeDef* port = (GPIO_TypeDef*)port_addr;
        *PERIPHERAL_BIT(port->ODR, bit) = 1;
        //port->BSRR = 1 << (bit << 1);
    }

    inline async command void IO.clr() {
        GPIO_TypeDef* port = (GPIO_TypeDef*)port_addr;
        *PERIPHERAL_BIT(port->ODR, bit) = 0;
        //port->BRR = 1 << bit;
    }
    async command void IO.toggle() {
        GPIO_TypeDef* port = (GPIO_TypeDef*)port_addr;
        // toggle only makes sense in output mode
        // if the bit is set, then reset through the BSRR, if it is reset,
        // then set it.
        *PERIPHERAL_BIT(port->ODR, bit) ^= 1;
        //port->BSRR = 1 << (bit << ((port->ODR >> bit) & 0x01)); 
    }

    inline async command void IO.makeInput()  {
        GPIO_TypeDef* port = (GPIO_TypeDef*)port_addr;
    }

    inline async command bool IO.isInput() {
        GPIO_TypeDef* port = (GPIO_TypeDef*)port_addr;

        GPIO_InitTypeDef gpioi = {
            (uint16_t) 1 << bit, // select the pin
            GPIO_Speed_10MHz,
            GPIO_Mode_IN_FLOATING
        };
        GPIO_Init(port, &gpioi);
    }

    inline async command void IO.makeOutput() {
        GPIO_TypeDef* port = (GPIO_TypeDef*)port_addr;

        GPIO_InitTypeDef gpioi = {
            (uint16_t) 1 << bit, // select the pin
            GPIO_Speed_10MHz,
            GPIO_Mode_Out_PP
        };
        GPIO_Init(port, &gpioi);
    }

    inline async command bool IO.isOutput() {
        GPIO_TypeDef* port = (GPIO_TypeDef*)port_addr;
        // MODEx == 0 is input... everything else is output
        if(bit < 8)
        {
            return ((port->CRL&(0x03<<(bit<<2))) > 0);
        } else {
            return ((port->CRH&(0x03<<((bit-8)<<2))) > 0);
        }
    }
}

