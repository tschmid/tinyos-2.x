/*
 * Copyright (c) 2008, 2009 The Regents of the University  of California.
 * All rights reserved."
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the copyright holders nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */
#ifndef NO_IP_MALLOC
#include <stdint.h>
#include <stdio.h>
#include "ip_malloc.h"

uint8_t heap[IP_MALLOC_HEAP_SIZE];

void ip_malloc_init() {
  bndrt_t *b = (bndrt_t *)heap;
  *b = IP_MALLOC_HEAP_SIZE  & IP_MALLOC_LEN;
}

void *ip_malloc(uint16_t sz) {
  bndrt_t *cur = (bndrt_t *)heap;
  sz += sizeof(bndrt_t) * 2;
  sz += (sz % IP_MALLOC_ALIGN);

  while (((*cur & IP_MALLOC_LEN) < sz || (*cur & IP_MALLOC_INUSE) != 0) 
         && (uint8_t *)cur - heap < IP_MALLOC_HEAP_SIZE) {
    cur = (bndrt_t *)(((uint8_t *)cur) + ((*cur) & IP_MALLOC_LEN));
  }

  if ((uint8_t *)cur < heap + IP_MALLOC_HEAP_SIZE) {
    uint16_t oldsize = *cur & IP_MALLOC_LEN;
    bndrt_t *next;
    sz -= sizeof(bndrt_t);
    next = ((bndrt_t *)(((uint8_t *)cur) + sz));

    *cur = (sz & IP_MALLOC_LEN) | IP_MALLOC_INUSE;
    *next = (oldsize - sz) & IP_MALLOC_LEN;

    return cur + 1;
  } else return NULL;
}

void ip_free(void *ptr) {
  bndrt_t *prev = NULL, *cur, *next = NULL;
  cur = (bndrt_t *)heap;

  while (cur + 1 != ptr && (uint8_t *)cur - heap < IP_MALLOC_HEAP_SIZE) {
    prev = cur;
    cur = (bndrt_t *)(((uint8_t *)cur) + ((*cur) & IP_MALLOC_LEN));
  }
  if (cur + 1 == ptr) {
    next = (bndrt_t *)((*cur & IP_MALLOC_LEN) + ((uint8_t *)cur));

    *cur &= ~IP_MALLOC_INUSE;
    if ((((uint8_t *)next) - heap) < IP_MALLOC_HEAP_SIZE && 
        (*next & IP_MALLOC_INUSE) == 0) {
      *cur = (*cur & IP_MALLOC_LEN) + (*next & IP_MALLOC_LEN);
    }
    if (prev != NULL && (*prev & IP_MALLOC_INUSE) == 0) {
      *prev = (*prev & IP_MALLOC_LEN) + (*cur & IP_MALLOC_LEN);
    }
  }
}

uint16_t ip_malloc_freespace() {
  uint16_t ret = 0;
  bndrt_t *cur = (bndrt_t *)heap;

  while ((uint8_t *)cur - heap < IP_MALLOC_HEAP_SIZE) {
    if ((*cur & IP_MALLOC_INUSE) == 0)
      ret += *cur & IP_MALLOC_LEN;
    cur = (bndrt_t *)(((uint8_t *)cur) + ((*cur) & IP_MALLOC_LEN));
  }
  return ret;
}

#ifdef PC
void dump_heap() {
  int i;
  for (i = 0; i < IP_MALLOC_HEAP_SIZE; i++) {
    printf("0x%x ", heap[i]);
    if (i % 8 == 7) printf("  ");
    if (i % 16 == 15) printf ("\n");
    if (i > 64) break;
  }
  printf("\n");
}

void ip_print_heap() {
  bndrt_t *cur = (bndrt_t *)heap;
  while (((uint8_t *)cur)  - heap < IP_MALLOC_HEAP_SIZE) {
    printf ("heap region start: 0x%x length: %i used: %i\n", 
            cur, (*cur & IP_MALLOC_LEN), (*cur & IP_MALLOC_INUSE) >> 15);
    if ((*cur & IP_MALLOC_LEN) == 0) {
      printf("ERROR: zero length cell detected!\n");
      dump_heap();
      exit(1);
    }
    cur = (bndrt_t *)(((uint8_t *)cur) + ((*cur) & IP_MALLOC_LEN));

  }
}
#endif
#endif
