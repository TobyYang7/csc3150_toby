#include <linux/module.h>
#include <linux/sched.h>
#include <linux/pid.h>
#include <linux/kthread.h>
#include <linux/kernel.h>
#include <linux/err.h>
#include <linux/slab.h>
#include <linux/printk.h>
#include <linux/jiffies.h>
#include <linux/kmod.h>
#include <linux/fs.h>

MODULE_LICENSE("GPL");

const char TEST_PATH[] = "/home/seed/csc3150_toby/CSC3150_P1/program2/test";
static struct task_struct *thread;

struct wait_opts
{
	enum pid_type wo_type;
	int wo_flags;
	struct pid *wo_pid;
	struct waitid_info *wo_info;
	int wo_stat;
	struct rusage *wo_rusage;
	wait_queue_entry_t child_wait;
	int notask_error;
};

extern pid_t kernel_clone(struct kernel_clone_args *args);
extern struct filename *getname_kernel(const char *filename);
extern long do_wait(struct wait_opts *wo);
extern int do_execve(struct filename *filename, const char __user *const __user *__argv, const char __user *const __user *__envp);

int my_wait(pid_t pid)
{
	struct wait_opts wo;
	struct pid *wo_pid = NULL;
	enum pid_type type;
	type = PIDTYPE_PID;

	wo_pid = find_get_pid(pid); // Look up the pid from hash table and return with it's count evaluated

	wo.wo_type = type;
	wo.wo_pid = wo_pid;
	wo.wo_flags = WEXITED | WUNTRACED;
	wo.wo_info = NULL;
	wo.wo_stat = -1;
	wo.wo_rusage = NULL;

	do_wait(&wo);
	put_pid(wo_pid); // Decrease the count and free memory

	return (wo.wo_stat); // do_wait returns the status of the child process
}

int my_exec(void)
{
	struct filename *filename = getname_kernel(TEST_PATH);
	int res = do_execve(filename, NULL, NULL);
	if (!res)
		return 0;
	else
		do_exit(res);
}

// implement fork function
int my_fork(void *argc)
{
	// set default sigaction for current process
	int i;
	int status;
	pid_t pid;
	struct kernel_clone_args kernel_args = {
		.exit_signal = SIGCHLD,
		.flags = SIGCHLD,
		.stack = (unsigned long)&my_exec,
		.stack_size = 0,
	};

	struct k_sigaction *k_action = &current->sighand->action[0];
	for (i = 0; i < _NSIG; i++)
	{
		k_action->sa.sa_handler = SIG_DFL;
		k_action->sa.sa_flags = 0;
		k_action->sa.sa_restorer = NULL;
		sigemptyset(&k_action->sa.sa_mask);
		k_action++;
	}

	/* todo: fork a process using kernel_clone or kernel_thread, execute a test program in child process */

	pid = kernel_clone(&kernel_args);
	printk("[program2] : The child process has pid = %d\n", pid);
	printk("[program2] : This is the parent process, pid = %d\n", (int)current->pid);

	/* todo: wait until child process terminates */
	status = my_wait(pid);

	printk("[program2] : child process");

	if (status == 6)
	{
		printk("[program2] : get SIGABRT signal\n");
	}
	else if (status == 14)
	{
		printk("[program2] : get SIGALRM signal\n");
	}
	else if (status == 7)
	{
		printk("[program2] : get SIGBUS signal\n");
	}
	else if (status == 8)
	{
		printk("[program2] : get SIGFPE signal\n");
	}
	else if (status == 1)
	{
		printk("[program2] : get SIGHUP signal\n");
	}
	else if (status == 4)
	{
		printk("[program2] : get SIGILL signal\n");
	}
	else if (status == 2)
	{
		printk("[program2] : get SIGINT signal\n");
	}
	else if (status == 9)
	{
		printk("[program2] : get SIGKILL signal\n");
	}
	else if (status == 13)
	{
		printk("[program2] : get SIGPIPE signal\n");
	}
	else if (status == 11)
	{
		printk("[program2] : get SIGSEGV signal\n");
	}
	else if (status == 15)
	{
		printk("[program2] : get SIGTERM signal\n");
	}
	else if (status == 5)
	{
		printk("[program2] : get SIGTRAP signal\n");
	}

	printk("[program2] : The return signal is %d\n", status);
	return 0;
}

static int __init program2_init(void)
{
	printk("[program2] : module_init\n");
	printk("[program2] : module_init create kthread start\n");

	/* create a kernel thread to run my_fork */
	thread = kthread_create(&my_fork, NULL, "Mythread");
	if (!IS_ERR(thread))
	{
		printk("[program2] : module_init kthread start\n");
		wake_up_process(thread);
	}

	return 0;
}

static void __exit program2_exit(void)
{
	printk("[program2] : module_exit\n");
}

module_init(program2_init);
module_exit(program2_exit);
