//
// Created by lemaker on 2023/10/17.
//
/* CELEBP22 */
#define _OPEN_THREADS
#include <pthread.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <stdlib.h>

pthread_cond_t cond;
pthread_mutex_t mutex;

int footprint = 0;

void *thread_1_fun(void *arg)
{
    time_t T;

    if (pthread_mutex_lock(&mutex) != 0)
    {
        perror("pthread_mutex_lock() error");
        exit(6);
    }
    time(&T);
    printf("Thread-1: starting wait at %s", ctime(&T));
    footprint++;
    printf("Thread-1: incrementing the variable footprint by 1, footprint=%d\n", footprint);
    if (pthread_cond_wait(&cond, &mutex) != 0)
    {
        perror("pthread_cond_timedwait() error");
        exit(7);
    }
    time(&T);
    printf("Thread-1: wait over at %s", ctime(&T));
}

int main()
{
    pthread_t thread_1;
    time_t T;
    struct timespec t;

    if (pthread_mutex_init(&mutex, NULL) != 0)
    {
        perror("pthread_mutex_init() error");
        exit(1);
    }

    if (pthread_cond_init(&cond, NULL) != 0)
    {
        perror("pthread_cond_init() error");
        exit(2);
    }

    if (pthread_create(&thread_1, NULL, thread_1_fun, NULL) != 0)
    {
        perror("pthread_create() error");
        exit(3);
    }

    while (footprint == 0)
    {
        // make sure that the thread-1 increments the variable footprint by 1
        sleep(1);
    }

    puts("Thread-main: is about ready to release the thread");
    sleep(2);

    if (pthread_cond_signal(&cond) != 0)
    {
        perror("pthread_cond_signal() error");
        exit(4);
    }

    if (pthread_join(thread_1, NULL) != 0)
    {
        perror("pthread_join() error");
        exit(5);
    }
}