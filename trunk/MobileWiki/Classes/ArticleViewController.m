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

- (id) initWithUrl: (NSURL*) u {
	if (self = [super init]){
		_url = [u retain];
		[self setTitle: [[u path] substringFromIndex: 1]];
	}
	
	return self;
}

- (id) initWithArticle: (WikiArticle*) a {
	return [self initWithUrl:[a url]];
}

- (void)loadView {
	[self setView:[[[UIWebView alloc] initWithFrame:CGRectZero] autorelease]];
	[(UIWebView*)[self view] setDelegate:self];
	
	[[self navigationItem] setTitle:[self title]];
	
	[[self navigationItem] setRightBarButtonItem:
						[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch 
												 target:[self parentViewController]
												 action:@selector(showSearchDialog)] autorelease]
	 ];
}

- (void)viewDidLoad {
	
	[(UIWebView*)[self view] loadRequest:[NSURLRequest requestWithURL:_url]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest: (NSURLRequest*) request navigationType:(UIWebViewNavigationType)navigationType
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
	[_url release];
	[super dealloc];
}


@end
