.code16

.data 
    .word 0xAA55

.section .text
    .globl _start

_start:
    hello: .asciz "Hello World!"

    setup:
	cld
	# clear data storage segment
	movw $0x0, %ax
   	movw %ax, %ds
	
	# load pointer of string to si
    	movw $hello, %si
    	movw $0xB800, %ax
    	movw %ax, %es
	
	# clear video segment
    	movw $0x0, %di   
	
	# set white color for string
	movb   $0x07, %ah         

    write_letter:

        # load next letter
        lodsb

        # check if string is over
        orb %al, %al
        jz print_spaces

        # function to write a letter
        stosw

        # write next letter
        jmp write_letter
	
    print_spaces:

	# print 0xff0 spaces after string
	movw $0x20, %ax
 	movw $0xff0, %cx          
	rep stosw

    end:
	jmp end  
