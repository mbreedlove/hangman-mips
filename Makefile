CC=gcc
CFLAGS=-Wall

all:
	$(CC) $(CFLAGS) -o hangman-c hangman.c
	chmod +x ./hangman-c
clean:
	rm -rf hangman-c

