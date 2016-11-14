; http://www.codeproject.com/Articles/664165/Writing-a-boot-loader-in-Assembly-and-C-Part

.code16
.text
    .globl _start

_start:
    jmp _begin
    message: .asciz "Hello World!"

    .write_letter:

        lodsb

        orb $0x0, %al
        jz .return

        movb $0x0e, %ah
        int $0x10

        jmp .write_letter

    .return:
        jmp .return

_begin:
    leaw message, %si
    call .write_letter
    . = _start + 510
    .byte 0x55
    .byte 0xaa
