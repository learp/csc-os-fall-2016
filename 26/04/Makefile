build:
	as -o boot.o boot.s
	ld -o boot --oformat binary -Ttext 0x7c00 boot.o 
clean:
	rm -f boot boot.o

