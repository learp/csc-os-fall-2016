build:
	as hello.s -o hello.o
	ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -o hello hello.o
clean:
	rm -f hello
	rm -f hello.o
