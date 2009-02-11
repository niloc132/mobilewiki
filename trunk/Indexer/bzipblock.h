/*
 *  bzipblock.h
 *  Indexer-xcode
 *
 *  Created by Colin Alworth on 10/18/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef _BZIP_BLOCK_
#define _BZIP_BLOCK_

#include <stdio.h>
#include <stdlib.h>
#include <bzlib.h>

#include "bitwriter.h"

#define BLOCKSTART		0x314159265359LL;
#define BLOCKEND		0x177245385090LL;
#define BLOCKMASK		0xFFFFFFFFFFFFLL;

typedef struct {
	FILE* fp;
	char blk_size;
} bzip_file;

typedef struct {
	long long offset;//offset of the beginning of this block within the bz2 file
	//should be used only to find this block within the file
	
	unsigned int length_uncompressed;//length of the uncompressed data
	//can be used to determine the length of this block
	
	unsigned int length;//length of the block (compressed data)
	//should be used only to ff within a zip to find the next block
	
	bzip_file* zip;//bz2 file that this applies to
	char last_block;//1 or 0 - 1 if this is the last block, zero if it is not.
	char* contents;//TEMP - contents of this block
} bblock;

bzip_file *init_bzip(FILE *fp);

bblock *first_block(bzip_file* zip);
bblock *next_block(bblock* curr);

int block_contents(bblock *start_block, int offset, int length, char** contents);

void delete_block(bblock* block);

#endif
