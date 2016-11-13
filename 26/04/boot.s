.code16

.text
begin:
	# jmp to start
	jmp _start
	
msg:
	.asciz "Hello, World!"

.global _start
_start:
	# set vga mode 3: (format 80x25; color 16/8; adapter CGA,EGA)
	movw $0x3, %ax
	int $0x10
	
	# prepare to read the string symbol by symbol

	# set %ds to 0
	xorw %ax, %ax
	movw %ax, %ds

	# set %si the address of the first byte of 'hello world'
	movw $msg, %si

	# clear direction flag (for LODSB) - to go forward through the string
	cld

print_loop:
	# load 1 byte to %al from ds:si and increment si
	lodsb

	# finish if zero terminated
	or %al, %al
	jz end
	
	# write symbol from %al to the active video page
	movb $0x0e, %ah
	int $0x10

	# write next symbol
	jmp print_loop

# endless cycle
end:
	jmp end

# write MBR magic number
. = begin + 510
MBR:
	.byte 0x55
	.byte 0xaa

