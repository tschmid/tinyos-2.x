OUTPUT_FORMAT ("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
ENTRY(_start)

GROUP(libvectors-stm32.a)

MEMORY
{
  ram (rwx) : ORIGIN = 0x20000000, LENGTH = 20K
  rom (rx) : ORIGIN = 0x00000000, LENGTH = 128K
}

EXTERN(__reset_stm32)
INCLUDE stm32-names.inc
EXTERN(__interrupt_vector_stm32)
EXTERN(main)
EXTERN(_start)

PROVIDE(__stack = __region_start_ram + __region_size_ram);

SECTIONS
  {
	.  = 0x0;          /* From 0x00000000 */
    .text : {
        __region_start_rom = .;
        *(.tinyos.interrupt_vector)      /* Vector table */
            ASSERT (. != __interrupt_vector_stm32, "No interrupt vector");
        PROVIDE(__reset_stm32 = _start);
        __reset = __reset_stm32;
        *(.tinyos.reset)

        *(.text .text.* .gnu.linonce.t.*)        /* Program code */
        *(.plt)
        *(.gnu.warning)
        *(.glue_7t) *(.glue_7) *(.vfp11_veneer)

        *(.rodata .rodata.* .gnu.linkonce.r.*)

        *(.ARM.extab* .gnu.linkonce.armextab.*)
        *(.gcc_except_table)
        *(.eh_frame_hdr)
        *(.eh_frame)

        __regions = .;
    } >rom
    /*.  = 0x20000000;   /* From 0x20000000 */      

  /* .ARM.exidx is sorted, so has to go in its own output section.  */
  __exidx_start = .;
  .ARM.exidx :
  {
    *(.ARM.exidx* .gnu.linkonce.armexidx.*)
  } >rom
  __exidx_end = .;
  .text.align :
  {
    . = ALIGN(8);
    _etext = .;
  } >rom


    __region_end_rom = __region_start_rom + LENGTH(rom);
    __region_size_rom = LENGTH(rom);

    .data : {
        __region_start_ram = .;
    *(.data)        /* Data memory */
    } >ram AT > rom 
  .bss : {
    *(.bss)         /* Zero-filled run time allocate data memory */
    } >ram AT > rom

    __region_end_ram = __region_start_ram + LENGTH(ram);
    __region_size_ram = LENGTH(ram);
  }  
/*========== end of file ==========*/
