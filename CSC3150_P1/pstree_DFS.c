#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/types.h>

#define MAX_NAME_LEN 256

typedef struct
{
    pid_t pid;
    char name[MAX_NAME_LEN];
} ChildProcess;

int compareChildProcess(const void *a, const void *b)
{
    return strcmp(((ChildProcess *)a)->name, ((ChildProcess *)b)->name);
}

void printProcessTreeDFS(pid_t pid, int depth, int is_last_child, int *sibling_map)
{
    char proc_name[MAX_NAME_LEN] = "Unknown";
    char cmd_line[MAX_NAME_LEN] = "";

    char status_path[MAX_NAME_LEN];
    snprintf(status_path, sizeof(status_path), "/proc/%ld/status", (long)pid);

    FILE *status_file = fopen(status_path, "r");
    if (status_file)
    {
        char line[MAX_NAME_LEN];
        while (fgets(line, sizeof(line), status_file))
        {
            if (sscanf(line, "Name: %s", proc_name) == 1)
            {
                continue;
            }
            if (sscanf(line, "Cmdline: %s", cmd_line) == 1)
            {
                continue;
            }
        }
        fclose(status_file);
    }

    // Print indentation and branching based on depth and whether this is the last child
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
            printf("└─");
            sibling_map[depth - 1] = 0;
        }
        else
        {
            printf("├─");
            sibling_map[depth - 1] = 1;
        }
    }

    // Print the process name and command line (if available)
    printf("%s", proc_name);

    // todo: print

    printf("\n");

    DIR *dir = opendir("/proc");
    if (!dir)
    {
        perror("opendir");
        exit(1);
    }

    struct dirent *entry;
    ChildProcess children[MAX_NAME_LEN];
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

            if (ppid == pid)
            {
                children[child_count].pid = atoi(entry->d_name);
                strncpy(children[child_count].name, child_name, MAX_NAME_LEN);
                child_count++;
            }
        }
    }

    closedir(dir);

    qsort(children, child_count, sizeof(ChildProcess), compareChildProcess);

    for (int i = 0; i < child_count; i++)
    {
        printProcessTreeDFS(children[i].pid, depth + 1, i == child_count - 1, sibling_map);
    }
}

int main()
{
    printf("pstree:\n");
    int sibling_map[MAX_NAME_LEN] = {0};
    printProcessTreeDFS(1, 0, 1, sibling_map);
    return 0;
}
