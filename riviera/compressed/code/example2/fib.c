#include "printf.h"

int fib(int n) {
  if (n == 0 || n == 1)
    return n;
  else
    return (fib(n-1) + fib(n-2));
}

#define N       10

int main() {
  int i = 0;
 
  printf("Fibonacci series terms are:\n");
 
  for (i = 1; i <= N; i++) {
    printf("fib(%d) = %d\n",i, fib(i));
  }

  //int j = fib(23);
   
  return 0;
}
 
