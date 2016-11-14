.code16

.text
	.global _start	
	

_start:

	hello: .asciz "Hello, World!"
	leaw hello, %si

	.print:
          lodsb
          orb  %al, %al
          jz .inf_loop
          movb $0x0e, %ah
          int  $0x10
          jmp  .print

    .inf_loop:
    	jmp .inf_loop

	. = _start + 510
	.byte 0x55
	.byte 0xaa

	call .print
