.text
.code16
.global start

start:
cli
mov $0x9000, %ax #Set up stack
mov %ax, %ss     #Tell processor where stack is
mov $0xFB00, %sp #Set stack offset
lea  hello, %si

movw  $0xB800, %ax
movw  %ax, %es

mov   $0x07, %ah

WriteString:
  lodsb                   # load byte at ds:si into al (advancing si)
  or     %al, %al         # test if character is 0 (end)
  jz     clean_init 			      # jump to end if clean.

  movw   %ax, %es:(%di)
  lea    2(%di), %di
  jmp    WriteString      # Repeat for next character.

clean_init:
  mov $20, %ax
  mov $0x300, %cx
clean_loop:
  dec %cx
  or %cx, %cx
  jz cicle
  movw   %ax, %es:(%di)
  lea    2(%di), %di
  jmp clean_loop

cicle:
  jmp cicle   #And so on and so on

hello:                  
  .asciz "Hello, World!"

.fill (510 - (. - start)), 1, 0  #Fill rest of sector up with 0s to make this 512B (a sector)
.word 0xAA55             #Let BIOS know this is an OS! (defines a word)
