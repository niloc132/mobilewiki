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

@implementation ArticleViewController

@synthesize webView;

- (id) initWithTitle: (NSString*) t {
	if (self = [super initWithNibName:@"ArticleView" bundle:nil]) {
		
		self.title = t;
		
		//TODO get the dump name/id in the ctor, and pass it into the url
		url = [NSString stringWithFormat:@"wiki://en/%@", [t stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
	}
	return self;
}

//- (id) initWithURL: (NSString*) u {
//	url = u;
//}

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
*/
- (void)viewDidLoad {
	// is there a way to hook this up through the nib?
	[self navigationItem].title = self.title;
	
	// hook up this as the delegate for the webview - this can probably be done in
	// the xib instead
	[webView setDelegate:self];
	
	// Request the article - this should be refactored to allow external or saved links
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[webView loadRequest:request];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest: (NSURLRequest *) request navigationType:(UIWebViewNavigationType)navigationType
{
	if (UIWebViewNavigationTypeLinkClicked != navigationType)
		return YES;
	//TODO: send a request to the FirstResponder thingie to load the given page.
	[(MobileWikiAppDelegate*)[[UIApplication sharedApplication] delegate] loadArticle:[[request URL] path]];
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
	[super dealloc];
}


@end
