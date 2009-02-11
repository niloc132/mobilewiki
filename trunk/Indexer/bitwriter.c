/*
 *  bitwriter.c
 *  Indexer
 *
 *  Created by Colin Alworth on 10/25/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#include "bitwriter.h"

//This file is one of the reasons that I do not like writing in C

bit_writer* create_bit_writer(long starting_size) {
	bit_writer *b = malloc(sizeof(bit_writer));
	b->next_pos = 0;
	if (starting_size != 0) {
		b->size = starting_size;
		b->content = malloc(b->size * sizeof(char));
	}

	return b;
}
void delete_bit_writer(bit_writer* b) {
	free(b->content);
	free(b);
}


void ensure_size(bit_writer* b, long min_size) {
	if (b->size < min_size) {
		exit(-1);//this is hard, do it later
	}
}

void writeInt(bit_writer* b, u_int32_t n) {
	for (int i = 0; i < 32; i++) {
		writeBit(b, (n >> (31 - i)));
	}
}

void writeChar(bit_writer* b, char c) {
	for (int i = 0; i < 8; i++) {
		writeBit(b, 0x1 & (c >> (7 - i)));
	}
}

void writeBit(bit_writer* b, char bit) {
	if ((b->next_pos % 8) == 0) // if we are on a byte ending, then make sure there is room
		ensure_size(b, (b->next_pos)/8 + 1);
	char* next = (b->content + (b->next_pos / 8));
	
	// this is wrong... well, not wrong, but it leads to difficult mnipulation
	// after the fact of the bit stream, and bad results for unfinished bytes
	//*next = ((*next << 1) | (bit & 0x1));
	
	// we should be writing the current it in the (next_pos % 8) position, not at the end and shifting
	short bit_pos = 7 - ((b->next_pos) % 8);
	short bit_pos_mask = 0xff ^ (0x1 << bit_pos);
	*next = (*next & bit_pos_mask) | ((bit & 0x1) << bit_pos);
	
	b->next_pos++;
}

void closeLastByte(bit_writer* b) {
	while ((b->next_pos % 8) != 0) {
		writeBit(b, 0);
	}
}

long getLength(bit_writer* b) {
	return (b->next_pos / 8);
}

void copyContents(bit_writer* b, char* buf) {
	strncpy(buf, b->content, (b->next_pos) / 8);
}