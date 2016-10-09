build: hello.s
	as --64 -o hello.o hello.s && ld --dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc --entry main -o hello hello.o

clean:
	rm -f hello hello.o
