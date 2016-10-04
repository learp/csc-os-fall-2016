#include <stdio.h>
#include <string.h>

#define LENGTH 1000

int main()
{
  char input[LENGTH];
  memset(input, 0, LENGTH);
  scanf("%s", input);
  
  input[strlen(input)] = '\n';
  
  char output[LENGTH] = "Hello, ";
  strcpy(output + 7, input);
  
  size_t len = strlen(output);
  
  asm ( "movq $1, %%rax; "
            "movq $1, %%rdi; "
            "syscall; "
            : 
            : "S" (output), "d" (len)
  );
  
  return 0;
}
