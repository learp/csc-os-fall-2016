.code16

.data

hello_str:
        .asciz "Hello, MBR!"

        .word 0xAA55

.text

.globl main

main:
        cli
        movw $hello_str, %si
        movb $0x0E, %ah

print_char:
        lodsb
        cmp $0, %al
        je end
        int $0x10
        jmp print_char

end:
        jmp end

