build:
	as boot.s -o boot.o
	ld --oformat binary -Ttext 0x7C00 -Tdata 0x7DFE boot.o -o boot
clean:
	find . ! -name 'boot.s' -type f ! -name 'Makefile' -type f -exec rm -f {} +
