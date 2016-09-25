default: build

build: src/sh.c
	gcc ./src/sh.c -o sh
clean:
	-rm -f ./sh
