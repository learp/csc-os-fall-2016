.code16

.data
	.word   0xAA55

.text
	.global _start

_start:

	hello: .asciz "Hello, World!"

	movw	$hello, %si

	movw    $0xB800, %bx
	movw    $0x0, %di
	movb    $0x03, %ah
	
.print:
	lodsb
	orb		$0x00, %al
	jz		.inf_loop
	movw    %bx, %es
	stosw
	jmp		.print

.inf_loop:
	jmp .inf_loop
