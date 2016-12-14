all:
	as test1.S -o test1.o
	ld -Ttext 0x7c00 -Tdata 0x7DFE --oformat=binary test1.o -o boot

clean:
	rm test1.o boot
