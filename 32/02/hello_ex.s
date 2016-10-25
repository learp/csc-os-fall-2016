.data                                                                          
 
hello_str:                  
        .asciz "Hello, "
        hello_len = . - hello_str
format:
        .asciz "%s"
new_line:
        .asciz "\n"
input: 
        .asciz

.text
 
.global  main
	
scan:
        pushl   $input
        pushl   $format
        call    scanf
        addl    $8, %esp
        ret

print:
        movl    $4, %eax     
        movl    $1, %ebx         
        pushl   %edi
        pushl   %ecx
        pushl   %edx
        pushl   %ebp
        movl    %esp, %ebp
        sysenter

print_hello:
        movl    $print_input, %edi
        movl    $hello_len, %edx   
        movl    $hello_str, %ecx
        call    print

print_input:
        movl    $print_new_line, %edi
        movl    $32, %edx   
        movl    $input, %ecx
        call     print

print_new_line:
        movl    $exit, %edi
        movl    $1, %edx   
        movl    $new_line, %ecx
        call     print

exit:
        movl    $1, %eax  
        movl    $0, %ebx     
        int     $0x80         
	
main:
        call    scan
        call    print_hello
 
