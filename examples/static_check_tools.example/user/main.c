#include <stdio.h>
#include <string.h>
#include <stdlib.h>


void copy_name(char *input)
{
    char buf[16];

    strcpy(buf, input);

    printf("name=%s\n", buf);
}


int main(int argc, char **argv)
{
    char *p;
    int *c = NULL;
    *c=1;
    p = malloc(128);

    if (argc > 1)
        copy_name(argv[1]);

    free(p);

    return 0;
}
