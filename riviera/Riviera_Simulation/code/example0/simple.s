.global main
.type main, @function

main:
  addi x6, x0, 1
  addi x7, x0, 2
  add  x7, x6, x7
  add  x10, x7, x0
  ret
