.code16

.text
    hello_str: .string "Hello, World!"
    .global _start

_start:
    cli                         # Disable interrupts
    cld                         # String operations increment
    xorw %ax, %ax
    movw %ax, %ds               # Set base to 0 for DS:SI segment
    movw   $hello_str, %si      # Save pointer to string in SI (source index register)

    movw $0xB800, %ax
    movw %ax, %es               # Immediate operation is not allowed on ES, do it through %ax
    xor %di, %di                # ES:DI segment points to video memory

    movb   $0x07, %ah           # Set white color for text

print_loop:
    lodsb                       # Load byte from DS:SI to %al and increase SI by 1

    or     %al, %al             # Have we reached zero-byte of string or not?
    je     clean_screen         # If so, clean the rest of the screen and go to infinite_loop

    stosw                       # Write 2 bytes from %ax to ES:DI (video memory) and increase DI by 2
    jmp    print_loop           # Repeat until the end of the string


clean_screen:
  movw    $0x20, %ax            # Space character + black color formatting
  mov     $0x1987, %cx          # 80 x 25 - (string length). Where I can check that default resolution is really 80x25?
  rep     stosw                 # Repeat CX times

infinite_loop:
    jmp infinite_loop

. = hello_str + 510
.word   0xAA55                  # Magic number (the last 2 bytes of the first sector of MBR) for BIOS loader
