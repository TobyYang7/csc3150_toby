#include <stdlib.h>
#include <pthread.h>
#include "async.h"
#include "utlist.h"

my_queue_t *queue;

void *thread_function(void *arg)
{
    while (1)
    {
        pthread_mutex_lock(&(queue->mutex));
        while (queue->size == 0)
        {
            pthread_cond_wait(&(queue->cond), &(queue->mutex));
        }
        job_t *job;
        DL_DELETE(queue->head, queue->head);
        job = queue->head;
        queue->size--;
        pthread_mutex_unlock(&(queue->mutex));

        job->function(job->arg); // Execute the job

        free(job); // Free the job structure after execution
    }
    return NULL;
}

void async_init(int num_threads)
{
    queue = malloc(sizeof(my_queue_t));
    if (queue == NULL)
    {
        // Handle malloc failure
        exit(EXIT_FAILURE);
    }
    queue->size = 0;
    queue->head = NULL;
    pthread_mutex_init(&(queue->mutex), NULL);
    pthread_cond_init(&(queue->cond), NULL);

    for (int i = 0; i < num_threads; i++)
    {
        pthread_t thread;
        pthread_create(&thread, NULL, thread_function, NULL);
        pthread_detach(thread);
    }
}

void async_run(void (*handler)(int), int args)
{
    job_t *job = malloc(sizeof(job_t));
    if (job == NULL)
    {
        // Handle malloc failure
        exit(EXIT_FAILURE);
    }
    job->function = handler;
    job->arg = args;

    pthread_mutex_lock(&(queue->mutex));
    DL_APPEND(queue->head, job); // Add job to the queue
    queue->size++;
    pthread_cond_signal(&(queue->cond)); // Signal a thread to wake up and execute a job
    pthread_mutex_unlock(&(queue->mutex));
}
