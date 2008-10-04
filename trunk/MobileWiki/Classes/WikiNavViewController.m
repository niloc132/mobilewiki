//
//  WikiNavViewController.m
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

#import "WikiNavViewController.h"
#import "SearchViewController.h"
#import "ArticleViewController.h"
#import "WikiDump.h"

@implementation WikiNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

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


- (void) pushArticle:(WikiArticle*) article {
	[self pushViewController:[[ArticleViewController alloc] initWithArticle:article] animated:YES];
}

- (IBAction) showSearchDialog {
	if (!search)
		search = [[SearchViewController alloc] initWithDump:[WikiDump getDumpWithName:@"en"]];
	
	[self presentModalViewController:search	animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	//TODO: this doesn't quite do it right...
	if ([[self topViewController] isKindOfClass:[ArticleViewController class]])
		return YES;
	else
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[search release];
	[super dealloc];
}


@end
