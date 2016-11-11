.data                                                                          
 
welcome_str:
	.ascii "What is your name?\n"
	welcome_len =. - welcome_str

hello_str:                  
        .ascii "Hello, "
        hello_len = . - hello_str

// buffer right after the "Hello, " string 
// so no need to copy it elsewhere
// or several syscalls for write to stdout
buffer:
	.space 256			

format_str:
	.asciz "%s"

.text
 
.global _start
	
print_welcome:
        movq    $4, 		%rax	# see comments for write syscall in print hello
	movq	$1, 		%rbx
	movq	$welcome_str,	%rcx
	movq	$welcome_len,	%rdx
	int	$0x80 
	ret  

// return length in rax	
get_name:
	xorq	%rax,		%rax	# clear rax - no variadic args
	movq	$format_str,	%rdi	# format string
	movq	$buffer,	%rsi	# output
	callq	scanf			# libc scanf
	movq	$buffer,	%rdi	# received output
	callq	strlen			# libc strlen
// set \n
	movq	%rax,		%rbx	# get address of...
	addq	$buffer,	%rbx	# ...string end
	movb	$'\n',		(%rbx)	# push endl after the name
	addq	$1,		%rax	# increase name length
	ret

// get name length from rax
// and print greating
print_hello:
	movq	%rax,		%rdx	# length of name
 	addq	$hello_len,	%rdx	# plus length of message

	movq    $4, 		%rax	# write
	movq	$1, 		%rbx	# stdout
	movq	$hello_str,	%rcx	# message + name
	int	$0x80 			# syscall
	ret  
	

_start:
	subq	$8,		%rsp	# align stack pointer on a 16 before  calls below
	call 	print_welcome		# print message to user
	call 	get_name		# get name (rsp is  already alligned), and add '\n' suffix
	call 	print_hello		# print greating
	call 	exit			# 

exit:
        movl    $1, %eax  
        movl    $0, %ebx     
        int     $0x80         
 
   
