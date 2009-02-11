#include <stdio.h>
#include <stdlib.h>
#include <bzlib.h>
#include <unistd.h>
#include <search.h>

#include "article.h"
#include "bzipblock.h"

// setup - find a way to get rid of this
#define MAX_ARTICLES 8000000 //7278279 in the last dump, 2638991 of those are redirects, 7278279 - 2638991 = 4639288

// config settings
// this must be big enough to read the title tags to the text tags
#define BUFSIZE 10000

// bz2 config
// Blocksize refers to the size of the bz2 blocks - must be between 1 and 9
#define BLOCKSIZE 1
#define WORKFACTOR 50

void usage(char **argv) {
	fprintf(stderr, "%s [-x <xml source>] -o <bz out> -i <index out>\n\n"
			"  The input should be an xml dump from a mediawiki project. If a file\n"
			"  is not specified, stdin will be assumed. To the -o parameter will be\n"
			"  written a bzip2 archive of the data, and to the -i parameter will be\n"
			"  an index of the articles. These two resulting files can be given to a \n"
			"  mobilewiki instace as input.\n" ,
			argv[0]);
	exit(-1);
}

int main (int argc, char * argv[]) {
	// startup
	int ch;
	
	// files
	FILE *in = stdin;		//xml file name or stdin (optional)
	FILE *out;		//bz2 file out
	FILE *index;	//index file out
				  
	// processing
	char buf[BUFSIZE + 1];//replay, regular space, null byte
	
	buf[BUFSIZE] = '\0';
	char *body;
	int len = 0;
	
	// bz out stuff
	BZFILE *bz_out;
	int bz_error;
	
	// indexing stuff
	article** article_references = malloc(MAX_ARTICLES * sizeof(article*));
	unsigned long ref_count = 0;
	unsigned long redir_count = 0;
	
	//read infile name
	//read out archive name
	//read out index name
	in = stdin;
	while ((ch = getopt(argc, argv, "x:o:i:")) != -1) {
		switch (ch) {
			case 'x':
				in = fopen(optarg, "r");
				break;
			case 'o':
				out = fopen(optarg, "w+b");
				break;
			case 'i':
				index = fopen(optarg, "w");
				break;
			case 'h':
			default:
				usage(argv);
		}
	}
	
	fprintf(stderr, "settings:\n"
			"\tmax articles:\t%d\n"
			"\tblock size:\t%d\n"
			"\twork factor:\t%d\n"
			"\tbuffer size:\t%d\n\n",
			MAX_ARTICLES, BLOCKSIZE, WORKFACTOR, BUFSIZE);
	
	//open the bzip
	bz_out = BZ2_bzWriteOpen(&bz_error, out, BLOCKSIZE, 0, WORKFACTOR);
	if (bz_error != BZ_OK) {
		fprintf(stderr, "Error starting bzip out file: %d\n", bz_error);
		exit(-1);
	}
	

	char * curr;
	article *a = NULL;
	long long offset = 0;
	int replay_offset = 0;
	
	int status = ARTICLE_DONE;
	
	
	while (!feof(in)) {
		//read the next chunk
		fread(buf + replay_offset, sizeof(char), BUFSIZE - replay_offset, in);
		curr = buf;
		replay_offset = 0;
		
		while ((buf + BUFSIZE) > curr) {
			if (ARTICLE_DONE != status && a != NULL) {
				//get more article
				continue_article(&curr, &body, &len, &status);
				
				// Save the read text
				if (len > 0 && status != ARTICLE_IGNORE_TO_END) {
					offset += len;
					a->position->len += len;
					BZ2_bzWrite(&bz_error, bz_out, body, len);
					if (bz_error != BZ_OK) {
						fprintf(stderr, "Error writing out to bzip: %d\n", bz_error);
						exit(-1);
					}
				}
				
			} else {
				//start the next article
				a = start_article(&curr, offset, &status);
				if (a == NULL) {
					break;
				} else {
					//save the ref to the article for indexing
					if (a->position->redirect == NULL) {
						article_references[ref_count] = a;
						ref_count++;//TODO: can I combine these lines
					} else {
						article_references[MAX_ARTICLES - 1 - redir_count] = a;
						redir_count++;//TODO: can I combine these lines
					}

				}
			}
		} //end article sectioning
		
		if (a == NULL) {
			replay_offset = BUFSIZE - (curr - buf);
			strncpy(buf, curr, replay_offset);
		}
		
	} //end file reading
	fclose(in);
	
	
	// Close the bzip file, and check for errors
	BZ2_bzWriteClose(&bz_error, bz_out, 0, NULL, NULL);
	if (bz_error != BZ_OK) {
		fprintf(stderr, "Error closing bzip out file: %d", bz_error);
		exit(-1);
	}
	
	
	fprintf(stderr, "Done compressing text\n"
					"\tarticles:\t%d\n"
					"\tredirects:\t%d\n"
					"\t\t\t\t----\n"
					"\ttotal:\t\t%d\n\n",ref_count, redir_count, ref_count+redir_count);
	
	
	// Reopen the file and read it block by block to find where each article
	// starts and ends
	bzip_file *file = init_bzip(out);
	bblock *block = first_block(file);
	bblock *block2 = next_block(block);
	int block_num = 0;
	
	long long uncomp_len = block->length_uncompressed;
	
	// Article records were stored in the same order as the bz2 was written
	
	
	// For each article we have a record of, make sure we are in the right
	// block. If not, advance block
	// We already know the index in the whole text file of each article,
	// use the block index data to figure out the offset within the block
	for (int i = 0; i < ref_count; i++) {
		a = article_references[i];
		if (a->position->total_offset >= uncomp_len) {
			//increment the blocks
			block_num++;
			
			delete_block(block);
			
			if (block2 == NULL) {
				fprintf(stderr, "Out of blocks!\n");
				exit(-1);
			}
			
			block = block2;
			uncomp_len += block->length_uncompressed;
			
			if (!block->last_block) {
				block2 = next_block(block);
			} else {
				block2 = NULL;
			}
		}
		a->position->block = block->offset;// block_num;// zero indexed...
		a->position->block_offset = a->position->total_offset - (uncomp_len - block->length_uncompressed);
	}
	
	fprintf(stderr, "Done indexing block positions\n"
					"\tblocks read:\t%d\n\n", block_num);
	
	// TODO: take care of redirects
	//    sort the first section of the array by name
	//    loop through second section and search for the matching pieces
	
	
	// O (n lg n)
	qsort(article_references, ref_count, sizeof(article*), &article_comparison);
	
	article** redir_array = article_references + (MAX_ARTICLES - redir_count);
	qsort(redir_array, redir_count, sizeof(article*), &article_comparison);
	
	
	
	long lost = 0;
	
	for (int i = 0; i < redir_count; i++) {
		a = redir_array[i];
		// O(lg n)
		article** to = bsearch(&a, article_references, ref_count, sizeof(article*), &article_ref_comparison);
		if (to == NULL)
			to = bsearch(&a, redir_array, redir_count, sizeof(article*), &article_ref_comparison);
		if (to == NULL) {
			// Record the loss, null it out - do this after the loop is done
			//delete_article(a);
			//redir_array[i] = NULL;
			lost++;
		} else {
			// Chain the references
			a->position->ref = (*to)->position;
		}
	}
	
	//eliminate the bad articles (changing the last steps dir)
	//TODO
	
	
	fprintf(stderr, "Done sorting and redirecting\n"
					"\tarticles lost:\t%d\n", lost);
	
	// Deal with the position ref chains
	for (int i = 0; i < redir_count; i++) {
		a = redir_array[i];
		if (a == NULL)
			continue;
		
		//find the end of the chain (and make sure there isnt a loop)
		//change the redir into a ref
		int length_threshold = 10;
		while (length_threshold != 0 && a->position->ref != NULL) {
			a->position = a->position->ref;
			length_threshold--;
		}
		if (a->position->ref != NULL) {
			fprintf(stderr, "Chain too long...\n");
			continue;
		}
		//TODO: losing a few articles here...
		if (a->position->block == -1) {
			continue;
		}
		
		//TODO: this is leaking article_ref allocs..
		//Fixing that leak might get us the chain loop prob fixed...
		
		//and move the new ref to the first array
		article_references[ref_count] = a;
		ref_count++;//TODO: can I combine these lines
	}
	
	// Sort the refs again
	qsort(article_references, ref_count, sizeof(article*), &article_comparison);
	
	// Output the sorted results
	for (int i = 0; i < ref_count; i++) {
		a = article_references[i];
		fprintf(index, "%d\t%d\t%d\t%s\n", a->position->block, a->position->block_offset, a->position->len, article_references[i]->title);
	}
	
	
	// TODO: make the index file(s)
	//   sort the data (sort -u)
	//   lbigrams thingie
	//   sort the result in reverse numerical order (sort -nr)
	//   (some perl script on the reverse sorted data)
	//   use lcode to 
	
    return 1;
}
