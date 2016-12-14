build:
	as -o boot.o boot.s
	ld -Ttext 0x7c00 --oformat=binary -o boot boot.o
clean:
	rm -f boot.o boot