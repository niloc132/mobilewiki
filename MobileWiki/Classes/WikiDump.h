//
//  WikiDump.h
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


#import <UIKit/UIKit.h>
#import "wp.h"

@class WikiArticle;


@interface WikiDump : NSObject {
	NSString *_name;
	wp_dump *_dump;
	
	NSMutableDictionary *articles;
}

@property(retain, readonly) NSString *name;
@property(readonly) wp_dump *dump;

+ (WikiDump*)getDumpWithName:(NSString*)n;
+ (void)registerDump: (WikiDump*) d;
+ (void)unregisterDump: (WikiDump*) d;


- (id)initWithName:(NSString*)n andSource:(NSString*)s;

- (NSArray*)articlesWithNamesThatBeginWith:(NSString*)text;
- (NSArray*)articlesThatContain:(NSString*)text;

- (BOOL)hasArticleWithName:(NSString*)n;

- (WikiArticle*)articleWithName:(NSString*)n;


@end
