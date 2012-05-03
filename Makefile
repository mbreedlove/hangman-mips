CC=clang
CFLAGS=-Wall
OUTFILE=bin/hangman

all:
	$(CC) $(CFLAGS) -o $(OUTFILE) src/C/hangman.c
clean:
	rm -rf bin/*

