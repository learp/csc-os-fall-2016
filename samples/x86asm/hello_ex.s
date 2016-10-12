.data                                                                          
 
hello_str:                  
        .asciz "Hello world!\n"
        length = . - hello_str - 1
 
.text
 
.global  main
	

printhello:

// syscall write
        movl    $4, %eax     
// stdout - 1
        movl    $1, %ebx         
        movl    $hello_str, %ecx 
        movl    $length, %edx   
	ret 
	
main:
	call printhello
	    

// do syscall 
        int     $0x80       
 
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
