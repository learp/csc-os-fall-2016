.data

hello_str:
        .asciz "Hello, "
        length = . - hello_str

line_end:
        .asciz "\n"

format:
        .asciz "%s"

.set    bufer_size, 1024

.bss

input:
        .space bufer_size

.text

.global main

prepare_to_print:
        movq    $1, %rax
        movq    $1, %rdi
        ret

print_hello:
        callq   prepare_to_print
        movq    $hello_str, %rsi
        movq    $length, %rdx
        syscall
        ret

print_input:
        callq   prepare_to_print
        movq    $input, %rsi
        movq    $bufer_size, %rdx
        syscall
        ret

print_line_end:
        callq   prepare_to_print
        movq    $line_end, %rsi
        movq    $1, %rdx
        syscall
        ret

main:
        movq $format, %rdi
        movq $input, %rsi
        callq scanf

        callq print_hello
        callq print_input
        callq print_line_end

        movq    $60, %rax
        xorq    %rdi, %rdi
        syscall
