.code16                       # Assemble for 16-bit mode

.data
  .word   0xAA55              # Load sector 'marker'

.text
  hello_msg:
  .asciz  "Hello world!"
  
  .globl _start

_start:
  cli                         # BIOS enabled interrupts; disable
  movw   $hello_msg, %si      # Load string address to si for lods

write_string:
  lodsb                       # Load next byte

  or     %al, %al             # Break writing on null terminal
  je     end

  movb   $0x0E, %ah           # Move a character to vga
  int    $0x10                # call BIOS video service interruption

  jmp    write_string

end:
  jmp end
