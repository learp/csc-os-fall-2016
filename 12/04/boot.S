.code16

.data
    # Boot magic
    .word 0xAA55

.text
    .globl _start

greet_msg: 
    .asciz "Hello World!"

_start:
    CLI

    MOVW $0x07C0, %DX
    MOVW $greet_msg, %SI
    MOVW $0xB800, %BX
    MOVW %BX, %ES
    MOVW $0x0, %DI

    # Clear QEMU output and leave cursor on center
    MOVW $0x0720, %AX  #black BG, white FG, 20 - space, 
    MOVW $0x0250, %CX
    REP STOSW

print_char:
    LODSB

    OR %AL, %AL
    JZ loop

    STOSW
    JMP print_char

loop:
    JMP loop
