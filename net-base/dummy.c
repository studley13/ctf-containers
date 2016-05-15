#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    char strbuf[1000] = {0};

    printf("\e[31;1m$\e[0m ");
    fflush(stdout);
    fflush(stdin);

    while (fgets(strbuf, 1000, stdin) != NULL) {
    	strbuf[strlen(strbuf) - 1] = '\0';
    	fflush(stdin);
	printf("\e[36;1mYou said:\e[0m %s\n", strbuf);
    	fflush(stdout);
    	printf("\e[31;1m$\e[0m ");
    	fflush(stdout);
    }
    	
    printf("\n");
    fflush(stdout);

    return EXIT_SUCCESS;
}
