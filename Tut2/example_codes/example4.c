#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(int argc, char *argv[])
{
    pid_t pid;
    int state;
    printf("Start to fork\n");
    pid = fork();
    if (pid == -1)
    {
        perror("error");
        exit(1);
    }
    else
    {
        if (pid == 0)
        {
            printf("I am the Child Process"); // print child process pid
            sleep(2);
            printf("Child process pid:%d, ppid:%d\n", getpid(), getppid());
        }
        else
        {
            waitpid(pid, &state, WNOHANG);
            printf("Parent process pid:%d\n", getpid());
            printf("Children process exit with state:%d\n", state);
            exit(0);
        }
    }
    return 0;
}