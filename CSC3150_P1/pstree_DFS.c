#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/types.h>

#define MAX_NAME_LEN 256

void printProcessTreeDFS(pid_t pid, int depth, int is_last_child, int *sibling_map)
{
    char proc_name[MAX_NAME_LEN] = "Unknown";

    // Construct the path to the status file
    char status_path[MAX_NAME_LEN];
    snprintf(status_path, sizeof(status_path), "/proc/%ld/status", (long)pid);

    // Open the status file
    FILE *status_file = fopen(status_path, "r");
    if (status_file)
    {
        char line[MAX_NAME_LEN];
        // Read the status file to get the process name
        while (fgets(line, sizeof(line), status_file))
        {
            if (sscanf(line, "Name: %s", proc_name) == 1)
            {
                break;
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
            printf("└───");
            sibling_map[depth - 1] = 0;
        }
        else
        {
            printf("├───");
            sibling_map[depth - 1] = 1;
        }
    }

    // Print the process name
    printf("%s\n", proc_name);

    // Open the /proc directory
    DIR *dir = opendir("/proc");
    if (!dir)
    {
        perror("opendir");
        exit(1);
    }

    struct dirent *entry;
    pid_t children[MAX_NAME_LEN]; // Temporary array to store child processes
    int child_count = 0;          // Counter for child processes

    // Iterate through the /proc directory
    while ((entry = readdir(dir)))
    {
        // Check if the entry is a directory and its name is a number (process ID)
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
            int ppid = -1;
            // Read the status file to get the parent PID
            while (fgets(line, sizeof(line), status_file))
            {
                if (sscanf(line, "PPid: %d", &ppid) == 1)
                {
                    break;
                }
            }

            fclose(status_file);

            // If the parent PID matches the current process, add it to the temporary array
            if (ppid == pid)
            {
                children[child_count++] = atoi(entry->d_name);
            }
        }
    }

    closedir(dir);

    // Recursively call the function for each child process
    for (int i = 0; i < child_count; i++)
    {
        printProcessTreeDFS(children[i], depth + 1, i == child_count - 1, sibling_map);
    }
}

int main()
{
    printf("pstree:\n");
    int sibling_map[MAX_NAME_LEN] = {0}; // To keep track of which levels have siblings
    // Start DFS with the init process (PID 1) and depth 0
    printProcessTreeDFS(1, 0, 1, sibling_map);
    return 0;
}
