The library configuration file:

    stm32f10x_conf.h

must be placed in this directory.

From your project include this file:

    stm32fwlib.h

instead of this file:

    stm32f10x_lib.h

to gain c++ compatibility and some extras.
