

#include "printf.h"

int k;
int H=39;
int main() {
  int a=1;
  int b=2;
  int c;

  int t1=0, t2=0;
  t1 = _getcycle();
  c= a+b;
  t2 = _getcycle();
  printf("c=a+b -> (a=%d, b=%d, c=%d)\n",a,b,c);
  printf("time = %d\n",t2-t1);
  H++;

  return c+H;
}
