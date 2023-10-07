#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/types.h>

#define MAX_DEPTH 100

// Function to recursively print the process tree
void printProcessTree(pid_t pid, int depth)
{
    // Check if the maximum depth has been reached
    if (depth >= MAX_DEPTH)
    {
        return;
    }

    // Open the /proc directory
    DIR *dir = opendir("/proc");
    if (!dir)
    {
        perror("opendir");
        exit(1);
    }

    // Read the /proc directory
    struct dirent *entry;
    while ((entry = readdir(dir)))
    {
        // Check if the entry is a directory and its name is a number (process ID)
        if (entry->d_type == DT_DIR && atoi(entry->d_name))
        {
            // Open the status file for the process
            char status_path[256];
            snprintf(status_path, sizeof(status_path), "/proc/%s/status", entry->d_name);
            FILE *status_file = fopen(status_path, "r");
            if (!status_file)
            {
                continue;
            }

            char line[256];
            char name[256];
            int ppid = -1;

            // Read the status file to get the process name and parent PID
            while (fgets(line, sizeof(line), status_file))
            {
                if (sscanf(line, "Name: %s", name) == 1)
                {
                    continue;
                }
                if (sscanf(line, "PPid: %d", &ppid) == 1)
                {
                    continue;
                }
            }

            fclose(status_file);

            // If the parent PID matches the current process, print it
            if (ppid == pid)
            {
                for (int i = 0; i < depth; i++)
                {
                    printf("  ");
                }
                printf("%s\n", name);

                // Recursively print the children of this process
                printProcessTree(atoi(entry->d_name), depth + 1);
            }
        }
    }

    closedir(dir);
}

int main()
{
    printf("System\n");
    printProcessTree(1, 1); // Start with the init process (PID 1) at depth 1
    return 0;
}
