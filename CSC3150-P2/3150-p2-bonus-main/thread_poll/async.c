#include <stdlib.h>
#include <pthread.h>
#include "async.h"
#include "utlist.h"
#include <stdio.h>

my_queue_t *job_queue;
int global_thread_count = 0;

void *worker_thread(void *arg)
{
    global_thread_count++;
    int local_count = global_thread_count;
    printf("\nStarting Thread Number: %d\n", global_thread_count);
    pthread_t current_thread_id = pthread_self();
    printf("Thread ID %lu: Initializing...\n", current_thread_id);

    while (1)
    {
        pthread_mutex_lock(&job_queue->mutex);

        if (job_queue->head == NULL)
        {
            printf("Thread ID %lu: No jobs in the queue, waiting...\n", current_thread_id);
        }

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
    job_queue = malloc(sizeof(my_queue_t));
    job_queue->size = 0;
    job_queue->head = NULL;
    pthread_mutex_init(&job_queue->mutex, NULL);
    pthread_cond_init(&job_queue->cond, NULL);

    printf("Initializing with %d threads...\n", num_threads);
    for (int i = 0; i < num_threads; i++)
    {
        pthread_t thread;
        pthread_create(&thread, NULL, worker_thread, NULL);
        printf("Thread %d has been created.\n", i + 1);
    }
    printf("All threads initialized.\n");
}

void async_run(void (*handler)(int), int args)
{
    my_item_t *job = malloc(sizeof(my_item_t));
    job->handler = handler;
    job->args = args;

    pthread_mutex_lock(&job_queue->mutex);
    DL_APPEND(job_queue->head, job);
    int jobs_in_queue;
    DL_COUNT(job_queue->head, job, jobs_in_queue);
    printf("Added a new job. Total jobs in queue: %d\n", jobs_in_queue);
    pthread_cond_signal(&job_queue->cond);
    pthread_mutex_unlock(&job_queue->mutex);
}
