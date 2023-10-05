#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <signal.h>

int main(int argc, char *argv[])
{

	/* fork a child process */
	pid_t pid;
	int status;

	printf("Process start to fork\n");
	pid = fork();

	if (pid == -1) // error occurred
	{
		perror("fork");
		exit(1);
	}
	/* execute test program */
	else
	{
		if (pid == 0)
		{
			print("I'm the Child Process, my pid = %d\n", getpid());
		}
	}

	/* wait for child process terminates */

	/* check child process'  termination status */
}
