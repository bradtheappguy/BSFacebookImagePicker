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

#import "BSFBLoginView.h"

static int kButtonLabelX = 46;
static CGRect kLoginButtonFrame = {20, 0, 280, 43};

static NSString *emptyStateImageName = @"BSFBAlbumPicker.bundle/blankslatePhotos";
static NSString *loginButtonImageName = @"BSFBAlbumPicker.bundle/login-button-small";
static NSString *loginButtonSelectedImageName = @"BSFBAlbumPicker.bundle/login-button-small-pressed";

static NSUInteger kImageViewHorizontalOffset = -60;
static NSUInteger kLoginButtonHorizontalOffset = 75;


@implementation BSFBLoginView

@synthesize loginButton;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      self.backgroundColor = [UIColor colorWithRed:236/255.0 green:238/255.0 blue:248/255.0 alpha:1.0];
      [self setupImageView];
      [self setupLoginButton];
    }
    return self;
}


-(void) setupImageView {
  imageView = [[UIImageView alloc] init];
  imageView.contentMode = UIViewContentModeCenter;
  imageView.image = [UIImage imageNamed:emptyStateImageName];
  [imageView sizeToFit];
  [self addSubview:imageView];
}


-(void) setupLoginButton {
  self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.loginButton.frame = kLoginButtonFrame;
  [self.loginButton setBackgroundImage:[[UIImage imageNamed:loginButtonImageName] stretchableImageWithLeftCapWidth:kButtonLabelX topCapHeight:0] forState:UIControlStateNormal];
  [self.loginButton setBackgroundImage:[[UIImage imageNamed:loginButtonSelectedImageName] stretchableImageWithLeftCapWidth:kButtonLabelX topCapHeight:0] forState:UIControlStateHighlighted];

  
  [self.loginButton setTitle:Localized(@"LOGIN_WITH_FACEBOOK") forState:UIControlStateNormal];
  [self addSubview:loginButton];
}


-(void) layoutSubviews {
  imageView.center = CGPointMake(self.center.x, self.center.y + kImageViewHorizontalOffset);
  self.loginButton.center = CGPointMake(self.center.x, self.center.y + kLoginButtonHorizontalOffset);
}

@end
