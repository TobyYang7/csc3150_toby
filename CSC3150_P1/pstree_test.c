#include <stdio.h>
#include <dirent.h>
#include <string.h>
#include <stdlib.h>

typedef struct Process
{
    int pid;
    int ppid;
    char name[256];
    int child_count;      // Count of child processes
    struct Process *prev; // Pointer to the previous process
    struct Process *next; // Pointer to the next process
    struct Process *child;
    struct Process *last_child; // for constructing tree
} Process;

Process *get_process_details(int pid)
{
    char path[256];
    Process *proc = (Process *)malloc(sizeof(Process));
    if (!proc)
        return NULL;

    sprintf(path, "/proc/%d/stat", pid);

    FILE *file = fopen(path, "r");
    if (!file)
    {
        free(proc);
        return NULL;
    }

    fscanf(file, "%d %s %*c %d", &proc->pid, proc->name, &proc->ppid);
    fclose(file);

    proc->name[strlen(proc->name) - 1] = '\0';               // Remove the closing parenthesis
    memmove(proc->name, proc->name + 1, strlen(proc->name)); // Remove the opening parenthesis

    proc->child_count = 0;
    proc->prev = NULL;
    proc->next = NULL;
    proc->child = NULL;
    proc->last_child = NULL;

    return proc;
}

void unlink_process(Process *proc)
{
    if (proc->prev)
    {
        proc->prev->next = proc->next;
    }
    if (proc->next)
    {
        proc->next->prev = proc->prev;
    }
    proc->prev = NULL;
    proc->next = NULL;
}

void build_tree(Process *root, Process *proc_list)
{
    Process *temp = proc_list;
    while (temp)
    {
        Process *next_temp = temp->next; // Store the next process since we might unlink the current one
        if (temp->ppid == root->pid)
        {
            unlink_process(temp); // Unlink from the list
            root->child_count++;
            // Attach as a child
            if (!root->child)
            {
                root->child = temp;
                root->last_child = temp;
            }
            else
            {
                root->last_child->next = temp;
                root->last_child = temp;
            }
            build_tree(temp, proc_list);
        }
        temp = next_temp;
    }
}

void display_tree(Process *proc, int depth, int last_siblings[], int flags)
{
    if (!proc)
    {
        return;
    }

    // Print indentation
    for (int i = 0; i < depth - 1; i++)
    {
        if (last_siblings[i])
        {
            printf("    "); // 4 spaces if last sibling
        }
        else
        {
            printf("│   ");
        }
    }

    if (depth > 0)
    {
        if (last_siblings[depth - 1])
        {
            printf("└─");
        }
        else
        {
            printf("├─");
        }
    }
    if (flags == 0)
    {
        printf("%s \n", proc->name);
    }
    else if (flags == 1)
    {
        printf("%s (PID %d)\n", proc->name, proc->pid);
    }

    Process *child = proc->child;
    while (child)
    {
        int is_last = (child->next == NULL);
        last_siblings[depth] = is_last;
        display_tree(child, depth + 1, last_siblings, flags);
        child = child->next;
    }
}

int main(int argc, char *argv[])
{
    DIR *dir;
    int last_siblings[256] = {0}; // assuming a maximum depth of 256
    struct dirent *entry;
    Process *proc_list = NULL;
    Process *last_proc = NULL;
    int flags = 0;

    for (int i = 1; i < argc; i++)
    {
        if (strcmp(argv[i], "-p") == 0)
        {
            flags = 1; // Set the flag to show PIDs
            break;
        }
        else if (strcmp(argv[i], "-V") == 0)
        {
            printf("pstree Created by Butian Xiong (butianxiong@link.cuhk.edu.cn)\nCreated under GNU General Public License\nThis is free software, and you are welcome to redistribute it under\nthe terms of the GNU General Public License.\nFor more information about these matters, see the files named COPYING.\n");
            return 0;
        }
        else
        {
            printf("Usage: test [-V], [-p]\n");
            printf("test display a tree of a process\n");
            printf("-V show the version and claim\n");
            printf("-p show the pid\n");
            printf("if you don't put any flag it will not show the pid\n");
            return 0;
        }
    }

    // Read processes from /proc
    if ((dir = opendir("/proc")) != NULL)
    {
        while ((entry = readdir(dir)) != NULL)
        {
            int pid;
            if (sscanf(entry->d_name, "%d", &pid) == 1)
            {
                Process *proc = get_process_details(pid);
                if (proc)
                {
                    if (!proc_list)
                    {
                        proc_list = proc;
                    }
                    else
                    {
                        last_proc->next = proc; // set the next process
                        proc->prev = last_proc; // Set the previous pointer
                    }
                    last_proc = proc;
                }
            }
        }
        closedir(dir);
    }

    // Assuming init process has PID 1
    Process *init = get_process_details(1);
    printf("We already finished the link list construction\n");
    build_tree(init, proc_list);
    display_tree(init, 0, last_siblings, flags);

    // Clean up
    // You should also write functions to free up the memory.

    return 0;
}
