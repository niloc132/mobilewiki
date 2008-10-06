//
//  MobileWikiAppDelegate.m
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

#import "MobileWikiAppDelegate.h"
#import "ArticleViewController.h"
#import "SearchViewController.h"
#import "WikiProtocol.h"
#import "WikiDump.h"

@implementation MobileWikiAppDelegate

@synthesize window;
@synthesize navController;

- (id)init {
	if (self = [super init]) {
		//set up the dumps available
		// TODO: this should read from a file/preference and somehow offer a choice to the user
		[WikiDump registerDump:[[[WikiDump alloc] initWithName:@"en" andSource:@"/wp"] autorelease]];
		
		//hook up a protocol handler to listen to the wiki:// requests
		[NSURLProtocol registerClass:[WikiProtocol class]];
		
	}
	return self;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Override point for customization after app launch	
	[window addSubview:[navController view]];
	[window makeKeyAndVisible];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	[self loadArticle:url];
	return YES;
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Memory Warning" message:@"Memory warning recieved."
											  delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
	[alert show];
	[alert release];
}
- (void)loadArticle:(NSURL*)url {
	[navController pushViewController:[[[ArticleViewController alloc] initWithUrl:url] autorelease] animated:YES];
}

- (void)dealloc {
	[window release];
	[super dealloc];
}


@end
