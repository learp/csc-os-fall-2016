build: hello.S
	as -o hello.o hello.S
	ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc -o hello hello.o
	chmod +x hello
clean:
	find . ! -name 'hello.S' -type f ! -name 'Makefile' -type f -exec rm -f {} +
