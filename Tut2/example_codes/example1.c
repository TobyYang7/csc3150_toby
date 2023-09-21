#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>

int main(int argc, char*argv[]){
    pid_t pid;
    printf("Start to fork\n");
    pid = fork();
    if (pid == -1){
        perror("error");
        exit(1);
    }
    else{
        if (pid == 0){
            printf("Child process with return value %d\n",pid);
            exit(0);
        }
        else{
            printf("Parent process with return value %d\n",pid);
            exit(0);
        }
    }
    return 0;
}