#if defined(__thumb2__) || defined(__ARM_ARCH_6M__)
#define THUMB 1
    .thumb
    .thumb_func
#else
    .arm
#endif
    .section .tinyos.reset,"x",%progbits
    .globl __reset_stm32
    .type   __reset_stm32, %function
__reset_stm32:
    .fnstart
#if THUMB
    ldr r0,=_start
    bx  r0
#else
    b   _start
#endif
    .pool
    .cantunwind
    .fnend
    .size   __reset_stm32,.-__reset_stm32

