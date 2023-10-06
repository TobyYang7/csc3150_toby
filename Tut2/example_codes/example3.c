#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(int argc, char *argv[])
{
    pid_t pid;                 // 定义进程ID
    int state;                 // 定义状态变量
    printf("Start to fork\n"); // 打印信息
    pid = fork();              // 创建子进程
    if (pid == -1)             // 如果创建失败
    {
        perror("error"); // 打印错误信息
        exit(1);         // 退出程序
    }
    else // 如果创建成功
    {
        if (pid == 0) // 如果是子进程
        {
            printf("This is a child process ...\n");
            char *arg[argc];                   // 定义参数数组
            for (int i = 0; i < argc - 1; i++) // 遍历参数
            {
                arg[i] = argv[i + 1]; // 将参数存入数组
            };
            arg[argc - 1] = NULL; // 数组最后一项为NULL

            printf("Child Process pid:%d\n",
                   getpid()); // 打印子进程ID

            printf("Child process start to execute test program:\n");

            /* execute test program */
            execve(arg[0], arg, NULL); // 执行程序

            printf("Check if replaced."); // 不会执行到这里

            // 处理错误
            perror("execve");
            exit(EXIT_FAILURE);
        }
        else // 如果是父进程
        {
            wait(&state);                         // 等待子进程结束
            printf("This is a parent process\n"); // 打印信息
            exit(0);                              // 退出程序
        }
    }
    return 0;
}