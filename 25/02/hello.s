.data

	welcomestr:
		.asciz "Enter your name: "
		welcomelength = . - welcomestr

	hellostr:
		.asciz "Hello, "
		hellolength = . - hellostr

	newlinestr:
		.asciz "\n"
		newlinelength = . - newlinestr

	namestr:
		.asciz "%s"
		namelength = 256

.bss
	.lcomm name, 256

.text

	.global  main

	printnewline:
	// syscall write; #define __NR_write 1
		movq    $1, %rax
	// stdout - 1
		movq    $1, %rdi
	// stdout - 1
		movq    $newlinestr, %rsi
		movq    $newlinelength, %rdx
		ret	

	printwelcome:
		movq	$1, %rax
		movq	$1, %rdi
		movq	$welcomestr, %rsi
		movq	$welcomelength, %rdx
		ret

	readname:
		movq $namestr, %rdi
		movq $name, %rsi
		call scanf
		ret

	printhello:
		movq    $1, %rax
		movq    $1, %rdi
		movq    $hellostr, %rsi
		movq    $hellolength, %rdx
		ret

	printname: 
		movq	$1, %rax
		movq    $1, %rdi
		movq    $namestr, %rsi
		movq    $namelength, %rdx
		ret

	doexit:
	// syscall exit. exit code is 60 in arch/x86/include/asm/unistd_64.h
		movq    $60, %rax
	// exit code
		movq    $0, %rdi
	// do syscall
		ret	
	
	main:
		call printwelcome
		syscall

		call readname
		syscall

		call printhello
		syscall

		call printname
		syscall

		call printnewline
		syscall

		call doexit
		syscall
