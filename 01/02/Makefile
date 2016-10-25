build:
	gcc -c hello_ex.s -o hello_ex.o
	ld -o hello_ex -dynamic-linker /lib64/ld-linux-x86-64.so.2 /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o -lc hello_ex.o /usr/lib/x86_64-linux-gnu/crtn.o
clean:
	rm -f hello_ex hello_ex.o
