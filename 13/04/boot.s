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
        
        movw $0x3, %ax
        int $0x10
        
        movw $0xb800, %dx
        movw %dx, %ss
        
        movw $msg, %si
        movw $0x2, %cx
print_loop:
        lodsb
        or %al, %al
        jz endless

        movw %cx, %sp
        
        and $0x00ff, %ax
        or color_mask, %ax
        push %ax

        add $0x2, %cx
        jmp print_loop
endless:
        jmp endless
