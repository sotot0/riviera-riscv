#  RISC-V INITIALIZATION FILE FOR CS523
.section .text.init
.global _start
.type _start, @function

_start:
  # initialize stack-pointer to end of data memory
  la sp, _stack_start
  # jump to main
  jal main
  nop

.global _exit_loop
.type _exit_loop, @function
#upon return from main go to an infinite loop 
_exit_loop:
  la t1, _halt_addr
  sw a0, 0(t1)
  j _exit_loop
  nop
  nop
  nop
  nop
  nop

.global _putchar
.type _putchar, @function
_putchar:
  la t1, _console_addr
  sb a0, 0(t1)
  ret
  nop

.global _getcycle
.type _getcycle, @function
_getcycle:
  la t1, _cycle_addr
  lw a0, 0(t1)
  ret
  nop
