build:
	as -o boot.o boot.s; ld -Ttext 0x7c00 -Tdata 0x7DFE --oformat=binary boot.o -o boot

clean:
	find . ! -name Makefile ! -name boot.s -type f -delete
