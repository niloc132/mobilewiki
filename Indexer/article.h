/*
 *  article.h
 *  Indexer-xcode
 *
 *  Created by Colin Alworth on 10/15/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef	_ARTICLE_
#define	_ARTICLE_

#include <string.h>
#include <stdlib.h>

#include "bzipblock.h"

// constants
#define ARTICLE_DONE 0
#define ARTICLE_IN_PROGRESS 1
#define ARTICLE_IGNORE_TO_END 2
#define ARTICLE_IGNORE_BLOCK 3

struct article_ref {
	char *redirect;//name of article this redirects to (if any, NULL if no redirect)
	struct article_ref *ref;//actual article ref to point at (NULL if no redirect)
	
	long long total_offset;//total offset from the beginning of the xml file
	int len;//length of this article
	
	int block;//the block that this article appears in
	int block_offset;//the uncompressed offset from the beginning of this block that this starts
	
};
//typedef article_ref article_ref;

typedef struct {
	char *title;//name of the article
	struct article_ref *position;//either the article that this points to, or the position in the dump
} article;


article* create_article(char* title);
void delete_article(article* a);


int article_comparison (const article **, const article **);
int article_ref_comparison(const article **a1, const article **a2);


void continue_article(char** next, char** text, int* len, int* status);
article* start_article(char** next, long long offset, int* status);

char* read_article_from_bzip(bzip_file* bzip, article* a);

#endif
