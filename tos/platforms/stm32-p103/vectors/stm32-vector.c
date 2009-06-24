#define STACK_TOP 0x20000800
#define NVIC_CCR ((volatile unsigned long *)(0xE000ED14))
//Declarations
void HardFaultException(void);
void NMIException(void);
int main(void);

unsigned int * myvectors[4]
__attribute__ ((section("vectors")))= {
    (unsigned int *)    0x20000800, // stack pointer
    (unsigned int *)    main,       // code entry point
    (unsigned int *)    NMIException,        // NMI handler (not really)
    (unsigned int *)    HardFaultException       // hard fault handler (let's hope not)
};

