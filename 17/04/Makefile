all:
	as boot.s -o boot.o 
	ld -Ttext 0x7c00 --oformat=binary boot.o -o boot

clean:
	rm boot.o boot
