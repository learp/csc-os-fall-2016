.code16

.data
signature:
        .word 0xaa55

.text
msg:
        .asciz "Hello, World!"
color_mask:
        .word 0x0f00

.global _start
_start:
        cli
        xorw %ax, %ax
        movw %ax, %ds

        #перевод vga в текстовый режим
        movw $0x3, %ax
        int $0x10

        #загрузка адреса видеобуфера в сегмент стека
        movw $0xb800, %dx
        movw %dx, %ss

        movw $0x2, %cx

        #загрузка адреса строки
        movw $msg, %si
print_loop:
        lodsb
        #проверка на нуль-терминатор
        or %al, %al
        jz endless

        #установка вершины стека
        movw %cx, %sp

        #загрузка очередного символа в видеобуфер
        and $0x00ff, %ax
        or color_mask, %ax
        push %ax

        add $0x2, %cx
        jmp print_loop
endless:
        jmp endless
