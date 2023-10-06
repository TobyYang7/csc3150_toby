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

int my_wait(int *status)
{
	// wait for child process to terminate
	// todo
	return 0;
}

int my_exec(void)
{
	// execute a test program in child process
	// todo
	return 0;
}

// implement fork function
int my_fork(void *argc) // 实现fork函数
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
	pid = kernel_clone(my_fork, NULL, SIGCHLD | CLONE_FS | CLONE_FILES | CLONE_SIGHAND | CLONE_VM, NULL);
	printk("[program2] : The child process has pid = %ld\n", pid);
	printk("[program2] : This is the parent process, pid = %d\n", (int)current->pid);

	/* execute a test program in child process */
	// todo
	my_exec();

	/* wait until child process terminates */
	my_wait((pid_t)pid);

	return 0;
}

static int __init program2_init(void)
{
	// 模块初始化函数
	printk("[program2] : module_init\n");
	printk("[program2] : module_init create kthread start\n");

	/* create a kernel thread to run my_fork */
	// 创建一个内核线程来运行my_fork函数
	task = kthread_create(&my_fork, NULL, "Mythread");
	if (!IS_ERR(task))
	{
		printk("[program2] : module_init Kthread starts\n");
		wake_up_process(task); // 唤醒内核线程
	}

	return 0;
}

static void __exit program2_exit(void)
{
	// 模块退出函数
	printk("[program2] : Module_exit\n");
}

module_init(program2_init); // 模块初始化函数
module_exit(program2_exit); // 模块退出函数
