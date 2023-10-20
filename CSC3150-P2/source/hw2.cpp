#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <curses.h>
#include <termios.h>
#include <fcntl.h>

#define ROW 10
#define COLUMN 50
#define LOG_LENGTH 15

bool game_status = true;
pthread_mutex_t frog_thread;
pthread_mutex_t log_thread;

struct Node
{
	int x, y;
	Node(int _x, int _y) : x(_x), y(_y){};
	Node(){};
} frog;

char map[ROW + 10][COLUMN];

// Determine a keyboard is hit or not. If yes, return 1. If not, return 0.
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

	/*  todo: Move the logs  */

	/*  todo: Check keyboard hits, to change frog's position or quit the game. */

	/*  todo: Check game's status  */

	/*  todo: Print the map on the screen  */
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

	// Print the map into screen
	for (i = 0; i <= ROW; ++i)
		puts(map[i]);

	/*  todo: Create pthreads for wood move and frog control.  */
	pthread_mutex_init(&frog_thread, NULL);
	pthread_mutex_init(&log_thread, NULL);

	// todo: initialize the logs

	/*  todo: Display the output for user: win, lose or quit.  */

	return 0;
}
