#include "printf.h"

void overflow(void) {
  char buffer[2];
  strcpy(buffer, "Hello, I am smashing your stack!");
}


int main() {
  int i = 0;
 
  //printf("Overflow check!\n");
 
  overflow();
 
  return 0;
}
 
