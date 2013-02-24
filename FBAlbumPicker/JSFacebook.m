//
//  JSFacebook.m
//  FacebookAPI
//
//  Created by Jernej Strasner on 3/26/11.
//  Copyright 2011 JernejStrasner.com. All rights reserved.
//

#import "JSFacebook.h"

NSString * const kJSFacebookGraphAPIEndpoint			= @"https://graph.facebook.com/";
NSString * const kJSFacebookAccessTokenKey				= @"JSFacebookAccessToken";
NSString * const kJSFacebookAccessTokenExpiryDateKey	= @"JSFacebookAccessTokenExpiryDate";
NSString * const kJSFacebookSSOAuthURL                  = @"fbauth://authorize/";


@interface JSFacebook (/* private */) {
	dispatch_queue_t network_queue;
}

@property (nonatomic, copy) JSFBLoginSuccessBlock authSuccessBlock;
@property (nonatomic, copy) JSFBLoginErrorBlock authErrorBlock;
@property (nonatomic, strong) NSDate *accessTokenExpiryDate;

@end

@implementation JSFacebook

#pragma mark - Singleton

+ (JSFacebook *)sharedInstance
{
    static JSFacebook *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JSFacebook alloc] init];
    });
	return sharedInstance;
}

#pragma mark - Properties

@synthesize accessToken=_accessToken;
@synthesize accessTokenExpiryDate=_accessTokenExpiryDate;
@synthesize facebookAppID=_facebookAppID;
@synthesize facebookAppSecret=_facebookAppSecret;
@synthesize urlSchemeSuffix=_urlSchemeSuffix;
@synthesize authErrorBlock;
@synthesize authSuccessBlock;


