# 16-ти битный режим
.code16

.globl _start
_start:
	# сброс interrupt flag (IF)
	cli 
	# поместить адрес строки в %si (или %esi?) для дальнейшей работы с lodsb
	movw $str, %si

print_str:
	# загрузить байт из %si в %al
	lodsb
	# проверить текущий байт в %al на конец строки, выйти, если true
	orb %al, %al
	je inf

	# отобразить символ (teletype)
	movb $0x0e, %ah
	int $0x10

	jmp print_str

inf:
	jmp inf

.text
	str:
		.asciz "Hello, MBR!"

# запись в 511 байт 0x55, и в 512 байт 0xAA
# чтобы BIOS распознал boot как загрузочный 
.data 
	.word 0xaa55
