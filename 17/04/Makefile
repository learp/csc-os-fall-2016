
build:
	as boot.s -o boot.o
	ld -Ttext 0x7C00 -Tdata 0x7DFE --oformat binary boot.o -o boot

clean:
	rm boot.o boot
