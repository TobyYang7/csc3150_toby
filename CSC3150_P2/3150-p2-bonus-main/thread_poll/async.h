#ifndef __ASYNC__
#define __ASYNC__

#include <pthread.h>

typedef struct my_item
{
  void (*handler)(int);
  int args;
  struct my_item *next;
  struct my_item *prev;
  pthread_mutex_t mutex;
  pthread_cond_t cond;
} my_item_t;

typedef struct my_queue
{
  int size;
  my_item_t *head;
  pthread_mutex_t mutex;
  pthread_cond_t cond;
} my_queue_t;

void async_init(int);
void async_run(void (*fx)(int), int args);

#endif
