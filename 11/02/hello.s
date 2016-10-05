.data

greetings_str:
    .string "Enter your name:\n"
    greetings_str_len = . - greetings_str - 1

scanf_format:
    .string "%256s"

hello_str:
    .ascii "Hello, "
    hello_str_len = . - hello_str

.bss
input_str:
    .space 1

.text  # Code Segment
    .global  main
  
main:
    # Print greetings
    movl    $4, %eax                        # system call number (sys_write)
    movl    $1, %ebx                        # file descriptor (stdout)
    movl    $greetings_str, %ecx            # message to write
    movl    $greetings_str_len, %edx        # message length
    int     $0x80                           # call kernel

    # Read and store the user input
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
    movl    $256, %edx                      # message length
    int     $0x80                           # call kernel

    # Exit 
    movl    $1, %eax  # system call number (sys_exit)
    movl    $0, %ebx  # first argument: exit code
    int     $0x80     # call kernel
