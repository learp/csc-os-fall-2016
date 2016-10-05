build:
	as --32 -o hello.o hello.s; ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -o hello -e main hello.o -lc

clean:
	rm -f hello.o hello