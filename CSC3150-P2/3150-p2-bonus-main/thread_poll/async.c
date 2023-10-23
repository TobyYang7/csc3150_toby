#include <stdlib.h>
#include <pthread.h>
#include "async.h"
#include "utlist.h"
#include <stdio.h>

my_queue_t *job_queue;

void *worker_thread(void *arg)
{
    while (1)
    {
        pthread_mutex_lock(&job_queue->mutex);

        while (job_queue->head == NULL)
        {
            pthread_cond_wait(&job_queue->cond, &job_queue->mutex);
        }

        my_item_t *job = job_queue->head;
        DL_DELETE(job_queue->head, job);

        pthread_mutex_unlock(&job_queue->mutex);

        if (job != NULL)
        {
            printf("Thread ID %lu: Processing a job...\n", current_thread_id);
            job->handler(job->args);
            free(job);
            printf("Thread ID %lu: Completed the job.\n", current_thread_id);
        }
    }

    return NULL;
}

void async_init(int num_threads)
{
    job_queue = (my_queue_t *)malloc(sizeof(my_queue_t));
    job_queue->head = NULL;
    pthread_mutex_init(&job_queue->mutex, NULL);
    pthread_cond_init(&job_queue->cond, NULL);

    for (int i = 0; i < num_threads; i++)
    {
        pthread_t thread;
        pthread_create(&thread, NULL, worker_thread, NULL);
    }
}

void async_run(void (*handler)(int), int args)
{
    my_item_t *job = (my_item_t *)malloc(sizeof(my_item_t));
    job->handler = handler;
    job->args = args;
    pthread_mutex_init(&job->mutex, NULL);
    pthread_cond_init(&job->cond, NULL);

    pthread_mutex_lock(&job_queue->mutex);
    DL_APPEND(job_queue->head, job);
    pthread_cond_signal(&job_queue->cond);
    pthread_mutex_unlock(&job_queue->mutex);

    pthread_mutex_lock(&job->mutex);
    pthread_cond_wait(&job->cond, &job->mutex);
    pthread_mutex_unlock(&job->mutex);

    pthread_cond_destroy(&job->cond);
    pthread_mutex_destroy(&job->mutex);
}
