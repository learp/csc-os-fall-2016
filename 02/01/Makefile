all: build

build: sh.o
	gcc -o sh sh.o
sh.o: sh.c
	gcc -c -o sh.o sh.c

clean:
	rm -rf *.o sh

