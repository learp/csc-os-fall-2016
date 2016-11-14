.code16
.global _start
.data 
	.word 0xaa55
.text 
	hello_str: .asciz "Hello, World!"
_start:
# clear interrupt and direction flags
	cli
	cld
# clear ax
	xorw %ax, %ax
# set to si the address of the hello_str's beginning
	movw $hello_str, %si
	
_print_loop:
# load the byte from the string to al
	lodsb
# check if the string ends
	or %al, %al
# stop the loop
	jz _end_print_loop
# print the letter
	movb $0x0e, %ah
	int $0x10
# continue the print_loop
	jmp _print_loop
# infinite loop of end
_end_print_loop:
	jmp _end_print_loop
