/*
 *  article.c
 *  Indexer-xcode
 *
 *  Created by Colin Alworth on 10/15/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#include "article.h"

void replace_underscore_with_space(char* str) {
	char* ptr = str;
	
	while (NULL != (ptr = strchr(ptr, '_'))) {
		*ptr = ' ';
	}
}

article* create_article(char* title) {
	article *a = malloc(sizeof(article));
	a->title = malloc((strlen(title) + 1) * sizeof(char));
	strcpy(a->title, title);
	
	a->position = malloc(sizeof(struct article_ref));
	a->position->total_offset = -1;
	a->position->block = -1;
	a->position->block_offset = -1;
	a->position->len = 0;
	return a;
}

void delete_article(article* a) {
	if (a->position->redirect == NULL)
		free(a->position->redirect);
	free(a->position);
	free(a);
}

int article_comparison(const article **a1, const article **a2) {

	return strcmp((*a1)->title, (*a2)->title);
}
int article_ref_comparison(const article **a1, const article **a2) {
	
	return strcmp((*a1)->position->redirect, (*a2)->title);
}


void continue_article(char** next, char** text, int* len, int* status) {
	// len is the distance to the </text> tag, or the end of the string
	
	//TODO copy the next string, and remove useless crap like xml comments
	
	*text = *next;
	char *end = strchr(*next, '<');
	if (end == NULL) { //send the whole thing
		*len = strlen(*next);
		*next += *len;
		
		if (*status == ARTICLE_IGNORE_TO_END)
			*len = 0;
	} else {
		*next = end + 1;
		
		if (*status == ARTICLE_IGNORE_TO_END)
			*len = 0;
		else
			*len = end - *text;
		
		*status = ARTICLE_DONE;//done!
	}
	
	
}

article* start_article(char** next, long long offset, int* status) {
	// expect <title>, point title at next char
	char* title = strstr(*next, "<title>");
	if (title == NULL)
		return NULL;
	//save the position of the title tag - this will save time
	
	*next = title;
	title += 7;//pass <title>
	
	// read until </title> and change < to \0 at the end of the func
	char *title_end = strchr(title, '<');
	if (title_end == NULL)
		return NULL;
	
	
	//read until <text
	char *c = strstr(title_end, "<text");
	if (c == NULL)
		return NULL;
	//read until >
	c = strchr(c, '>');
	if (c == NULL || *(c + 1) == '\0')
		return NULL;
	
	//handle offset
	if (*(c + 1) == '#' && (*(c + 2) == 'R' || *(c + 2) == 'r')) {
		// reference - advance to [[, and save
		c = strstr(c, "[[");
		if (c == NULL)
			return NULL;
		
		char* redirect = (c + 2);// pass [[
		c = strstr(redirect, "]]");
		if (c == NULL)
			return NULL;
		
		
		
		//no chance of returning NULL now, so start breaking stuff
		*title_end = '\0';
		*c = '\0';
		
		article *a = create_article(title);
		//save the redirect
		a->position->redirect = malloc((strlen(redirect) + 1) * sizeof(char));
		strcpy(a->position->redirect, redirect);
		replace_underscore_with_space(a->position->redirect);
		// set curr to end of block
		
		//make sure we can see to the end of the article
		char* end = strstr((c + 1), "</text>");
		if (end == NULL) {
			*next = c+1;
			*status = ARTICLE_IGNORE_TO_END;
		} else {
			*next = end;
			*status = ARTICLE_DONE;
		}
		
		return a;
	} else {
		// actual article
		*title_end = '\0';
		article *a = create_article(title);
		
		a->position->total_offset = offset;
		*next = c + 1;
		
		*status = ARTICLE_IN_PROGRESS;
		return a;
	}
}

char* read_article_from_bzip(bzip_file* bzip, article* a) {
	char* text = malloc(a->position->len * sizeof(char));
	char* next = text;
	int len = 0;
	
	bblock* block = malloc(sizeof(bblock));
	block->zip = bzip;
	block->length = a->position->block;
	
	while (0 != (len = block_contents(block, a->position->block_offset, a->position->len, &next))) {
		next += len;
	}
	
	free(block);
	return text;
}