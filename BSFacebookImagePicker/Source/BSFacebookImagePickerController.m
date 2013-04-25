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

#import "BSFacebookImagePickerController.h"

#import "BSFBRootViewController.h"
#import "BSFacebook.h"

static CGSize kPopoverSize = {320, 480};

@interface BSFacebookImagePickerController (/* private */) {
  BSFBRootViewController *_albumPicker;
}

@end

@implementation BSFacebookImagePickerController

+ (void)setExistingFacebookAcessToken:(NSString *)token expiryDate:(NSDate *)expiry {
    [[BSFacebook sharedInstance] setAccessToken:token];
    [[BSFacebook sharedInstance] setAccessTokenExpiryDate:expiry];
}

+ (void)handleCallbackURL:(NSURL *)url {
  [[BSFacebook sharedInstance] handleCallbackURL:url];
}

+ (void) logout {
  [[BSFacebook sharedInstance] logout];
}


- (id)init {
  if (!_albumPicker) {
    _albumPicker = [[BSFBRootViewController alloc] init];
    self = [super initWithRootViewController:_albumPicker];
    _albumPicker.contentSizeForViewInPopover = kPopoverSize;
  }
  else {
    self = [super init];
  }
  return self;
}


- (void) setDelegate:(id)delegate {
  [super setDelegate:delegate];
  _albumPicker.delegate = delegate;
}

- (void) setFacebookAppID:(NSString *)facebookAppID {
  [[BSFacebook sharedInstance] setFacebookAppID:facebookAppID];
}

- (void) setFacebookAppSecret:(NSString *)facebookAppSecret {
    [[BSFacebook sharedInstance] setFacebookAppSecret:facebookAppSecret];
}



@end
