.data

welcome_str:
    .asciz "What is your name?\n"
    length = . - welcome_str - 1

hello_str:
    .asciz "Hello, "
    length2 = . - hello_str - 1

.section .bss

.lcomm name, 128

.text

.global  main

printhello:
    movl    $4, %eax
    movl    $1, %ebx
    movl    $welcome_str, %ecx
    movl    $length, %edx
    int     $0x80
    ret

readname:
    movl    $3, %eax
    movl    $0, %ebx
    movl    $name, %ecx
    movl    $128, %edx
    int     $0x80
    ret

printname:
    movl    $4, %eax
    movl    $1, %ebx
    movl    $hello_str, %ecx
    movl    $length, %edx
    int     $0x80

    movl    $4, %eax
    movl    $1, %ebx
    movl    $name, %ecx
    movl    $128, %edx
    int     $0x80
    ret

main:
    call printhello
    call readname
    call printname


    movl    $1, %eax
    movl    $0, %ebx
    int     $0x80



# [Hello world] http://www.tldp.org/HOWTO/Assembly-HOWTO/hello.html
# [Directives] http://tigcc.ticalc.org/doc/gnuasm.html#SEC67
# [syscall] https://en.wikibooks.org/wiki/X86_Assembly/Interfacing_with_Linux
# [Intel architecture] http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-vol-1-manual.pdf
