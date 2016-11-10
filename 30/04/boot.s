.code16
.section .text
    .globl _start

_start:
    jmp _beg
    hello: .asciz "Hello World!"

    .macro write_string string
        leaw \string, %si
        call .write_letter
    .endm

    .write_letter:

        # load next letter
        lodsb

        # check if string is over
        orb %al, %al
        jz .return

        # function to write a letter
        movb $0x0e, %ah
        int $0x10

        # write next letter
        jmp .write_letter

    .return:
        ret

_beg:
    write_string hello

    . = _start + 510
    .byte 0x55
    .byte 0xaa
