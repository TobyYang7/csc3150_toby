#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>

// This is the main function that takes in command line arguments.
int main(int argc, char *argv[])
{
    pid_t pid;
    printf("Start to fork\n");
    pid = fork(); // Create a new process by duplicating the calling process.
    if (pid == -1)
    {                    // If fork() returns -1, an error occurred.
        perror("error"); // Print an error message.
        exit(1);         // Exit the program with a status of 1.
    }
    else
    {
        if (pid == 0)
        {                                                        // If fork() returns 0, this is the child process.
            printf("Child process with return value %d\n", pid); // Print a message indicating that this is the child process.
            exit(0);                                             // Exit the program with a status of 0.
        }
        else
        {                                                         // If fork() returns a positive value, this is the parent process.
            printf("Parent process with return value %d\n", pid); // Print a message indicating that this is the parent process.
            exit(0);                                              // Exit the program with a status of 0.
        }
    }
    return 0; // Return 0 to indicate successful program execution.
}