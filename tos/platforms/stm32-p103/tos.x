OUTPUT_FORMAT ("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")

GROUP(libvectors-stm32.a)

MEMORY
{
  ram (rwx) : ORIGIN = 0x20000000, LENGTH = 20K
  rom (rx) : ORIGIN = 0x00000000, LENGTH = 128K
}

SECTIONS
  {
    .  = 0x0;          /* From 0x00000000 */
    .text : {
    *(vectors)      /* Vector table */
    ASSERT(. != 0, "No interrupt vector");
        /* Program code */
    *(.text .text.* .gnu.linkonce.t.*)
    *(.plt)
    *(.gnu.warning)
    *(.glue_7t) *(.glue_7) *(.vfp11_veneer)


    *(.rodata .rodata.* .gnu.linonce.r.*)      /* Read only data */
    *(.ARM.extab* .gnu.linkonce.armextab.*)
    *(.gcc_except_table)
    *(.eh_frame_hdr)
    *(.eh_frame)

    } >rom

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


    .  = 0x20000000;   /* From 0x20000000 */
    .data : {
    *(.data .data.* .gnu.linonce.d.*)        /* Data memory */
    } >ram AT > rom
  .bss : {
    *(.bss)         /* Zero-filled run time allocate data memory */
    } >ram AT > rom
 }

/*========== end of file ==========*/
