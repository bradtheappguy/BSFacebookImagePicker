/*
 * Copyright 2013 Brad Smith
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
