//
//  WikiNavViewController.h
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

@class WikiArticle;
@class SearchViewController;
@class ArticleViewController;

@interface WikiNavViewController : UINavigationController {
	SearchViewController *search;
	ArticleViewController *articleVC;
}

- (void) pushArticle:(WikiArticle*) article;

- (IBAction) showSearchDialog;

@end
