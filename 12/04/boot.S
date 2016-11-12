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
    XORW %AX, %AX

    MOVW $greet_msg, %SI

print_str:
    LODSB
    # End of string check
    OR %AL, %AL
    JZ loop

    # Teletype output
    MOVB $0x0E, %AH
    INT $0x10

    JMP print_str

loop:
    JMP loop