- (void)setAccessToken:(NSString *)accessToken {
	_accessToken = accessToken;
	[[NSUserDefaults standardUserDefaults] setValue:accessToken forKey:kJSFacebookAccessTokenKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAccessTokenExpiryDate:(NSDate *)accessTokenExpiryDate {
	_accessTokenExpiryDate = accessTokenExpiryDate;
	[[NSUserDefaults standardUserDefaults] setValue:accessTokenExpiryDate forKey:kJSFacebookAccessTokenExpiryDateKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Lifecycle

- (id)init {
	if (self = [super init]) {
		// Init the network queue
		network_queue = dispatch_queue_create("com.jsfacebook.network", NULL);
		// Check if we have an access token saved and it is stil valid
		NSString *accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:kJSFacebookAccessTokenKey];
		if ([accessToken length] > 0) {
			NSDate *accessTokenExpiryDate = [[NSUserDefaults standardUserDefaults] valueForKey:kJSFacebookAccessTokenExpiryDateKey];
			if ([accessTokenExpiryDate timeIntervalSinceNow] > 0) {
				// Save to properties
				self.accessToken = accessToken;
				self.accessTokenExpiryDate = accessTokenExpiryDate;
			}
		}
	}
	return self;
}


#pragma mark - Methods
#pragma mark - Authentication

- (void)loginWithPermissions:(NSArray *)permissions
				   onSuccess:(JSFBLoginSuccessBlock)succBlock
					 onError:(JSFBLoginErrorBlock)errBlock
{
    if (![self isFacebookAppIDValid]) {
        NSLog(@"ERROR: You have to set a valid Facebook app ID before you try to authenticate!");
        return;
    }
	if (![self isSessionValid]) {
        // Check for SSO support
        if (YES) {
            // Save the blocks
            self.authSuccessBlock = succBlock;
            self.authErrorBlock = errBlock;
            // Build the parameter string
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:self.facebookAppID forKey:@"client_id"];
            [params setValue:@"user_agent" forKey:@"type"];
            [params setValue:@"touch" forKey:@"display"];
            [params setValue:@"ios" forKey:@"sdk"];
            [params setValue:@"fbconnect://success" forKey:@"redirect_uri"];
		      	[params setValue:self.urlSchemeSuffix forKey:@"local_client_id"];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@&scope=%@", kJSFacebookSSOAuthURL, [params HTTPQueryString], [permissions componentsJoinedByString:@","]]];
            // Open the SSO URL
            BOOL didOpenApp = [[UIApplication sharedApplication] openURL:url];
            // If it failed open Safari
            if (didOpenApp == NO) {
                [params setValue:[NSString stringWithFormat:@"fb%@%@://authorize", self.facebookAppID, (self.urlSchemeSuffix ?: @"")] forKey:@"redirect_uri"];
                url = [NSURL URLWithString:[NSString stringWithFormat:@"https://m.facebook.com/dialog/oauth?%@&scope=%@", [params HTTPQueryString], [permissions componentsJoinedByString:@","]]];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
	} else {
		succBlock();
	}
}

- (void)logout
{
	// Nil out the properties
	self.accessToken = nil;
	self.accessTokenExpiryDate = nil;
	// Remove any saved login data
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kJSFacebookAccessTokenKey];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kJSFacebookAccessTokenExpiryDateKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isSessionValid
{
	if ([self.accessToken length] > 0 && [self.accessTokenExpiryDate timeIntervalSinceNow] > 0) {
		return YES;
	}
	return NO;
}

- (void)validateAccessTokenWithCompletionHandler:(void (^)(BOOL))completionHandler
{
/*	// First check if we have the token and that it is not expired
	if (![self isSessionValid]) {
		if (completionHandler) completionHandler(NO);
		return;
	}
	// Create a request to the Facebook servers to see if we have access with the token that we have
	JSFacebookRequest *request = [JSFacebookRequest requestWithGraphPath:@"/me"];
	[request addParameter:@"fields" withValue:@"id"];
	[[JSFacebook sharedInstance] fetchRequest:request onSuccess:^(id responseObject) {
		// Access token is valid
		if (completionHandler) completionHandler(YES);
	} onError:^(NSError *error) {
		// Not valid
		NSLog(@"Error: %@", [error localizedDescription]);
		if (completionHandler) completionHandler(NO);
	}];*/
}

- (void)extendAccessTokenExpirationWithCompletionHandler:(void (^)(NSError *))completionHandler
{
	/*if (![self isSessionValid]) {
		ALog(@"ERROR: Session invalid");
		NSError *error = [NSError errorWithDomain:kJSFacebookErrorDomain code:JSFacebookErrorCodeAuthentication userInfo:nil];
		if (completionHandler) completionHandler(error);
		return;
	}
	
	// We need the app secret for this
	if (![self.facebookAppSecret length]) {
		ALog(@"ERROR: Missing facebook app secret");
		NSError *error = [NSError errorWithDomain:kJSFacebookErrorDomain code:JSFacebookErrorCodeOther userInfo:nil];
		if (completionHandler) completionHandler(error);
		return;
	}
	
	JSFacebookRequest *request = [JSFacebookRequest requestWithGraphPath:@"/oauth/access_token"];
	[request setAuthenticate:NO];
	[request addParameter:@"fb_exchange_token" withValue:self.accessToken];
	[request addParameter:@"grant_type" withValue:@"fb_exchange_token"];
	[request addParameter:@"client_id" withValue:self.facebookAppID];
	[request addParameter:@"client_secret" withValue:self.facebookAppSecret];
	[[JSFacebook sharedInstance] fetchRequest:request onSuccess:^(id responseObject) {
		// Get the data (it is URL encoded)
		NSString *accessToken = [responseObject getQueryValueWithKey:@"access_token"];
		NSString *expiry = [responseObject getQueryValueWithKey:@"expires"];
		if (!accessToken.length || !expiry.length) {
			DLog(@"ERROR: Access token or expiry date missing!");
			NSError *error = [NSError errorWithDomain:kJSFacebookErrorDomain code:JSFacebookErrorCodeServer userInfo:@{NSLocalizedDescriptionKey: @"Crucial data is missing from the response"}];
			if (completionHandler) completionHandler(error);
		}
		
		// Set the new info
		self.accessToken = accessToken;
		self.accessTokenExpiryDate = [NSDate dateWithTimeIntervalSinceNow:[expiry doubleValue]];
		
		if (completionHandler) completionHandler(nil);
		
	} onError:^(NSError *error) {
		DLog(@"ERROR: Could not extend the access token!");
		if (completionHandler) completionHandler(error);
	}];*/
}

- (BOOL)isFacebookAppIDValid
{
    // Check if the Facebook app ID is valid
    return (self.facebookAppID.length == 15);
}

- (void)handleCallbackURL:(NSURL *)url
{
    NSString *urlString = [url absoluteString];
    NSString *queryString = nil;
    @try {
        queryString = [urlString substringFromIndex:[urlString rangeOfString:@"[#?]" options:NSRegularExpressionSearch].location + 1];
    }
    @catch (NSException *exception) {
        NSLog(@"Could not parse the query string: %@", [exception reason]);
        if (self.authErrorBlock) self.authErrorBlock([NSError errorWithDomain:@"com.jernejstrasner.jsfacebook" code:100 userInfo:@{NSLocalizedDescriptionKey: [exception reason]}]);
		return;
    }

    // Check for errors
    NSString *errorString = [queryString getQueryValueWithKey:@"error"];
    if (errorString != nil) {
        // We have an error
        NSString *errorDescription = [queryString getQueryValueWithKey:@"error_description"];
        NSError *error = [NSError errorWithDomain:errorString code:666 userInfo:@{NSLocalizedDescriptionKey: errorDescription}];
        // Error block
        if (self.authErrorBlock) self.authErrorBlock(error);
    } else {
        // Request successfull, parse the token
        NSString *token =	[[url absoluteString] getQueryValueWithKey:@"access_token"];
        NSString *expTime =	[[url absoluteString] getQueryValueWithKey:@"expires_in"];

        NSDate *expirationDate = nil;
        if (expTime != nil) {
            int expVal = [expTime intValue];
            if (expVal == 0) {
                expirationDate = [NSDate distantFuture];
            } else {
                expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
            }
        }
        
        if ([token length] > 0) {
            // We're done. We have the token.
            [[JSFacebook sharedInstance] setAccessToken:token];
            [[JSFacebook sharedInstance] setAccessTokenExpiryDate:expirationDate];
            // Call the success block
            if (self.authSuccessBlock) self.authSuccessBlock();
        } else {
            // Oops. We have an error. No valid token found.
            NSError *error = [NSError errorWithDomain:@"invalid_token" code:666 userInfo:@{NSLocalizedDescriptionKey: @"Invalid token"}];
            if (self.authErrorBlock) self.authErrorBlock(error);
        }
    }
}



@end
