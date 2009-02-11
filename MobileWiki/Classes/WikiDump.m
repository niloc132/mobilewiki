//
//  WikiDump.m
//  MobileWiki
//  
//  Copyright (C) 2008
//  
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2 as
//  published by the Free Software Foundation.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
// 
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


#import "WikiDump.h"
#import "WikiArticle.h"

@implementation WikiDump

@synthesize name=_name;
@synthesize dump=_dump;

static NSMutableDictionary* allDumps;

+ (void) initialize {
	allDumps = [[NSMutableDictionary alloc] init];
}

+ (WikiDump*) getDumpWithName:(NSString*)n {
	return (WikiDump*) [allDumps objectForKey:n];
}

+ (void) registerDump: (WikiDump*) d {
	[allDumps setObject:d forKey:[d name]];
}

+ (void) unregisterDump: (WikiDump*) d {
	[allDumps removeObjectForKey:[d name]];
}

-(id) initWithName:(NSString*)n andSource:(NSString*)s {
	if (self = [super init]) {
		_name = [n retain];
		
		articles = [[NSMutableDictionary alloc] init];
		
		//using stuff from 1.0 vers to init 
		//TODO: use source path
		_dump = xalloc(sizeof(wp_dump));
		load_dump(_dump,
				  [[NSString stringWithFormat:@"%@/processed",s] UTF8String],
				  [[NSString stringWithFormat:@"%@/locate.db",s] UTF8String],
				  [[NSString stringWithFormat:@"%@/locate.prefixdb",s] UTF8String],
				  [[NSString stringWithFormat:@"%@/blocks.db",s] UTF8String]);
		//end 1.0 block
		
	}
	return self;
}
-(NSArray*) articlesWithNamesThatBeginWith:(NSString*)text {
	//TODO: finish this so that it does something;
	return [NSArray arrayWithObject:[[WikiArticle alloc] initWithName:text andDump:self]];
}
-(NSArray*) articlesThatContain:(NSString*)text {
	//TODO: finish this so that it does somthing;
	return [NSArray arrayWithObject:[[WikiArticle alloc] initWithName:text andDump:self]];
}

-(BOOL) hasArticleWithName:(NSString*)n {
	//check to see if the article is present
	wp_article *article = xalloc(sizeof(wp_article));
	init_article(article);
	
	//TODO: ugly legacy code that can be removed and replaced with NSString calls. 
	NSString *cap = [NSString stringWithFormat: @"%c%@", toupper([n characterAtIndex: 0]), [n substringFromIndex: 1]];
	
	//This method is very slow - replace it with something that doesnt grab the text
	BOOL exists = load_article(_dump, [cap UTF8String], article) != -1;
	
	
	free(article->text);
	free(article);

	return exists;
}

-(WikiArticle*) articleWithName:(NSString*)n {
	WikiArticle *a = [articles objectForKey:n];
	if (!a) {
		a = [[WikiArticle alloc] initWithName:n andDump:self];
		
		//add it to a cache? add to a list of articles that do not exist?
		if (a) {
			//TODO: add to cache
			[articles setObject:a forKey:n];
			[a autorelease];
		}
	}
	return a;
}

- (void)dealloc {
	free(_dump);
	[_name release];
	[articles release];
	[super dealloc];
}

@end
