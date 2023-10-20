#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <curses.h>
#include <termios.h>
#include <fcntl.h>

int main()
{
    int isStop = 0;
    while (!isStop)
    {
        printf("printing within loop!\n");
        //        system("clear");
        printf("\033[2J");

        //        printf("\033[H\033[2J"); // clear the screen
    }

    //    printf("hello\n");
    //    system("clear");
    //    printf("\033[2J");
    //  printf("\033[H\033[2J");

    //    puts( "first");
    //    printf("\033[H\033[2J"); // clear the screen
    //        system("clear");
    //
    //    for(int i = 0; i <= 10; ++i)
    //        puts( "wbac");
    //    printf("\033[?25l");
    //    while (1){
    //
    //    }
    //    system("clear");
}