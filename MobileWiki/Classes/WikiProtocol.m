//
//  WikiProtocol.m
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

#import "WikiProtocol.h"
#import "WikiDump.h"
#import "WikiArticle.h"

@implementation WikiProtocol

+ (BOOL) canInitWithRequest:(NSURLRequest *) request {
	NSURL *url = [request URL];
	//if it doesnt start with 'wiki:', we cant read it.
	if (![[url scheme] isEqualToString:@"wiki"]) {
		return NO;
	}
	
	//TODO: add more logic to see if the request makes sense?
	// - check to see if the article exists or something?
	
	
	return YES;
}
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
	return request;
}

- (void)startLoading {
	id client = [self client];
	NSURL *url = [[self request] URL];
	
	NSString *dump = [url host];
	NSString *name = [[url path] substringFromIndex: 1];// [path substringFromIndex: 1]
	
	//TODO: this should be gotten from a request to the dump
	NSString *resp = [NSString stringWithFormat:@"Request was made for '%@'.\nThis text is a placeholder.<br /><a href='wiki://en/test'>test</a>", name];
	
	WikiDump *d = [WikiDump getDumpWithName:dump];
	
	NSString *cap = [NSString stringWithFormat: @"%c%@", toupper([name characterAtIndex: 0]), [name substringFromIndex: 1]];
	WikiArticle *a = [d articleWithName:cap];
	
	resp = [a bodyAsHTML];
	
	//convert the string to NSData, and build a response around it
	NSData *data = [resp dataUsingEncoding:NSUTF8StringEncoding];//change the encoding  VVVVV to text/html to render html
	NSURLResponse *response = [[NSURLResponse alloc] initWithURL:url MIMEType:@"text/html" expectedContentLength:[data length] textEncodingName:@"utf-8"];
	
	//send the response
	[client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
	[client URLProtocol:self didLoadData:data];
	[client URLProtocolDidFinishLoading:self];
	
	[response release];
}

- (void)stopLoading {
	
}
@end
