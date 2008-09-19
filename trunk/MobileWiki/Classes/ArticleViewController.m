//
//  ArticleViewController.m
//  MobileWiki
//
//  Created by Colin Alworth on 9/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ArticleViewController.h"


@implementation ArticleViewController

- (id) initWithTitle: (NSString*) t {
	if (self = [super initWithNibName:@"ArticleView" bundle:nil]) {
		//do something with the title
		
		self.title = t;
	}
	return self;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//		// Initialization code
//	}
//	return self;
//}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

/*
 If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidLoad {
}
 */


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//change something about the view for the rotation
	
	return YES;// (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}


@end
