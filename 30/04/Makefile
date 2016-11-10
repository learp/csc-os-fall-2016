build:
	as -o boot.o boot.s; ld -Ttext 0x7c00 --oformat=binary boot.o -o boot

clean:
	find . ! -name Makefile ! -name boot.s -type f -delete
