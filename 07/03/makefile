build:
	as boot_hello.s -o boot_hello.o && ld -Ttext 0x7c00 --oformat=binary boot_hello.o -o boot_hello

clean:
	rm boot_hello boot_hello.o