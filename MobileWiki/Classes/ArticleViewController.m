//
//  ArticleViewController.m
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

#import "ArticleViewController.h"
#import "MobileWikiAppDelegate.h"
#import "WikiArticle.h"

@implementation ArticleViewController

@synthesize webView;
//@synthesize searchButton;

- (id) initWithUrl: (NSURL*) u {
	if (self = [super initWithNibName:@"ArticleView" bundle:nil]) {
		_url = [u retain];
		[self setTitle: [[u path] substringFromIndex: 1]];
	}
	
	return self;
}

- (id) initWithArticle: (WikiArticle*) a {
	return [self initWithUrl:[a url]];
}



/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

/*
 If you need to do additional setup after loading the view, override viewDidLoad.
*/
- (void)viewDidLoad {
	// is there a way to hook this up through the nib? or maybe the entire
	// nav item should be made in code?
	[[self navigationItem] setTitle: [self title]];
	
	[[self navigationItem] setRightBarButtonItem:
		[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch 
								 target:[self parentViewController]
								 action:@selector(showSearchDialog)]
	];
	
	// Request the article - this should be refactored to allow external or saved links
	NSURLRequest *request = [NSURLRequest requestWithURL:_url];
	[webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest: (NSURLRequest *) request navigationType:(UIWebViewNavigationType)navigationType
{
	if (UIWebViewNavigationTypeLinkClicked != navigationType)
		return YES;
	
	[(MobileWikiAppDelegate*)[[UIApplication sharedApplication] delegate] loadArticle:[request URL]];
	return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//change something about the view for the rotation
	
	return YES;// (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[webView release];
	[_url release];
	[super dealloc];
}


@end
