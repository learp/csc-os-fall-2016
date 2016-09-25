default: build

build: samples/sh.c
	gcc ./samples/sh.c -o sh
clean:
	-rm -f ./sh
