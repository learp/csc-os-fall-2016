build:
	as -o boot.o boot.S && ld --oformat binary -Ttext 0x7C00 -Tdata 0x7DFE boot.o -o boot
clean:
	rm boot.o boot
