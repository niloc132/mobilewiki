//
//  WikiArticle.m
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


#import "WikiArticle.h"
#import "WikiDump.h"
#import "WPParser.h"

@implementation WikiArticle

@synthesize name = _name;
@synthesize dump = _dump;

- (id) initWithName:(NSString*)n andDump:(WikiDump*)d {
	if (self = [super init]) {
		//check to see if the dump has an article with this name
		//Okay, not yet - this is too expensive to call right now.
		//if ([d hasArticleWithName:n] == NO)
		//	return nil;
		
		
		_name = [n retain];
		_dump = [d retain];
	}
	return self;
}

- (NSURL*) url {
	NSString *u = [NSString stringWithFormat:@"wiki://%@/%@", 
				   [_dump name], 
				   [[self name] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]
	];
	return [NSURL URLWithString:u];
}

-(NSString*) text {
	//TODO: ugly legacy code that can be removed and replaced with NSString calls. 
	NSString *cap = [NSString stringWithFormat: @"%c%@", toupper([_name characterAtIndex: 0]), [_name substringFromIndex: 1]];
	
	wp_article *article = xalloc(sizeof(wp_article));
	init_article(article);
	load_article([_dump dump], [cap UTF8String], article);
	
	NSString *res = [NSString stringWithUTF8String:article->text];
	
	free(article->text);
	free(article);
	
	return res;
}

- (NSString*)bodyAsHTML {
	//TODO: Refactor this into the WikiProtocol code.
	//      This class should just return the wiki formated text, not the 
	//      html.
	
	WPParser *wp = [[WPParser alloc] initWithMarkup: [self text]];
	NSString *css = @"body { font-family: Helvetica; width: 310px; padding: 5px; margin: 0; word-wrap: break-word } .external { color: #888; }";
	NSString *page = [NSString stringWithFormat: @"<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><meta name=\"viewport\" content=\"width=320\"/><style>%@</style></head><body><h1>%@</h1>%@</body></html>", css, _name, [wp parsed]];
	
	[wp release];
	
	return page;
}

- (void)dealloc {
	[_name release];
	[_dump release];
	[super dealloc];
}

@end
