.data

greetings_str:
    .asciz "Enter the string you want to echo:\n"
    greetings_str_len = . - greetings_str - 1
 
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
    // movl 3, %eax          # system call number (sys_read)
    // movl 0, %ebx          # file descriptor (stdin)
    // movl str, %ecx        # message destination
    // movl 100, %edx        # message length
    // int  $0x80            # call kernel

    # Exit 
    movl    $1, %eax  # system call number (sys_exit)
    movl    $0, %ebx  # first argument: exit code
    int     $0x80     # call kernel
