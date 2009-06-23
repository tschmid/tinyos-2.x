    .text
#if defined(__thumb2__) || defined(__ARM_ARCH_6M__)
#define THUMB 1
    .code 16
    .thumb_func
#else
    .code 32
#endif
    .globl _start
    .type _start, %function
_start:
    .fnstart
#if THUMB
    ldr r1,=__stack
    mov sp,r1
    ldr r1,= main
    bx  r1
#else
    ldr sp,=__stack
    b  main
#endif
    .pool
    .cantunwind
    .fnend

