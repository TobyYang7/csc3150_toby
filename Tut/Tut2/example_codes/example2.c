#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>

// This is the main function of the program
// It takes in two arguments, an integer argc and a character pointer array argv
int main(int argc, char *argv[])
{
    pid_t pid;                 // Declare a variable of type pid_t called pid
    printf("Start to fork\n"); // Print a message to the console
    pid = fork();              // Call the fork function and assign the result to pid
    if (pid == -1)             // If fork returns -1, an error occurred
    {
        perror("error"); // Print an error message to the console
        exit(1);         // Terminate the program with an error code
    }
    else // Otherwise, fork was successful
    {
        if (pid == 0) // If pid is 0, this is the child process
        {
            // sleep(1);                                                      // Uncomment this line to add a delay of 1 second
            printf("Child process pid:%d ppid:%d\n", getpid(), getppid()); // Print the child process ID and parent process ID to the console
            exit(0);                                                       // Terminate the child process with a success code
        }
        else // Otherwise, this is the parent process
        {
            // sleep(3);                                    // Add a delay of 3 seconds
            printf("Parent process pid:%d\n", getpid()); // Print the parent process ID to the console
            exit(0);                                     // Terminate the parent process with a success code
        }
    }
    return 0; // Return 0 to indicate successful program termination
}