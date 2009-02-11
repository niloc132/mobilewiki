/*
 *  bitwriter.h
 *  Indexer
 *
 *  Created by Colin Alworth on 10/25/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef _BIT_WRITER_
#define _BIT_WRITER_

#include <stdlib.h>
#include <string.h>

typedef struct {
	char* content;
	long next_pos;
	long size;
} bit_writer;

bit_writer* create_bit_writer(long starting_size);
void delete_bit_writer(bit_writer* b);

void writeInt(bit_writer*, unsigned int);

void writeChar(bit_writer*, char);

void writeBit(bit_writer*, char);

void closeLastByte(bit_writer*);

//will only return the length of completed bytes
long getLength(bit_writer* b);

//will only copy complete contents, not trailing bits
void copyContents(bit_writer* b, char* buf);

#endif
