.code16

.data
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
    OR %AL, %AL
    JZ loop

    MOVB $0x0E, %AH
    INT $0x10

    JMP print_str

loop:
    JMP loop

    
