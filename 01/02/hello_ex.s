.data                                                                          

what:                  
  .asciz "What is your name? "
  what_length = . - what - 1

format:
	.asciz "%s"

hello:
	.asciz "Hello, "
	hello_length = . - hello - 1
			  
.text
.global main

print:

  movq $1, %rax
  movq $1, %rdi     
  syscall      
  ret
	
main:
	//печатаем запрос имени
	movq $what, %rsi 
	movq $what_length, %rdx
	call print

	//выделяем на стеке место для введенного имени
	sub $0x60, %rsp
	movq %rsp, %rax
	
	//создаем фрейм для вызова scanf и передаем параметры через регистры
	push %rbp
	movq %rsp, %rbp
	movq $format, %rdi
  movq %rax, %rsi
	call scanf
	pop %rbp
	
	//печатаем hello 
  movq $hello, %rsi
	movq $hello_length, %rdx
  call print
  
  //нужно вычислить длину строки, чтобы указать нужный размер для write
  //поэтому вызовем strlen
  movq %rsp, %rax
  push %rbp
	movq %rsp, %rbp
	movq %rax, %rdi
	call strlen
	pop %rbp

	//печатаем введенное имя
	movq %rsp, %rsi 
	movq %rax, %rdx
	call print 
	
// syscall exit
  movl    $1, %eax  
  
// exit code
  movl    $0, %ebx     

// do syscall 
  int     $0x80         
 
// [Hello world] http://www.tldp.org/HOWTO/Assembly-HOWTO/hello.html
// [Directives] http://tigcc.ticalc.org/doc/gnuasm.html#SEC67
// [syscall] https://en.wikibooks.org/wiki/X86_Assembly/Interfacing_with_Linux
// [Intel architecture] http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-vol-1-manual.pdf
