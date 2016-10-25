.data

prompt_str:
    .string "Enter your name:\n"
    prompt_str_len = . - prompt_str - 1

.set name_buf_len, 256

scanf_format:
    .asciz "%256s"  # this is a real pain for me to convert name_buf_len to string

hello_str:
    .ascii "Hello, "
    hello_str_len = . - hello_str

.bss
input_str:
    .space name_buf_len

.text  # Code Segment
    .global  main
  
main:
    # Print prompt
    movl    $4, %eax                        # system call number (sys_write)
    movl    $1, %ebx                        # file descriptor (stdout)
    movl    $prompt_str, %ecx               # message to write
    movl    $prompt_str_len, %edx           # message length
    int     $0x80                           # call kernel

    # Read and store the user name
    pushl $input_str
    pushl $scanf_format
    call scanf

    # Print "Hello, "
    movl    $4, %eax                        # system call number (sys_write)
    movl    $1, %ebx                        # file descriptor (stdout)
    movl    $hello_str, %ecx                # message to write
    movl    $hello_str_len, %edx            # message length
    int     $0x80                           # call kernel

    # Print name
    movl    $4, %eax                        # system call number (sys_write)
    movl    $1, %ebx                        # file descriptor (stdout)
    movl    $input_str, %ecx                # message to write
    movl    $name_buf_len, %edx             # message length
    int     $0x80                           # call kernel

    # Exit 
    movl    $1, %eax  # system call number (sys_exit)
    movl    $0, %ebx  # first argument: exit code
    int     $0x80     # call kernel
