/*
 *  strings.c
 *  Indexer-xcode
 *
 *  Created by Colin Alworth on 10/15/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#include "string.h"


string* create_string(char* str, int length) {
	string *s = malloc(sizeof(string));
	s->length = length;
	s->contents = malloc(sizeof(char) * length);
	strncpy(s->contents, str, length);
	
	reset(s);
	
	return s;
}

void delete_string(string* s) {
	free(s->contents);
	free(s);
}

void reset(string* s) {
	s->ptr = s->contents;
}

//char* peek(string* str, int count) {
//	if (str->ptr + count > str->contents + str->length)
//		return NULL;
//	return "";
//}

char* peek(string* str) {
	return(str->ptr);
}
char* all(string* str){
	return (str->contents);
}

char* read_until(string* str, char* pattern) {
	char* c = strstr(str->ptr, pattern);
	if (c == NULL)
		return NULL;
	
	return (str->ptr = c);
}

char* read_to_after(string* str, char* pattern) {
	char* c = strstr(str->ptr, pattern);
	if (c == NULL)
		return NULL;
	
	int len = strlen(pattern);
	if (*(c + len) == '\0')
		return NULL;
	return (str->ptr = c + len);
}

int remaining_length(string* str) {
	return str->length - (str->ptr - str->contents);
}