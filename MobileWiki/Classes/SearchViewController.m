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
	
	return [results count] < 100;
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

- (IBAction) dismiss {
	[self dismissModalViewControllerAnimated:YES];
}


/*
 * Search Bar Delegate stuff
 */
- (void)searchBar:(UISearchBar *)search textDidChange:(NSString *)text {
	//text was changed
	
	char* curNeedle = xalloc(MAXSTR * sizeof(char));
	strncpy(curNeedle, [[[search text] capitalizedString] UTF8String], MAXSTR);
	
	[results removeAllObjects];
	
	lsearch(&[dump dump]->index, curNeedle, &hackToRecieveResults, NULL, true, true);
	
	free(curNeedle);
	
	
	
	[tableView reloadData];
	//[tableView beginUpdates];//what do these do?
//	[tableView endUpdates];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)search {
	//started typing?
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)search {
	//ended typing?
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)search {
	if ([[search text] length] < 1)
		return;
	
	
	//TODO: Grab articles that match title AND body
	
	//ugh...
	char* curNeedle = xalloc(MAXSTR * sizeof(char));
	strncpy(curNeedle, [[[search text] capitalizedString] UTF8String], MAXSTR);
	
	[results removeAllObjects];
	
	lsearch(&[dump dump]->index, curNeedle, &hackToRecieveResults, NULL, true, true);
	
	free(curNeedle);
	
	[tableView reloadData];
	//[tableView beginUpdates];
	//[tableView endUpdates];
	[searchBar resignFirstResponder];
	
	
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)search {
	[searchBar resignFirstResponder];
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
	
	//find the label index
	NSInteger i = [indexPath length];
	NSInteger j = [indexPath indexAtPosition:(i - 1)];
	
	[c setText:[[results objectAtIndex:j] name]];
	
	return c;
}
/* 
 * Table View Delegate Stuff
 */

- (void)tableView:(UITableView *)t didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//find the dummy label
	NSInteger i = [indexPath length];
	NSInteger j = [indexPath indexAtPosition:(i - 1)];
	
	[self dismiss];
	[(WikiNavViewController*)[self parentViewController] pushArticle:[results objectAtIndex:j]];
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
