.data                                                                          
 
question:
        .asciz "What is your name?\n"
        q_length = . - question - 1

// hello string
hello_str:                  
        .ascii "Hello, "
        hello_len = . - hello_str

// username, any size
name:
	.space 			
// format for scanf, just a string
format:
	.asciz "%s"

.text
 
.global main
	
//print question using write syscall
printquestion:
        movl    $4, %eax
	movl	$1, %ebx
	movl	$question, %ecx
	movl	$q_length, %edx
	int	$0x80
	ret  
// exit using syscall
exit:
        movl    $1, %eax  
        movl    $0, %ebx     
        int     $0x80 

// reading user name, using scanf function
reading:
	movl	$format,%edi
	movl	$name,	%esi
	call	scanf			# c-library function
	ret
// print hello and user's name using write syscalls
printanswer:
	movl $4, %eax 			
	movl $1, %ebx 				
	movl $hello_str, %ecx
	movl $hello_len, %edx
	int $0x80

	movl $4, %eax 				
	movl $1, %ebx 				
	movl $name, %ecx
	movl $500, %edx		# reserve for really big name
	int $0x80

	ret

main:
// align stack pointer
	subq	$8,%rsp
	call 	printquestion	
	call 	reading		
	call 	printanswer		
	call 	exit

 
