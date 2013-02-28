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

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

#import "NSDictionary+HTTPQueryString.h"
#import "NSString+HTTPQueryString.h"

// Constants
extern NSString * const kJSFacebookStringBoundary;
extern NSString * const kJSFacebookGraphAPIEndpoint;
extern NSString * const kJSFacebookAccessTokenKey;
extern NSString * const kJSFacebookAccessTokenExpiryDateKey;
extern NSString * const kJSFacebookErrorDomain;

enum {
	BSFacebookErrorCodeOther = 0,
	BSFacebookErrorCodeNetwork = 1,
	BSFacebookErrorCodeAuthentication = 2,
	BSFacebookErrorCodeServer = 3
};

// Typedefs
typedef void (^BSFBVoidBlock)(void);
typedef void (^BSFBSuccessBlock)(id responseObject);
typedef void (^BSFBErrorBlock)(NSError *error);
typedef void (^BSFBBatchSuccessBlock)(NSArray *responseObjects);
typedef void (^BSFBLoginSuccessBlock)();
typedef void (^BSFBLoginErrorBlock)();

@interface BSFacebook : NSObject

@property (nonatomic, strong) NSString *facebookAppID;
@property (nonatomic, strong) NSString *facebookAppSecret;
@property (nonatomic, strong) NSString *urlSchemeSuffix;
@property (nonatomic, strong) NSString *accessToken;

+ (BSFacebook *)sharedInstance;

#pragma mark Authorization

- (void)loginWithPermissions:(NSArray *)permissions
				   onSuccess:(BSFBLoginSuccessBlock)succBlock
					 onError:(BSFBLoginErrorBlock)errBlock;
- (void)logout;
- (BOOL)isSessionValid;
- (void)extendAccessTokenExpiration;
- (BOOL)isFacebookAppIDValid;
- (void)handleCallbackURL:(NSURL *)url;

@end
