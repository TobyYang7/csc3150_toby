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

#include <linux/sched.h>

MODULE_LICENSE("GPL");

static struct task_struct *task;

extern pid_t kernel_clone(struct kernel_clone_args *args);
extern struct filename *getname_kernel(const char *filename);
extern long do_wait(struct wait_opts *wo);
extern int do_execve(struct filename *filename, const char __user *const __user *__argv, const char __user *const __user *__envp);

int my_wait(pid_t pid)
{
	int status;
	int a;

	struct wait_opts wo;
	struct pid *wo_pid = NULL;
	enum pid_type type;
	type = PIDTYPE_PID;

	wo_pid = find_get_pid(pid);

	wo.wo_type = type;
	wo.wo_pid = wo_pid;
	wo.wo_flags = WEXITED | WUNTRACED;
	wo.wo_info = NULL;
	wo.wo_stat = (int __user *)&status;
	// wo.wo_stat = -1;
	wo.wo_rusage = NULL;

	do_wait(&wo);
	put_pid(wo_pid);

	return (wo.wo_stat);
}

int my_exec(void)
{
	// execute a test program in child process
	// todo
	return 0;
}

// implement fork function
int my_fork(void *argc)
{

	// set default sigaction for current process
	int i;
	struct k_sigaction *k_action = &current->sighand->action[0];
	for (i = 0; i < _NSIG; i++)
	{
		k_action->sa.sa_handler = SIG_DFL;	// 设置信号处理程序为默认值
		k_action->sa.sa_flags = 0;			// 设置标志为0
		k_action->sa.sa_restorer = NULL;	// 设置恢复程序为NULL
		sigemptyset(&k_action->sa.sa_mask); // 清空信号屏蔽字
		k_action++;
	}

	long pid;

	/* fork a process using kernel_clone or kernel_thread */
	// todo
	struct kernel_clone_args args = {
		.flags = CLONE_FS | CLONE_FILES | CLONE_SIGHAND | CLONE_VM,
	};
	pid = kernel_clone(&args);
	printk("[program2] : The child process has pid = %ld\n", pid);
	printk("[program2] : This is the parent process, pid = %d\n", (int)current->pid);

	/* execute a test program in child process */
	// todo

	/* wait until child process terminates */
	int status = my_wait(pid);
}

static int __init program2_init(void)
{
	printk("[program2] : module_init\n");
	printk("[program2] : module_init create kthread start\n");

	/* create a kernel thread to run my_fork */
	task = kthread_create(&my_fork, NULL, "Mythread");
	if (!IS_ERR(task))
	{
		printk("[program2] : module_init Kthread starts\n");
		wake_up_process(task);
	}

	return 0;
}

static void __exit program2_exit(void)
{
	printk("[program2] : Module_exit\n");
}

module_init(program2_init); // 模块初始化函数
module_exit(program2_exit); // 模块退出函数
