.code16

.text
.globl _start;
_start:      
	 welcome: .asciz "Hello World!"
     leaw  welcome, %si
	 call .writeStringIn
	 call _boot
	 
    
     #function to print the string
     .writeStringIn:
          lodsb
          orb  %al, %al
          jz   .writeStringOut
          movb $0x0e, %ah
          int  $0x10
          jmp  .writeStringIn
		 
     .writeStringOut:
     	ret

_boot:
	 . = _start + 510
	.byte 0x55
    .byte 0xaa
