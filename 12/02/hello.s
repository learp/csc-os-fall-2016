.data                           	# data section declaration
	greeting:
		.asciz "Enter your name: "
		greeting_len = . - greeting

	input_fmt:
		.asciz "%s"

	hello:
		.asciz "Hello, "
		hello_len = . - hello

	username:
		.space 512

	username_len:
		.int

	str_lf:
		.ascii "\n"


.text                           
	.global _start      

	_start:  #Entry point
		movl $4, %EAX 				# sys_write
		movl $1, %EBX 				# std_out
		movl $greeting, %ECX
		movl $greeting_len, %EDX
		int $0x80

		pushl $username				#Calling scanf
		pushl $input_fmt
		call scanf

		movl $4, %EAX 				# sys_write
		movl $1, %EBX 				# std_out
		movl $hello, %ECX
		movl $hello_len, %EDX
		int $0x80

		movl $4, %EAX 				# sys_write
		movl $1, %EBX 				# std_out
		movl $username, %ECX
		movl $512, %EDX
		int $0x80

		movl $4, %EAX 				# sys_write
		movl $1, %EBX 				# std_out
		movl $str_lf, %ECX
		movl $1, %EDX
		int $0x80

	    # Exit 
	    movl    $1, %EAX			# system call number (sys_exit)
	    movl    $0, %EBX  			# first argument: exit code
	    int     $0x80    			# call kernel
