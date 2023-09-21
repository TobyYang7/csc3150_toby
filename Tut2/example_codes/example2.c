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
            // sleep(1);
            printf("Child process pid:%d ppid:%d\n",getpid(),getppid());
            exit(0);
        }
        else{
            // sleep(3);
            printf("Parent process pid:%d\n",getpid());
            exit(0);
        }
    }
    return 0;
}