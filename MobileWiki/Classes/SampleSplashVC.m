//  
//  SampleSplashVC.m
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

#import "SampleSplashVC.h"
#import "WikiDump.h"
#import "WikiNavViewController.h"

@implementation SampleSplashVC

@synthesize msg;



- (void)viewDidLoad {
	activeDump = [WikiDump getDumpWithName:@"en"];
	
	[msg setText:[NSString stringWithFormat:@"Now using dump: \"%@\"",[activeDump name]]];
}

- (IBAction) showSampleArticle {
	[(WikiNavViewController*)[self parentViewController] pushArticle:[activeDump articleWithName:@"Wiki"]];
}

- (void)dealloc {
	[super dealloc];
}

@end
