//
//  MobileWikiAppDelegate.h
//  MobileWiki
//
//  Created by Colin Alworth on 9/18/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MobileWikiAppDelegate;

@interface MobileWikiAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet UINavigationController *navController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;

- (IBAction)showArticle:(id)sender;

@end

