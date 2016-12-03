.code16

.data
  .word   0xAA55

.text
  hello: .asciz  "Hello, World!"
  .globl _start

_start:

  movw    $0x07C0, %dx
  movw    $hello, %si
  movw    $0xB800, %bx
  movw    $0x0, %di
  movb    $0x07, %ah

write_char:
  movw    %dx, %es

  movb    (%si), %al
  inc     %si

  # stop char => do stop
  orb $0x00, %al
  jz stop

  # to vbuff
  movw    %bx, %es
  stosw

  # again
  jmp     write_char

stop: jmp stop
