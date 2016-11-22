.code16

.text
begin:
	# jmp to start
	jmp _start
	
msg:
	.asciz "Hello, World!"

.global _start
_start:
	cli
	# prepare to read the string symbol by symbol

	# set ax = 0
	xorw %ax, %ax
	# set %ds:%si the address of the first byte of 'hello world'	
	movw %ax, %ds
	movw $msg, %si
	
	# set %es:%di the 0xB8000 address (video buffer)
	movw %ax, %di
	movw $0xB800, %ax
	movw %ax, %es

	# clear direction flag (for LODSB and STOSW) - to go forward through the string
	cld

print_loop:
	# load 1 byte to %al from ds:si and increment si
	lodsb

	# finish if zero terminated
	or %al, %al
	jz clear_screen
	
	# set character format (write it to %ah)
	movb $0x07, %ah
	
	# write 2 bytes from %ax to es:di and increase di by 2
	stosw

	# write next symbol
	jmp print_loop

clear_screen:
	# set %dx - pointer to the end of video memory (80 x 25 x 2 b)
	movw $0xFA0, %dx
	# set empty to ax
	movw $0x20, %ax
clear_symbol:
	cmp %di, %dx
	jz end
	stosw
	jmp clear_symbol
# endless cycle
end:
	jmp end

# write MBR magic number
. = begin + 510
MBR:
	.byte 0x55
	.byte 0xaa

