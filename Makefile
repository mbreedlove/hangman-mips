CC=clang
CFLAGS=-Wall
OUTFILE=hangman

all:
	$(CC) $(CFLAGS) -o $(OUTFILE) hangman.c
clean:
	rm -rf $(OUTFILE)

