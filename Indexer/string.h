/*
 *  strings.h
 *  Indexer-xcode
 *
 *  Created by Colin Alworth on 10/15/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */
#include <stdlib.h>
#include <string.h>

typedef struct {
	char* contents;
	int length;
	char* ptr;
} string;

string* create_string(char* str, int length);

void delete_string(string* s);

void reset(string* s);

char* peek(string* str);
char* all(string* str);

char* read_until(string* str, char* pattern);
char* read_to_after(string* str, char* pattern);

int remaining_length(string* str);