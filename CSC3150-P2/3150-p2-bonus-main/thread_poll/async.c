#include <stdlib.h>
#include <pthread.h>
#include "async.h"
#include "utlist.h"
#include <stdio.h>

// an array of threads

my_queue_t *work_q_pt;
pthread_mutex_t mutexQueue;
pthread_cond_t condQueue;

int thread_count = 0;

void *startThread(void *args)
{
    thread_count++;
    int local_num = thread_count;
    printf("start %d\n", thread_count);
    while (1)
    {
        my_item_t *task;
        pthread_mutex_lock(&mutexQueue);
        while (work_q_pt->size == 0)
        {
            pthread_cond_wait(&condQueue, &mutexQueue);
            printf("thread %d condition wait\n", local_num);
        }
        task = work_q_pt->head;
        DL_DELETE(work_q_pt->head, work_q_pt->head);
        work_q_pt->size--;
        pthread_mutex_unlock(&mutexQueue);

        printf("task.args = %d\n", task->args);
        printf("task.taskFunction = %d\n", (task->taskFunction));
        task->taskFunction(task->args);
        printf("done...\n");
    }
}

void async_init(int num_threads)
{
    /** TODO: create num_threads threads and initialize the thread pool **/
    my_queue_t queue = {
        .head = NULL,
        .size = 0};
    work_q_pt = (my_queue_t *)malloc(sizeof(queue));
    work_q_pt->head = NULL;
    work_q_pt->size = 0;

    pthread_mutex_init(&mutexQueue, NULL);
    pthread_cond_init(&condQueue, NULL);

    pthread_t threads[num_threads];
    for (int i = 0; i < num_threads; i++)
    {
        int rc = pthread_create(&threads[i], NULL, &startThread, NULL);
        if (rc)
        {
            printf("Failed to create pthread %d\n", i);
        }
    }

    return;
}

void async_run(void (*hanlder)(int), int args)
{
    // hanlder(args);
    my_item_t it = {
        .args = args,
        .next = NULL,
        .prev = NULL,
        .taskFunction = hanlder};
    my_item_t *it_pt;
    it_pt = (my_item_t *)malloc(sizeof(it));
    it_pt->args = args;
    it_pt->next = NULL;
    it_pt->prev = NULL;
    it_pt->taskFunction = hanlder;
    printf("item args = %d\n", it_pt->args);
    printf("item taskFunction = %d\n", (it_pt->taskFunction));
    pthread_mutex_lock(&mutexQueue);
    printf("enqueue    queue.size = %d \n", work_q_pt->size);
    DL_APPEND(work_q_pt->head, it_pt);
    work_q_pt->size++;
    pthread_mutex_unlock(&mutexQueue);

    pthread_cond_signal(&condQueue);

    return;
}