build:
	as lab4.s -o boot.o
	ld -Tdata 0x7DFE -Ttext 0x7c00 --oformat=binary boot.o -o boot
clean:
	rm boot boot.o
