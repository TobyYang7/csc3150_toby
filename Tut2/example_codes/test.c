#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>

int main(void) {
    printf("Test program pid:%d\n",getpid());
    return 0;
}