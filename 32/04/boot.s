.code16

.data

hello_str:
        .asciz "Hello, MBR!"

        .word 0xAA55

.text

.globl main

main:
        cli
        movw $0xb800, %ax
        movw %ax, %es
        movw $hello_str, %ax
        movw %ax, %si
        jmp clear_screen

print_char:
        movb (%si), %al
        movb $0x07, %ah
        inc %si
        stosw
        cmp $0, %al
        je end
        jmp print_char

clear_screen:
        movb $0x02, %al
        movb $0, %ah
        int $0x10
        jmp print_char

end:
        jmp end

