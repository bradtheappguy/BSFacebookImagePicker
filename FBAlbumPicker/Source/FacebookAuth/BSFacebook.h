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
	JSFacebookErrorCodeOther = 0,
	JSFacebookErrorCodeNetwork = 1,
	JSFacebookErrorCodeAuthentication = 2,
	JSFacebookErrorCodeServer = 3
};

// Typedefs
typedef void (^JSFBVoidBlock)(void);
typedef void (^JSFBSuccessBlock)(id responseObject);
typedef void (^JSFBErrorBlock)(NSError *error);
typedef void (^JSFBBatchSuccessBlock)(NSArray *responseObjects);
typedef void (^JSFBLoginSuccessBlock)();
typedef void (^JSFBLoginErrorBlock)();

@interface BSFacebook : NSObject

@property (nonatomic, strong) NSString *facebookAppID;
@property (nonatomic, strong) NSString *facebookAppSecret;
@property (nonatomic, strong) NSString *urlSchemeSuffix;
@property (nonatomic, strong) NSString *accessToken;

+ (BSFacebook *)sharedInstance;

#pragma mark Authorization

// This is only a convinience method that opens a modal window
// in the root view controller of the key winodow in your app.
// If you want more control over the login window presentation
// check out JSFacebookLoginController.
- (void)loginWithPermissions:(NSArray *)permissions
				   onSuccess:(JSFBLoginSuccessBlock)succBlock
					 onError:(JSFBLoginErrorBlock)errBlock;

// Destroys the current access token and expiry date.
// This method doesn not invalidate the access token on Facebook servers!
- (void)logout;

// Checks if the current login session is stil valid
- (BOOL)isSessionValid;

// Checks if the access token is still valid with the Facebook servers
- (void)validateAccessTokenWithCompletionHandler:(void(^)(BOOL isValid))completionHandler;

// Extends the access token's expiry date for 60 days
- (void)extendAccessTokenExpirationWithCompletionHandler:(void(^)(NSError *))completionHandler;

// Checks if the Facebook app ID was set and it's length is 15
- (BOOL)isFacebookAppIDValid;

// Handles the callback URL for SSO auth
- (void)handleCallbackURL:(NSURL *)url;

@end
