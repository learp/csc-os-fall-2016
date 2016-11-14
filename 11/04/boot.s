.code16

.data                                   # Data segment should be 2 bytes short of 0x7E00 (0x7E00 - 0x7c00 = 512 in dec)
    .word   0xAA55                      # Magic number (the last 2 bytes of the first sector of MBR) for BIOS loader

.text
    .global _start
     # For simplicity, put str data in code segment
    hello_str: .string "Hello, World!"

_start:
    cli                         # Disable interrupts
    movw   $hello_str, %si      # Save pointer to string in source index register

print_loop:
    lodsb                   # Load byte from %si to %al
    or     %al, %al         # Have we reached zero-byte of string or not?
    je     infinite_loop    # If so, jump to infinite_loop
    movb   $0x0E, %ah       # Move function number to %ah, 0Eh - Write Character in TTY Mode
    int    $0x10            # Call INT 10h, BIOS video service
    jmp    print_loop       # Repeat untill the end of the string

infinite_loop:
    jmp infinite_loop
