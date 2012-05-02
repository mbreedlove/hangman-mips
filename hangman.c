#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void read_file(char *buf);
void rand_word(char *buf, char *words);
void hangman(char *word);

int main() {
    char words[128];
    char word[8];
    read_file(&words);
    rand_word(&word, &words);

    hangman(&word);
    return 0;
}

void read_file(char *buf) {
    FILE *pFile;

    pFile = fopen("words.txt", "r");
    fread(buf, 1, 38, pFile);
    
    fclose(pFile);
}

void rand_word(char *buf, char *words) {
    srand ( time(NULL) );
    int ra = rand() % 5;
    int new_line_count = 0;
    int offset = 0;

    do {
        if (words[offset] == 0x0a) {
            new_line_count = new_line_count + 1;
        }
        offset = offset + 1;
    } while(new_line_count < ra);
     
    if(ra == 0)
        offset = 0;
    int i; 
    for(i = 0; i < 8; i++) {
        int cur = offset + i;
        if(words[cur] == 0x0A) {
            buf[i] = 0x0a;
            break;
        }
        buf[i] = words[cur];
    }
    
    return;
}

void hangman(char *word) {
    int length;
    for(length = 0; word[length] != 0x0a; length++)

    char guesses[length];
    int i;
    for(i = 0; i < length; i++)
        guesses[i] = '-';

    printf("%s", guesses);
}
