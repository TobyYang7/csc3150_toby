#include <stdlib.h>
#include <pthread.h>
#include "async.h"
#include "utlist.h"
#include <stdio.h>

my_queue_t *job_queue;       // Pointer to the job queue
int global_thread_count = 0; // Global thread count

// Worker thread function
void *worker_thread(void *arg)
{
    global_thread_count++;                                                  // Increment the global thread count
    int local_count = global_thread_count;                                  // Store the global thread count in a local variable
    printf("\nStarting Thread Number: %d\n", global_thread_count);          // Print the global thread count
    pthread_t current_thread_id = pthread_self();                           // Get the ID of the current thread
    printf("-----THREAD ID %lu----- Initializing...\n", current_thread_id); // Print the ID of the current thread

    while (1)
    {
        pthread_mutex_lock(&job_queue->mutex); // Lock the job queue mutex

        if (job_queue->head == NULL) // If there are no jobs in the queue
        {
            printf("-----THREAD ID %lu----- No jobs in the queue, waiting...\n", current_thread_id); // Print a message indicating that the thread is waiting
        }

        while (job_queue->head == NULL) // Wait until there is a job in the queue
        {
            pthread_cond_wait(&job_queue->cond, &job_queue->mutex); // Wait for a signal on the job queue condition variable
        }

        my_item_t *job = job_queue->head; // Get the first job in the queue
        DL_DELETE(job_queue->head, job);  // Remove the job from the queue

        pthread_mutex_unlock(&job_queue->mutex); // Unlock the job queue mutex

        if (job != NULL) // If a job was retrieved from the queue
        {
            printf("-----THREAD ID %lu----- Processing a job...\n", current_thread_id); // Print a message indicating that the thread is processing a job
            job->handler(job->args);                                                    // Call the job handler function with the job arguments
            free(job);                                                                  // Free the memory allocated for the job
            printf("-----THREAD ID %lu----- Completed the job.\n", current_thread_id);  // Print a message indicating that the thread has completed the job
        }
    }
    return NULL;
}

// Initialize the job queue with the specified number of threads
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

// Add a new job to the job queue
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
