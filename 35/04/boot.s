.code16                       # Assemble for 16-bit mode

.data
  .word   0xAA55              # Load sector 'marker'

.text
  hello_msg:
  .asciz  "Hello World!"

.globl _start

_start:
  cli                         # BIOS enabled interrupts; disable

  movw   $hello_msg, %si      # Load string address to si for lods

  movw   $0xB800, %cx	      # Load VGA buffer address to stack
  movw   %cx, %ss
  movw   $0x2, %cx

write_string:
  lodsb                       # Load next byte

  or     %al, %al             # Break writing on null terminal
  je     end

  movw   %cx, %sp

  and    $0x00FF, %ax         # Clear 'color' bits
  or     $0x5F00, %ax         # Set color
  push   %ax
  add    $0x2, %cx

  jmp    write_string

end:
  jmp end
