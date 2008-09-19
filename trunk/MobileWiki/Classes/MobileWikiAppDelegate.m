//
//  MobileWikiAppDelegate.m
//  MobileWiki
//
//  Created by Colin Alworth on 9/18/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "MobileWikiAppDelegate.h"

@implementation MobileWikiAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	
	// Override point for customization after app launch	
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[window release];
	[super dealloc];
}


@end
