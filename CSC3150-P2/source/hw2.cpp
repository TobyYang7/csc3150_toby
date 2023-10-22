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
#define SLEEP 70000

bool game_status = true;
bool win = false;
bool lose = false;
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
bool alive_map[ROW + 10][COLUMN];

bool frog_is_alive()
{
    if (frog.y == -1 || frog.y == COLUMN - 1)
        return false;
    return alive_map[frog.x][frog.y];
}

void update_alive_map()
{
    memset(alive_map, true, sizeof(alive_map));
    for (int i = 1; i < ROW; ++i)
    {
        for (int j = 0; j < COLUMN - 1; ++j)
        {
            if (map[i][j] == ' ')
            {
                alive_map[i][j] = false;
            }
        }
    }
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
            char old_row[COLUMN];
            memcpy(old_row, map[i], COLUMN);

            for (int j = 0; j < COLUMN - 1; ++j)
            {
                if (i % 2 == 0)
                {
                    map[i][j] = old_row[(j + 1) % (COLUMN - 1)];
                }
                else
                {
                    map[i][j] = old_row[(j - 1 + COLUMN - 1) % (COLUMN - 1)];
                }
            }
        }

        pthread_mutex_unlock(&log_mutex);
        usleep(SLEEP);
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
            if ((ch == 'a' || ch == 'A'))
                frog.y--; // move left
            if ((ch == 'd' || ch == 'D'))
                frog.y++; // move right
            if (ch == 'q' || ch == 'Q')
                quit = true; // quit game
        }

        // Check game's status
        if (frog.x == 0)
        {
            win = true;
        }
        else if (quit)
        {
            game_status = false;
        }
        else if (!frog_is_alive())
        {
            lose = true; // Frog is in the water, end the game
        }
        else if (frog_is_alive())
        {
            if (frog.x % 2 == 1 && frog.x != 0 && frog.x != ROW)
            {
                frog.y++;
            }
            else if (frog.x % 2 == 0 && frog.x != 0 && frog.x != ROW)
            {
                frog.y--;
            }
        }

        pthread_mutex_unlock(&frog_mutex);
        usleep(SLEEP);
    }
    return NULL;
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

    frog = Node(ROW, (COLUMN - 1) / 2);
    map[frog.x][frog.y] = '0';

    // Initialize the log position
    for (i = 1; i < ROW; i += 1)
    {
        int log_start = rand() % (COLUMN - LOG_LENGTH);
        for (j = log_start; j < log_start + LOG_LENGTH; ++j)
            map[i][j] = '=';
    }

    update_alive_map();

    // Create pthreads for wood move and frog control.
    pthread_t log_thread, frog_thread;
    pthread_create(&log_thread, NULL, logs_move, NULL);
    pthread_create(&frog_thread, NULL, frog_move, NULL);

    while (game_status)
    {
        // update_map();

        system("clear"); // Clear the terminal

        pthread_mutex_lock(&log_mutex);
        pthread_mutex_lock(&frog_mutex);

        update_alive_map();

        // printf("Frog position: (%d, %d)\n", frog.x, frog.y);

        // printf("Alive map: \n");
        for (int i = 0; i <= ROW; ++i)
        {
            for (int j = 0; j < COLUMN - 1; ++j)
            {
                if (i == frog.x && j == frog.y)
                {
                    printf("0");
                    continue;
                }
                else if (alive_map[i][j] == 0)
                    printf(" ");
                else
                {
                    if (i == 0 || i == ROW)
                        printf("|");
                    else
                        printf("=");
                }

                // printf("%d", alive_map[i][j]);
            }
            printf("\n");
        }

        if (win || lose)
            game_status = false;
        usleep(SLEEP);
        pthread_mutex_unlock(&frog_mutex);
        pthread_mutex_unlock(&log_mutex);
    }

    pthread_join(log_thread, NULL);
    pthread_join(frog_thread, NULL);

    pthread_mutex_destroy(&log_mutex);
    pthread_mutex_destroy(&frog_mutex);

    if (win)
        printf("You win the game!\n");
    else if (quit)
        printf("You quit the game!\n");
    else if (lose)
        printf("You lose the game!\n");

    return 0;
}