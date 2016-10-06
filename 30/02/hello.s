.section .data

    hello: .asciz "Hello, "
         lenh = . - hello

    name: .asciz "%s"
        # max len of name
        lenn = 256

.extern scanf

# static memory for name
.section .bss
    .lcomm input, 256

.section .text
    .global _start

_start:
    # call scanf
    movq $name, %rdi
    movq $input, %rsi
    callq scanf

    # write "Hello, "
    movq $1, %rax
    movq $1, %rdi
    movq $hello, %rsi
    movq $lenh, %rdx
    syscall

    # write input
    movq $1, %rax
    movq $1, %rdi
    movq $input, %rsi
    movq $lenn, %rdx
    syscall

    # exit
    movq $60, %rax
    movq $0, %rdi
    syscall
