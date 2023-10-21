#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <termios.h>
#include <fcntl.h>

#define ROW 10
#define COLUMN 50
#define LOG_LENGTH 15
#define LOG_SPEED 100000

bool game_status = true;
bool win = false;
bool quit = false;
pthread_mutex_t frog_mutex;
pthread_mutex_t log_mutex;

struct Node
{
    int x, y;
    Node(int _x, int _y) : x(_x), y(_y){};
    Node(){};
} frog;

char map[ROW + 10][COLUMN];

bool is_frog_safe()
{
    pthread_mutex_lock(&log_mutex);
    bool safe = map[frog.x][frog.y] == '=' || frog.x == 0 || frog.x == ROW;
    pthread_mutex_unlock(&log_mutex);
    return safe;
}

void clear_frog_position()
{
    pthread_mutex_lock(&frog_mutex);
    for (int i = 0; i <= ROW; ++i)
        for (int j = 0; j < COLUMN; ++j)
            if (map[i][j] == '0')
                map[i][j] = (i == 0 || i == ROW || map[i][j] == '=') ? map[i][j] : ' ';
    pthread_mutex_unlock(&frog_mutex);
}

int kbhit(void)
{
    struct termios oldt, newt;
    int ch;
    int oldf;

    tcgetattr(STDIN_FILENO, &oldt);

    newt = oldt;
    newt.c_lflag &= ~(ICANON | ECHO);

    tcsetattr(STDIN_FILENO, TCSANOW, &newt);
    oldf = fcntl(STDIN_FILENO, F_GETFL, 0);

    fcntl(STDIN_FILENO, F_SETFL, oldf | O_NONBLOCK);

    ch = getchar();

    tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
    fcntl(STDIN_FILENO, F_SETFL, oldf);

    if (ch != EOF)
    {
        ungetc(ch, stdin);
        return 1;
    }
    return 0;
}

void *logs_move(void *t)
{
    while (game_status)
    {
        pthread_mutex_lock(&log_mutex);

        for (int i = 1; i < ROW; ++i)
        {
            for (int j = COLUMN - 2; j >= 0; --j) // start from right to left
            {
                if (map[i][j] == '=')
                {
                    map[i][j] = ' ';
                    if (j + 1 < COLUMN - 1) // check if the log is at the end of the column
                    {
                        map[i][j + 1] = '=';
                        if (frog.x == i && frog.y == j) // check if frog is on this log
                        {
                            frog.y++; // move frog with the log
                        }
                    }
                    else // reset log to the beginning of the column
                    {
                        map[i][0] = '=';
                    }
                }
            }
        }

        pthread_mutex_unlock(&log_mutex);
        usleep(LOG_SPEED); // Sleep for a short duration before the next iteration
    }
    return NULL;
}

void *frog_move(void *t)
{
    while (game_status)
    {
        pthread_mutex_lock(&frog_mutex);

        if (kbhit())
        {
            int ch = getchar();
            if ((ch == 'w' || ch == 'W') && frog.x > 0)
                frog.x--; // move up
            if ((ch == 's' || ch == 'S') && frog.x < ROW)
                frog.x++; // move down
            if ((ch == 'a' || ch == 'A') && frog.y > 0)
                frog.y--; // move left
            if ((ch == 'd' || ch == 'D') && frog.y < COLUMN - 1)
                frog.y++; // move right
            if (ch == 'q' || ch == 'Q')
                quit = true; // quit game
        }

        // Check game's status
        if (frog.x == 0)
        {
            win = true;
            game_status = false;
        }
        else if (!is_frog_safe())
        {
            game_status = false;
        }
        else if (quit)
        {
            game_status = false;
        }

        pthread_mutex_unlock(&frog_mutex);
        usleep(LOG_SPEED); // Sleep for a short duration before the next iteration
    }
    return NULL;
}

void update_map()
{
    system("clear"); // Clear the terminal

    pthread_mutex_lock(&log_mutex);
    pthread_mutex_lock(&frog_mutex);

    clear_frog_position();     // Clear previous frog position
    map[frog.x][frog.y] = '0'; // Update frog position

    for (int i = 0; i <= ROW; ++i)
        puts(map[i]);

    pthread_mutex_unlock(&frog_mutex);
    pthread_mutex_unlock(&log_mutex);
}

int main(int argc, char *argv[])
{
    srand(time(NULL));

    // Initialize the river map and frog's starting position
    memset(map, 0, sizeof(map));
    int i, j;
    for (i = 1; i < ROW; ++i)
    {
        for (j = 0; j < COLUMN - 1; ++j)
            map[i][j] = ' ';
    }

    for (j = 0; j < COLUMN - 1; ++j)
        map[ROW][j] = map[0][j] = '|';

    for (j = 0; j < COLUMN - 1; ++j)
        map[0][j] = map[0][j] = '|';

    frog = Node(ROW, (COLUMN - 1) / 2);
    map[frog.x][frog.y] = '0';

    // Initialize the log position
    for (i = 1; i < ROW; i += 1)
    {
        int log_start = rand() % (COLUMN - LOG_LENGTH);
        for (j = log_start; j < log_start + LOG_LENGTH; ++j)
            map[i][j] = '=';
    }

    // Print the map into screen
    for (i = 0; i <= ROW; ++i)
        puts(map[i]);

    // Create pthreads for wood move and frog control.
    pthread_t log_thread, frog_thread;
    pthread_create(&log_thread, NULL, logs_move, NULL);
    pthread_create(&frog_thread, NULL, frog_move, NULL);

    while (game_status)
    {
        update_map();
        usleep(LOG_SPEED); // Sleep for a short duration before the next iteration
    }

    pthread_join(log_thread, NULL);
    pthread_join(frog_thread, NULL);

    pthread_mutex_destroy(&log_mutex);
    pthread_mutex_destroy(&frog_mutex);

    if (win)
        printf("You win!\n");
    else if (quit)
        printf("You quit!\n");
    else
        printf("You lose!\n");

    return 0;
}
