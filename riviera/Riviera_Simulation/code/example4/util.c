
void _putchar(char);
void _exit_loop(void);

unsigned __stack_chk_guard = 0xdeadbeef;

void _puts(char * s){
  while (*s != '\0') {
    _putchar(*s++);
  }
}

void __attribute__((noreturn))  __stack_chk_fail(void)
{
  _puts("Stack overflow! Halting\n");
  _exit_loop();
}
