.data
	first:
	.asciz "hello, "
	firtstLength = . - first

	second:
        .asciz "%s"
        secondLength = 512


.bss
    input: .space 512

.text

    .global _start

_start:
    # read 
    movq $second, %rdi
    movq $input, %rsi
    call scanf 

    # write 
    movq $1, %rax
    movq $1, %rdi
    movq $first, %rsi
    movq $firtstLength, %rdx
    syscall

    movq $1, %rax
    movq $1, %rdi
    movq $input, %rsi
    movq $secondLength, %rdx
    syscall

    # exit
    movq $60, %rax
    movq $0, %rdi
    syscall