build:
	as --32 -o hello.o hello.s
	ld --dynamic-linker /lib/ld-linux.so.2 -m elf_i386 -lc --entry _start -o hello hello.o
clean:
	rm hello hello.o
