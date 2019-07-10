/* Linker Script for Simulation in CS523 */
/* Vassilis Papaefstathiou (papaef@ics.forth,gr) */

OUTPUT_ARCH(riscv)
/*OUTPUT_FORMAT("elf32-littleriscv")*/
/* required to correctly link newlib */
/*GROUP( -lc -lgloss -lgcc -lsupc++ )*/
ENTRY(_start)


MEMORY
{
  imem  : ORIGIN = 0x00000000, LENGTH = 16K
  dmem  : ORIGIN = 0x00008000, LENGTH = 16K
}

/* we define a 4KByte stack that starts at the end of dmem */
_stack_size     = 0x1000;
_stack_start    = ORIGIN(dmem) + LENGTH(dmem) - 8;
_stack_end      = ORIGIN(dmem) + LENGTH(dmem) - _stack_size;

/* text start address */
_text_start     = 0x100;
/* halt address */
_console_addr   = 0x40;
/* halt address */
_halt_addr      = 0x50;
/* cycle counter address */
_cycle_addr     = 0x60;

SECTIONS
{
    .text : {
      . = _text_start;
      KEEP(*(.text.init))
      *(.text .text.*)
    } > imem

    .data : {
      . = ALIGN(8);
      *(.srodata .srodata.*)
      *(.rodata .rodata.*)
      *(.sdata .sdata.*)
      *(.data .data.*)
      QUAD(0)
    } > dmem

    .bss : { 
      . = ALIGN(8);
      PROVIDE(_bss_start = .);
      *(.sbss .sbss.*)
      *(.bss .bss.*)
      PROVIDE(_bss_end = .);
    } > dmem

    /DISCARD/ : {
      *(.comment .comment.* .note .note.*)
      *(.riscv.attributes)
      *(.debug_*)
    }
}
