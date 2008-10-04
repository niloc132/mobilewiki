//
//  SearchViewController.h
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

#import <UIKit/UIKit.h>

@class WikiDump;

@interface SearchViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UISearchBar *searchBar;
	IBOutlet UITableView *tableView;
	
	//NSString *searchText;
	
	
	//REMOVED FOR TEMP HACK - see SearchViewController.m 
	//NSMutableArray *results;
	//WikiDump *dump;
}
@property (nonatomic,retain) UISearchBar *searchBar;
@property (nonatomic,retain) UITableView *tableView;

- (id)initWithDump:(WikiDump*)d;

- (IBAction) dismiss;

@end
