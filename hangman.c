#include <stdio.h>
#include <stdlib.h>

void read_file(char *buf);


int main() {
        char words[128];
    read_file(&words);
    printf("%s", words);

    return 0;
}

void read_file(char *buf) {
    FILE *pFile;

    pFile = fopen("words.txt", "r");
    fread(buf, 1, 38, pFile);
    
    fclose(pFile);
}
