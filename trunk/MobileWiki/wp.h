#include <stdio.h>
#include "lsearcher.h"
#include "bzipreader.h"

#define START_HEADING 1
#define START_TEXT 2
#define END_TEXT 3

typedef struct {
  char *text;
  int block;
} wp_article;

typedef struct {
  FILE *fp;
  uint64_t *block_map;
  lindex index;
} wp_dump;

void load_dump(wp_dump *d, char *dump, char *loc, char *ploc, char *blocks);
void init_article(wp_article *a);
int load_article(wp_dump *d, const char *name, wp_article *a);