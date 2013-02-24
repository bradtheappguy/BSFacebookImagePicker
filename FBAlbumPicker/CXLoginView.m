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

#import "CXLoginView.h"

const int kButtonLabelX = 46;

@implementation CXLoginView

@synthesize loginButton;

- (id)initWithFrame:(CGRect)frame
{
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
  imageView.image = [UIImage imageNamed:@"blankslatePhotos"];
  [imageView sizeToFit];
  [self addSubview:imageView];
}

-(void) setupLoginButton {
  self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.loginButton.frame = CGRectMake(20, 0, 280, 43);
 
  UIImage *image = [[UIImage imageNamed:@"login-button-small.png"]
                    stretchableImageWithLeftCapWidth:kButtonLabelX topCapHeight:0];
  [self.loginButton setBackgroundImage:image forState:UIControlStateNormal];


  image = [[UIImage imageNamed:@"login-button-small-pressed.png"]
           stretchableImageWithLeftCapWidth:kButtonLabelX topCapHeight:0];
  [self.loginButton setBackgroundImage:image forState:UIControlStateHighlighted];

  [self.loginButton setTitle:NSLocalizedString(@"LOGIN_WITH_FACEBOOK", @"") forState:UIControlStateNormal];
  
  [self addSubview:loginButton];
}

-(void) layoutSubviews {
  imageView.center = CGPointMake(self.center.x, self.center.y-60);
  self.loginButton.center = CGPointMake(self.center.x, self.center.y+75);
}


@end
