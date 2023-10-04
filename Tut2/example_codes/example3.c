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
            char *arg[argc];
            for (int i = 0; i < argc - 1; i++)
            {
                arg[i] = argv[i + 1];
            };
            arg[argc - 1] = NULL;

            printf("Child Process pid:%d\n",
                   getpid()); // print child process pid

            printf("Child process start to execute test program:\n");

            /* execute test program */
            execve(arg[0], arg, NULL);

            printf("Check if replaced.");

            // handle error
            perror("execve");
            exit(EXIT_FAILURE);
        }
        else
        {
            wait(&state);
            printf("This is a parent process\n");
            exit(0);
        }
    }
    return 0;
}