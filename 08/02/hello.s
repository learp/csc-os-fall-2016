.data
  prefix: .asciz "Hello, "
    len_p = . - prefix

  name_p: .asciz "%s"
    len_n = 256

.extern scanf

.bss
  .lcomm input,256

.text
  .globl _start

_start:
  # perform scanf
  movq $name_p,%rdi
  movq $input,%rsi
  call scanf

  # print first part
  movq $1,%rax
  movq $1,%rdi
  movq $prefix,%rsi
  movq $len_p,%rdx
  syscall

  # print name
  movq $1,%rax
  movq $1,%rdi
  movq $input,%rsi
  movq $len_n,%rdx
  syscall

  # exit
  movq $60,%rax
  movq $0,%rdi
  syscall

