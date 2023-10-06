int main()
// {
//     pid_t parent_pid = getpid(); // 获取父进程的PID

//     printf("Parent process PID: %d\n", parent_pid);

//     // 创建一个子进程
//     pid_t child_pid = fork();

//     if (child_pid < 0)
//     {
//         perror("Fork failed");
//         return 1;
//     }
//     else if (child_pid == 0)
//     {
//         // 这是子进程的代码块
//         printf("This is the child process. PID: %d\n", getpid());

//         // 模拟子进程的终止
//         printf("Child process is terminating.\n");

//         // 子进程终止
//         _exit(0);
//     }
//     else
//     {
//         // 这是父进程的代码块
//         printf("This is the parent process. Child PID: %d\n", child_pid);

//         // 等待子进程终止并获取其退出状态
//         int status;
//         wait(&status);

//         printf("Child process has terminated. Parent process is also terminating.\n");
//     }

//     return 0;
// }