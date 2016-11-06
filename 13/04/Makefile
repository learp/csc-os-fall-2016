build: boot.s
	as -o boot.o boot.s && ld --oformat binary -Ttext 0x7c00 -Tdata 0x7dfe -o boot boot.o

clean:
	rm -f ./boot ./boot.o
