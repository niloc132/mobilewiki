//
//  SearchViewController.m
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

#import "SearchViewController.h"
#import "WikiNavViewController.h"
#import "WikiDump.h"
#import "WikiArticle.h"
#import "lsearcher.h"
#import "wp.h"

//TEMP HACK cut this out when the instance variable is restored
static NSMutableArray *results;
static WikiDump *dump;
bool hackToRecieveResults(char *s) {
	NSString *label = [NSString stringWithUTF8String:s];
	NSRange r = [label rangeOfString:@" " options:NSBackwardsSearch];
	//if (r.location < 
	label = [label substringToIndex:((r.location) - 1)];
	
	WikiArticle *a = [dump articleWithName:label];
	[results addObject:a];
	
	return [results count] < 500;
}
//END TEMP HACK


@implementation SearchViewController

@synthesize searchBar;
@synthesize tableView;

- (id)initWithDump:(WikiDump*)d {
	if (self = [super initWithNibName:@"SearchView" bundle:nil]) {
		// Initialization code
		dump = [d retain];
		results = [[NSMutableArray alloc] initWithCapacity:100];
	}
	return self;
}

-(void) startTimer {
	updater = [NSTimer scheduledTimerWithTimeInterval: 1 
											   target: tableView
											 selector: @selector(reloadData)
											 userInfo: nil
											  repeats: YES]; 
}

-(void) stopTimer {
	[updater invalidate];
	//[updater release];
	updater = nil;
}

- (void) stopSearch {
	kill_search();
	while(sthread && [sthread isExecuting]); 
}


- (IBAction) dismiss {
	[self dismissModalViewControllerAnimated:YES];

	[self stopSearch];
	[self stopTimer];
}


/*
 * Search Bar Delegate stuff
 */
- (void)searchBar:(UISearchBar *)search textDidChange:(NSString *)text {
	
	[self stopSearch];
	
	if ([[search text] length] < 1) {
		// clear the results...
		[results removeAllObjects];
		[tableView reloadData];
		return;
	}
	
	//text was changed
	sthread = [[NSThread alloc] initWithTarget: self selector: @selector(search:) object: [[search text] capitalizedString]];
	[sthread start];
	
	if(!updater) [self startTimer];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)search {
	//if ([[search text] length] < 1)
//		return;
//	[self stopSearch];
//	sthread = [[NSThread alloc] initWithTarget: self selector: @selector(search:) object: [[search text] capitalizedString]];
//	[sthread start];
	
	//if(!updater) [self startTimer];

	
	[searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)search {
	[searchBar resignFirstResponder];
}



- (void)search:(NSString*)text {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	char* curNeedle = xalloc(MAXSTR * sizeof(char));
	strncpy(curNeedle, [text UTF8String], MAXSTR);
	
	[results removeAllObjects];
	
	lsearch(&[dump dump]->index, curNeedle, &hackToRecieveResults, NULL, true, true);
	
	free(curNeedle);
	
	[pool release];
}

/* 
 * Table View Data Source Stuff
 */
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *c = [tableView dequeueReusableCellWithIdentifier:@"ArticleCell"];
	if (c == nil) {
		c = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"ArticleCell"];
	}
	
	// find the label index	
	[c setText:[[results objectAtIndex:[indexPath row]] name]];
	
	return c;
}
/* 
 * Table View Delegate Stuff
 */

- (void)tableView:(UITableView *)t didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//find the dummy label
	
	[self dismiss];
	[(WikiNavViewController*)[self parentViewController] pushArticle:[results objectAtIndex:[indexPath row]]];
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
	[searchBar becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[searchBar release];
	[dump release];
	[super dealloc];
}

@end
