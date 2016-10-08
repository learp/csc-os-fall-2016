.data
    welcome:
          .asciz "What's your name?\n"
          welcome_len = . - welcome - 1

    hello_mgs:
          .asciz "Hello, "
          hello_len = . - hello_mgs - 1

    name:
          .asciz "%s"
          name_len = 64 #max
    in_buf:
          .space 64

    lf:
          .asciz "!\n"
          lf_len = 2

.text
          .global _start
_start:
          movq    $4, %rax              # syscall write
          movq    $1, %rbx              # stdout
          movq    $welcome, %rcx        # str to reg
          movq    $welcome_len, %rdx    # str len to reg
          int     $0x80

          movq    $name, %rdi           # format to reg
          movq    $in_buf, %rsi         # buffer to reg
          callq   scanf                 # syscall scanf

          movq    $4, %rax
          movq    $1, %rbx
          movq    $hello_mgs, %rcx
          movq    $hello_len, %rdx
          int     $0x80

          movq    $4, %rax
          movq    $1, %rbx
          movq    $in_buf, %rcx
          movq    $name_len, %rdx
          int     $0x80

          movq    $4, %rax
          movq    $1, %rbx
          movq    $lf, %rcx
          movq    $lf_len, %rdx
          int     $0x80

          movq    $1, %rax              # syscall exit
          movq    $0, %rbx              # exit code
          int     $0x80
