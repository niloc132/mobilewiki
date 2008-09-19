//
//  MobileWikiAppDelegate.m
//  MobileWiki
//
//  Created by Colin Alworth on 9/18/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "MobileWikiAppDelegate.h"
#import "ArticleViewController.h"

@implementation MobileWikiAppDelegate

@synthesize window;
@synthesize navController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	
	// Override point for customization after app launch	
	[window addSubview:[navController view]];
	[window makeKeyAndVisible];
}
- (IBAction)showArticle:(id)sender {
	[navController pushViewController:[[ArticleViewController alloc] initWithTitle:@"Blah"] animated:YES];
}

- (void)dealloc {
	[window release];
	[super dealloc];
}


@end
