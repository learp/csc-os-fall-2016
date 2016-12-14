build:
	as boot.s -o boot.o
	ld -Ttext 0x7C00 -Tdata 0x7DF2 boot.o --oformat binary -o boot
clean:
	rm boot.o boot
