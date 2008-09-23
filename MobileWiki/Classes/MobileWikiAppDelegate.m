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
#import "WikiProtocol.h"

@implementation MobileWikiAppDelegate

@synthesize window;
@synthesize navController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	//hook up a protocol handler to listen to the wiki:// requests
	[NSURLProtocol registerClass:[WikiProtocol class]];
	
	// Override point for customization after app launch	
	[window addSubview:[navController view]];
	[window makeKeyAndVisible];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	//this will handle external requests for wiki: if we want it to
	return YES;
}

- (IBAction)showArticle:(id)sender {
	[navController pushViewController:[[ArticleViewController alloc] initWithTitle:@"Blah"] animated:YES];
}

- (IBAction)showSearch:(id)sender {
	//move to the search screen, or show it, or something
	[navController pushViewController:[[ArticleViewController alloc] initWithTitle:@"todo search page"] animated:YES];
}

- (void)loadArticle:(NSString*)title {
	if ([[title substringToIndex:1] isEqualToString:@"/"]) {
		title = [title substringFromIndex:1];
	}
	[navController pushViewController:[[ArticleViewController alloc] initWithTitle:title] animated:YES];
}

- (void)dealloc {
	[window release];
	[super dealloc];
}


@end
