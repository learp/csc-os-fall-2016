.data          # section declaration

hello_str: .asciz "Hello, "
	len = . - hello_str

str_name: .asciz "%s"
        str_len = 256

.extern scanf  # section declaration

.bss           # section declaration
    input: .space 256

.text          # section declaration
    .global _start

_start:

# invoke scanf
movq $str_name, %rdi
movq $input, %rsi
callq scanf

# Write Hello,
movq $1, %rax #  use the write syscall
movq $1, %rdi #  write to stdout
movq $hello_str, %rsi #  use string $hello_str
movq $len, %rdx #  write $len characters
syscall #  make syscall or call kernel

# do it again to write input
movq $1, %rax
movq $1, %rdi
movq $str_len, %rdx
movq $input, %rsi
syscall

movq $60, %rax  #  use the _exit syscall
movq $0, %rdi   #  error code 0
syscall         #  make syscall
