/*
 *  reader.c
 *  Indexer
 *
 *  Created by Colin Alworth on 2/7/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#include <stdio.h>
#include <stdlib.h>

#include "article.h"
#include "bzipblock.h"

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
	
	char ch;
	while ((ch = getopt(argc, argv, "x:o:i:")) != -1) {
		switch (ch) {
			case 'x':
				//in = fopen(optarg, "r");
				break;
			case 'o':
				//out = fopen(optarg, "w+b");
				break;
			case 'i':
				//index = fopen(optarg, "w");
				break;
			case 'h':
			default:
				usage(argv);
		}
	}
}