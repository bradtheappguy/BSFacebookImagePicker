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

#import "NSDictionary+HTTPQueryString.h"

@implementation NSDictionary (HTTPQueryString)

- (NSString *)HTTPQueryString {
	NSMutableArray *pairs = [NSMutableArray new];
	for (NSString *key in self) {
		// Get the object
		id obj = [self valueForKey:key];
		// Encode arrays and dictionaries in JSON
		if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
			obj = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:obj options:0 error:nil] encoding:NSUTF8StringEncoding];
		}
		// Escaping
		NSString *escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, /* allocator */
																					  (__bridge CFStringRef)obj,
																					  NULL, /* charactersToLeaveUnescaped */
																					  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																					  kCFStringEncodingUTF8));
		// Generate http request parameter pairs
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
	}
	
	NSString *parameters = [pairs componentsJoinedByString:@"&"];
	
	return parameters;
}

@end
