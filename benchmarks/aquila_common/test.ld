/*======================================================================*/
/* Proxy kernel linker script                                           */
/*======================================================================*/
/* This is the linker script used when building the proxy kernel. */

/*----------------------------------------------------------------------*/
/* Setup                                                                */
/*----------------------------------------------------------------------*/

/* The OUTPUT_ARCH command specifies the machine architecture where the
   argument is one of the names used in the BFD library. More
   specifically one of the entires in bfd/cpu-mips.c */

OUTPUT_ARCH( "riscv" )
ENTRY(_start)

__heap_start = 0xA0000000;
__heap_size  = 0x10000000;
__stack_top  = 0xBFFFFFFF;

/*----------------------------------------------------------------------*/
/* Sections                                                             */
/*----------------------------------------------------------------------*/

MEMORY
{
    code_ram   (rx!rw) : ORIGIN = 0x80000000, LENGTH = 0x1000000
    data_ram   (rw!x)  : ORIGIN = 0x90000000, LENGTH = 0x1000000
}

SECTIONS
{

  /* text: test code section */
  . = 0x80000000;
  .text.init : {
      boot.o(.text)
      *(.text.init)
      . = ALIGN(0x1000);
      *(.text)
  } > code_ram



  /* data segment */
  .data : { *(.data) } > data_ram

  .sdata : {
    __global_pointer$ = . + 0x800;
    *(.srodata.cst16) *(.srodata.cst8) *(.srodata.cst4) *(.srodata.cst2) *(.srodata*)
    *(.sdata .sdata.* .gnu.linkonce.s.*)
  } > data_ram

  /* bss segment */
  .sbss : {
    *(.sbss .sbss.* .gnu.linkonce.sb.*)
    *(.scommon)
  } > data_ram
  .bss : { *(.bss) } > data_ram
  . = ALIGN(0x1000);
  .tohost : { *(.tohost) } > data_ram

  /* End of uninitalized data segement */
  _end = .;
}

