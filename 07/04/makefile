build:
	as boot_hello.s -o boot_hello.o
	ld -Ttext 0x7C00 -Tdata 0x7DFE --oformat binary boot_hello.o -o boot_hello

clean:
	rm boot_hello.o boot_hello