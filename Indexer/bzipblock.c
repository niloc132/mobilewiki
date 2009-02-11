/*
 *  bzipblock.c
 *  Indexer-xcode
 *
 *  Created by Colin Alworth on 10/18/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#include "bzipblock.h"
#include <bzlib.h>

bzip_file *init_bzip(FILE *fp) {
	bzip_file *b = malloc(sizeof(bzip_file));
	b->fp = fp;
	
	fseek(b->fp, 3, SEEK_SET);
	b->blk_size = fgetc(b->fp) - 0x30;
	
	return b;
}

void delete_block(bblock* block) {
	//free(block->contents);
	free(block);
}

bblock *first_block(bzip_file* zip) {
	rewind(zip->fp);
	
	bblock *zeroth = malloc(sizeof(bblock));
	zeroth->offset = 0;
	zeroth->length_uncompressed = 0;
	zeroth->length = 1;//skip the preamble?
	zeroth->zip = zip;
	
	bblock *first = next_block(zeroth);
	free(zeroth);
	
	return first;
}

unsigned int decompress_block(bblock* b, char** results, unsigned int len) {
	//jump to the block in the file
	fseek(b->zip->fp, b->offset, SEEK_SET);
	
	//space to store the block
	bit_writer* block = create_bit_writer(b->zip->blk_size * 5 * 1024 * 100);
	
	// Start with the bzip2 header
	writeChar(block, 'B');//palendrome in binary - not good for debugging
	writeChar(block, 'Z');//palendrome in binary 
	writeChar(block, 'h');
	writeChar(block, b->zip->blk_size + 0x30);
	
	writeChar(block, 0x31); // 3.14159265359
	writeChar(block, 0x41);
	writeChar(block, 0x59);
	writeChar(block, 0x26);
	writeChar(block, 0x53);
	writeChar(block, 0x59);
	
	unsigned int crc = 0;
	
	//do everything else bit by bit
	long long acc = 0;
	int byte = 0;
	int bit = 0;
	char inBlock = 0;
	
	unsigned long long bitsRead = 0;
	
	//for each byte
	while (EOF != (byte = fgetc(b->zip->fp))) {//shouldn't actually hit EOF...
		
		//get each bit, starting high to low
		for (int i = 7; i >= 0; i--) {
			bit = byte >> i;
			bitsRead++;
			
			// grab the crc for closing the block (it will be written
			// automatically)
			if (block->next_pos == (14 * 8))
				crc = acc & 0xFFFFFFFF;//just the lower bits
			
			//push the (least significant) bit
			acc = (acc << 1) | (bit & 0x1);
			
			//write the bit if needed
			if (inBlock == 1)
				writeBit(block, bit);
			
			if ((acc & 0xFFFFFFFFFFFFLL) == 0x314159265359LL ||// start block
				(acc & 0xFFFFFFFFFFFFLL) == 0x177245385090LL) {// end block
				if ((acc & 0xFFFFFFFFFFFFLL) == 0x177245385090LL) {
					fprintf(stderr, "Bzip2 eos reached.\n");
					b->last_block = 1;
				}
				
				if (!inBlock) { //then we havent started the block - start now
					//start reading process
					inBlock = 1;
					
				} else {
					//delete last 6 bytes - they were closing the block, and now need to
					//close the stream
					block->next_pos -= (6 * 8);
					
					//exit the loop
					inBlock = -1;
					break;
				}
			}
		}//end for loop through the byte
		if (inBlock == -1)
			break;
		
	}//end byte by byte access
	
	//write tail stuff - magic end block bits, crc from above, trailing bits
	writeChar(block, 0x17);
	writeChar(block, 0x72);
	writeChar(block, 0x45);
	writeChar(block, 0x38);
	writeChar(block, 0x50);
	writeChar(block, 0x90);
	writeInt(block, crc);
	closeLastByte(block);
	
	
	
	//Number of bits read, turned into bytes, and rounded down...?
	//This is almost certainly wrong... it doesnt account for not starting
	//right away, and it doesnt account for backing up...
	//Then again, should it? or should it just be the count of bits read since starting?
	b->length = bitsRead / 8 - 10;
	
	//figure out the uncompressed length
	//max value to test with
	*results = malloc(len * sizeof(char));
	
	int bz_error = BZ2_bzBuffToBuffDecompress(*results, &len, block->content, block->next_pos / 8, 0, 0);
	if (bz_error != BZ_OK) {
		fprintf(stderr, "Error decompressing block: %d\n", bz_error);
		exit(-1);
	}
	
	//b->contents = text;
	//free(text);
	
	delete_bit_writer(block);
	
	return len;
}

bblock *next_block(bblock* curr) {
	bblock *b = malloc(sizeof(bblock));
	//the offset is easy to find - just the offset of the previous plus the length of the previous
	b->offset = curr->length + curr->offset;
	
	b->zip = curr->zip;
	b->last_block = 0;
	
	//to solve for the compressed and uncompressed length, the block must
	// be found, measured, and decompressed
	char* text = NULL;
	b->length_uncompressed = decompress_block(b, &text, b->zip->blk_size*100*5*1024);//TODO: Check this size
	if (text != NULL)
		//free(text);
		b->contents = text;
	else
		fprintf(stderr, "failed to decompress block?");
	
	return b;
}

int block_contents(bblock *block, int offset, int length, char** contents) {
	
	
	return length;
}