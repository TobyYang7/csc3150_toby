#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <signal.h>

void check_termination(int status)
{
	if (WIFEXITED(status)) // child process terminated normally
	{
		// normal.c
		printf("Normal termination with EXIT STATUS = %d\n", WEXITSTATUS(status));
	}
	else if (WIFSIGNALED(status)) // child process terminated by a signal
	{
		// abort.c
		if (WTERMSIG(status) == SIGABRT)
		{
			printf("child process get SIGABRT signal");
		}
		// alarm.c
		else if (WTERMSIG(status) == SIGALRM)
		{
			printf("child process get SIGALRM signal");
		}
		// bus.c
		else if (WTERMSIG(status) == SIGBUS)
		{
			printf("child process get SIGBUS signal");
		}
		// floating.c
		else if (WTERMSIG(status) == SIGFPE)
		{
			printf("child process get SIGFPE signal");
		}
		// hangup.c
		else if (WTERMSIG(status) == SIGHUP)
		{
			printf("child process get SIGHUP signal");
		}
		// illegal_instr.c
		else if (WTERMSIG(status) == SIGILL)
		{
			printf("child process get SIGILL signal");
		}
		// interrupt.c
		else if (WTERMSIG(status) == SIGINT)
		{
			printf("child process get SIGINT signal");
		}
		// kill.c
		else if (WTERMSIG(status) == SIGKILL)
		{
			printf("child process get SIGKILL signal");
		}
		// pipe.c
		else if (WTERMSIG(status) == SIGPIPE)
		{
			printf("child process get SIGPIPE signal");
		}
		// segment_fault.c
		else if (WTERMSIG(status) == SIGSEGV)
		{
			printf("child process get SIGSEGV signal");
		}
		// terminate.c
		else if (WTERMSIG(status) == SIGTERM)
		{
			printf("child process get SIGTERM signal");
		}
		// trap.c
		else if (WTERMSIG(status) == SIGTRAP)
		{
			printf("child process get SIGTRAP signal");
		}
	}
	else if (WIFSTOPPED(status)) // child process stopped by a signal
	{
		// stop.c
		printf("child process get SIGSTOP signal");
	}
	else // other cases
	{
		printf("CHILD PROCESS CONTINUED\n");
	}
}

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
			// Child process
			printf("I'm the Child Process, my pid = %d\n", getpid());

			char *arg[argc];
			for (int i = 0; i < argc - 1; i++)
			{
				arg[i] = argv[i + 1];
			}
			arg[argc - 1] = NULL;

			printf("Child process start to execute test program:\n");
			execve(arg[0], arg, NULL);

			// If execve fails, handle the error
			perror("execve");
			exit(EXIT_FAILURE);
		}
		else
		{
			// Parent process
			printf("I'm the Parent Process, my pid = %d\n", getpid());

			/* wait for child process terminates */
			waitpid(pid, &status, WUNTRACED);
			printf("Parent process receives SIGCHLD signal\n");

			/* check child process'  termination status */
			check_termination(status);
		}
	}
}
