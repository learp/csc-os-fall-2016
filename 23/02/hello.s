.data
    welcome_str:
        .asciz "What's your name?\n"
        w_length = . - welcome_str - 1

    hello_str:
        .asciz "Hello, "
        h_length = . - hello_str - 1

    name:
        .asciz "%s"
        name_length = 239

    name_buffer:
        .space 239

    new_line:
        .asciz "\n"
.text
        .global _start
_start:

        // Write welcome message
        movq    $1, %rax
        movq    $1, %rdi
        movq    $welcome_str, %rsi
        movq    $w_length, %rdx
        syscall

        // Gently ask with scanf(const char*, ...)
        movq $name, %rdi
        movq $name_buffer, %rsi
        callq scanf

        // Write it in three steps: "Hello,", "%s", "\n"
        movq    $1, %rax
        movq    $1, %rdi
        movq    $hello_str, %rsi
        movq    $h_length, %rdx
        syscall

        // String is zero-terminated, so it's fine to pass whole buffer length
        movq    $1, %rax
        movq    $1, %rdi
        movq    $name_buffer, %rsi
        movq    $name_length, %rdx
        syscall

        movq    $1, %rax
        movq    $1, %rdi
        movq    $new_line, %rsi
        movq    $1, %rdx
        syscall

        // Exit
        movq    $60, %rax
        movq    $0, %rdi
        syscall
