#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/types.h>
#include <stdbool.h>
#include <unistd.h>
#include <ctype.h>
#include <pthread.h>

#define MAX_NAME_LEN 256

typedef struct
{
    pid_t pid;
    char name[MAX_NAME_LEN];
    bool have_child;
} Node;

/**
 * Reads all threads for a given process ID and stores them in the threads array.
 * @param pid Tqhe process ID for which to read threads.
 * @param threads Array to store thread information.
 * @param thread_count Pointer to an integer to store the number of threads.
 */
void readThreadsInProc(pid_t pid, Node *threads, int *thread_count)
{
    char proc_path[MAX_NAME_LEN];
    snprintf(proc_path, sizeof(proc_path), "/proc/%ld/task", (long)pid);

    DIR *dir = opendir(proc_path);
    if (!dir)
    {
        perror("opendir");
        exit(1);
    }

    struct dirent *entry;
    while ((entry = readdir(dir)))
    {
        if (entry->d_type == DT_DIR && atoi(entry->d_name))
        {
            char status_path[MAX_NAME_LEN];
            snprintf(status_path, sizeof(status_path), "/proc/%s/status", entry->d_name);
            FILE *status_file = fopen(status_path, "r");
            if (!status_file)
            {
                continue;
            }

            char line[MAX_NAME_LEN];
            char thread_name[MAX_NAME_LEN] = "Unknown";
            while (fgets(line, sizeof(line), status_file))
            {
                sscanf(line, "Name: %s", thread_name);
            }

            fclose(status_file);

            threads[*thread_count].pid = atoi(entry->d_name);
            strncpy(threads[*thread_count].name, thread_name, MAX_NAME_LEN);
            threads[*thread_count].have_child = false;
            (*thread_count)++;
        }
    }

    closedir(dir);
}

/**
 * Prints indentation and branching based on depth and whether this is the last child.
 * @param depth The current depth of the tree.
 * @param is_last_child Whether this process is the last child of its parent.
 * @param sibling_map Array of flags indicating whether the previous siblings at each depth were last children.
 */
void print_spaces(int depth, int is_last_child, int *sibling_map)
{
    for (int i = 0; i < depth - 1; ++i)
    {
        if (sibling_map[i])
        {
            printf("│   ");
        }
        else
        {
            printf("    ");
        }
    }
    if (depth > 0)
    {
        if (is_last_child)
        {
            printf("└──");
            sibling_map[depth - 1] = 0;
        }
        else
        {
            printf("├──");
            sibling_map[depth - 1] = 1;
        }
    }
}

/**
 * Compare function for sorting Node array by name.
 * @param a Pointer to first Node struct.
 * @param b Pointer to second Node struct.
 * @return Negative value if a should come before b, positive value if a should come after b, 0 if equal.
 */
int compareChildProcess(const void *a, const void *b)
{
    return strcmp(((Node *)a)->name, ((Node *)b)->name);
}

/**
 * Recursively prints the process tree in depth-first order.
 * @param pid The process ID to start the tree from.
 * @param depth The current depth of the tree.
 * @param is_last_child Whether this process is the last child of its parent.
 * @param sibling_map Array of flags indicating whether the previous siblings at each depth were last children.
 */
void printProcessTreeDFS(pid_t pid, int depth, int is_last_child, int *sibling_map)
{
    char proc_name[MAX_NAME_LEN] = "Unknown";
    int len = 0; // Length of the last process name printed
    bool have_child = false;

    Node threads[MAX_NAME_LEN];
    int thread_count = 0;

    // Get process information from the status file in /proc
    char status_path[MAX_NAME_LEN];
    snprintf(status_path, sizeof(status_path), "/proc/%ld/status", (long)pid);

    FILE *status_file = fopen(status_path, "r");
    if (status_file)
    {
        char line[MAX_NAME_LEN];
        while (fgets(line, sizeof(line), status_file))
        {
            // Extract process name
            if (sscanf(line, "Name: %s", proc_name) == 1)
            {
                continue;
            }
        }
        fclose(status_file);
    }

    print_spaces(depth, is_last_child, sibling_map);
    printf("%s", proc_name);

    // Traverse child processes
    DIR *dir = opendir("/proc");
    if (!dir)
    {
        perror("opendir");
        exit(1);
    }

    struct dirent *entry;
    Node children[MAX_NAME_LEN];
    int child_count = 0;

    while ((entry = readdir(dir)))
    {
        if (entry->d_type == DT_DIR && atoi(entry->d_name))
        {
            char status_path[MAX_NAME_LEN];
            snprintf(status_path, sizeof(status_path), "/proc/%s/status", entry->d_name);
            FILE *status_file = fopen(status_path, "r");
            if (!status_file)
            {
                continue;
            }

            char line[MAX_NAME_LEN];
            char child_name[MAX_NAME_LEN] = "Unknown";
            int ppid = -1;
            while (fgets(line, sizeof(line), status_file))
            {
                sscanf(line, "Name: %s", child_name);
                sscanf(line, "PPid: %d", &ppid);
            }

            fclose(status_file);

            // Check if the current process is a child of the specified parent process
            if (ppid == pid)
            {
                children[child_count].pid = atoi(entry->d_name);
                strncpy(children[child_count].name, child_name, MAX_NAME_LEN);
                child_count++;
                have_child = true;
            }
        }
    }

    closedir(dir);

    // Sort child processes for alphabet ordering
    qsort(children, child_count, sizeof(Node), compareChildProcess);

    // Recursively print the tree for each child process
    for (int i = 0; i < child_count; i++)
    {
        printProcessTreeDFS(children[i].pid, depth + 1, i == child_count - 1, sibling_map);
    }
}

int main()
{
    // printf("pstree:\n");
    int sibling_map[MAX_NAME_LEN] = {0};
    printProcessTreeDFS(1, 0, 1, sibling_map);
    return 0;
}
