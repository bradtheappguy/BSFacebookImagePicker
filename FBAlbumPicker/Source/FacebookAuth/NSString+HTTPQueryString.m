//
//  JSFacebook-NSString.m
//  FacebookAPI
//
//  Created by Jernej Strasner on 4/2/11.
//  Copyright 2011 JernejStrasner.com. All rights reserved.
//

#import "NSString+HTTPQueryString.h"


@implementation NSString (HTTPQueryString)

- (NSString *)getQueryValueWithKey:(NSString *)key {
	if (![key hasSuffix:@"="]) {
		key = [key stringByAppendingString:@"="];
	}
	NSString *str = nil;
	NSRange start = [self rangeOfString:key];
	if (start.location != NSNotFound) {
		NSRange end = [[self substringFromIndex:start.location+start.length] rangeOfString:@"&"];
		NSUInteger offset = start.location+start.length;
		if (end.location == NSNotFound) {
			str = [self substringFromIndex:offset];
		} else {
			str = [self substringWithRange:NSMakeRange(offset, end.location)];
		}
		str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	return str;
}

@end
