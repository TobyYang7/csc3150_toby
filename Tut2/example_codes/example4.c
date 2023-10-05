#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>

/**
 * This program demonstrates the use of fork() system call to create a child process.
 * The child process prints its process ID and parent process ID, while the parent process waits for the child process to finish and prints the exit status of the child process.
 *
 * @param argc The number of arguments passed to the program.
 * @param argv An array of pointers to the arguments passed to the program.
 * @return 0 on successful execution.
 */
int main(int argc, char *argv[])
{
    pid_t pid;
    int state;
    printf("Start to fork\n");
    pid = fork();  // create a child process
    if (pid == -1) // fork() failed
    {
        perror("error");
        exit(1);
    }
    else
    {
        if (pid == 0) // child process
        {
            printf("I am the Child Process\n");                             // print child process pid
            sleep(2);                                                       // sleep for 2 seconds
            printf("Child process pid:%d, ppid:%d\n", getpid(), getppid()); // print child process pid and parent process pid
            exit(0);                                                        // exit child process
        }
        else // parent process
        {
            waitpid(pid, &state, 0);                                // wait for child process to finish
            printf("Parent process pid:%d\n", getpid());            // print parent process pid
            printf("Children process exit with state:%d\n", state); // print child process exit status
            exit(0);                                                // exit parent process
        }
    }
    return 0;
}