.code16

.data
  .word   0xAA55

.text
  hello_msg:
  .asciz  "Hello, World!"

  .globl _start

_start:
  cli

  movw    $0x07C0,%dx      # fix base and
  movw    $hello_msg,%si   # offset of message
  movw    $0xB800,%bx      # fix base and
  movw    $0x0,%di         # offset of first byte of video buffer

  movb    $0x07,%ah        # fix color format for each symbol
write_next:
  # read next char of the message
  movw    %dx,%es
  movb    (%si),%al
  inc     %si

  # end if it is null
  or      %al,%al
  je      end

  # put next char into video buffer (2 bytes total: sybol + formatting)
  movw    %bx,%es
  stosw
  jmp     write_next

end:
  # make cleanup: print a lot of ' '
  movw    $0x20,%ax
  movw    %bx,%es
  mov     $0x500,%cx
  rep     stosw

cycle:
  jmp cycle
