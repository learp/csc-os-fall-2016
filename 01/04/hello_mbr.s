.text
.code16
.global start

start:
cli
mov $0x9000, %ax #Set up stack
mov %ax, %ss     #Tell processor where stack is
mov $0xFB00, %sp #Set stack offset
lea  hello, %si
jmp WriteString

WriteString:
  lodsb                   # load byte at ds:si into al (advancing si)
  or     %al, %al         # test if character is 0 (end)
  jz     cicle 			    # jump to end if 0.

  mov    $0xE, %ah          # Subfunction 0xe of int 10h (video teletype output)
  mov    $9, %bx            # Set bh (page nr) to 0, and bl (attribute) to white (9)
  int    $0x10              # call BIOS interrupt.

  jmp    WriteString      # Repeat for next character.

cicle:
jmp cicle   #And so on and so on

hello:                  
  .asciz "Hello, World!"

.fill (510 - (. - start)), 1, 0  #Fill rest of sector up with 0s to make this 512B (a sector)
.word 0xAA55             #Let BIOS know this is an OS! (defines a word)
