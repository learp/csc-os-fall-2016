.data

    hello_str: 
	.asciz "Hello, "
	hellol = . - hello_str

    name_str: 
	.asciz "%s"
        namel = 1024

.extern scanf

.bss
    input: .space 1024

.text
    .global _start

print_hello:
	movq $1, %rax
	movq $1, %rdi
	movq $hello_str, %rsi
	movq $hellol, %rdx
	syscall
	ret

print_name:	
	movq $1, %rax
	movq $1, %rdi
	movq $input, %rsi
	movq $namel, %rdx
	syscall
	ret

_start:
	movq $name_str, %rdi
	movq $input, %rsi
	callq scanf

	callq print_hello
	callq print_name
	
	movq $60, %rax
	movq $0, %rdi
	syscall
