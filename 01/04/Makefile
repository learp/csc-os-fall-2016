build:
	as -32 hello_mbr.s -o boot.o
	ld -m elf_i386 boot.o -o boot.out -Ttext 0x7C00
	objcopy -S -O binary -j .text boot.out boot
clean:
	rm boot.o boot.out boot
