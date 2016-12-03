.code16

.data
.word   0xAA55

.text
  hello: .asciz  "Hello, World!"
  .globl _start

_start:
  movw    $hello, %si
  movw    $0xB800, %bx
  movw    $0x0, %di
  movb    $0x07, %ah

write_char:
  movb    (%si), %al
  inc     %si
  orb $0x00, %al
  jz stop

  movw    %bx, %es
  stosw
  jmp     write_char

stop_space:
 movw $0x20, %ax
 movw $0xff0, %cx
 stosw
 movw $0x20, %ax
 movw $0xff0, %cx
 stosw
 jmp stop

stop:
  jmp stop
