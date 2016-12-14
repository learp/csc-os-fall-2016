.code16
# MBR number
.data
	.word 0xaa55
.global _start
.text
	hello_str: .asciz "Hello, World!"
_start:
# clear interrupt and direction flags
	cli
	cld
# set to si the address of the hello_str's beginning
	movw $hello_str, %si

# write video buffer address to ES:DI, DI should be 0 (first symbol on the console)
	movw $0xB800, %bx
	movw %bx, %es
	movw $0x00, %di	

# choose the letter's color (white)
	movb $0x07, %ah

_print_loop:
# load the byte from the string to al
	lodsb
# check if the string ends
	or %al, %al
# stop the loop
	jz _clear_to_the_end

# print the letter (al contains the letter and ah contains the color)
	stosw
# continue the print_loop
	jmp _print_loop

_clear_to_the_end:

# write the empty symbol to ax
	movw $0x0000, %ax
# print symbol (80*25-13) times, because hello_str length equals 13
	movw $0x7c3, %cx
	rep stosw

# infinite end loop
_end_print_loop:
	jmp _end_print_loop

