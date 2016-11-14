all:
	as test.S -o test.o
	ld -Ttext 0x7c00 --oformat=binary test.o -o test.bin
	
clean: 
	rm test.o
	rm test.bin
	