default: build

build: boot.S
	as boot.S -o boot.o
	ld -Ttext 0x7c00 --oformat=binary boot.o -o boot
clean:
	-rm -f ./boot.o ./boot
