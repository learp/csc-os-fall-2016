.section .data

    hello: .asciz "Hello, "
         lenhello = . - hello

    name: .asciz "%s"
        # max len of name
        lenn = 256

.extern scanf


.section .bss
    .lcomm input, 256

.section .text
    .global _start


print_hello:
    movq $1, %rax
    movq $1, %rdi
    movq $hello, %rsi
    movq $lenhello, %rdx
    syscall

    movq $1, %rax
    movq $1, %rdi
    movq $input, %rsi
    movq $lenhello, %rdx
    syscall
    ret  
	

_start:
    movq $name, %rdi 
    movq $input, %rsi 
    callq scanf 

    call print_hello
    call exit			

exit:
    movl    $1, %eax  
    movl    $0, %ebx     
    int     $0x80         
