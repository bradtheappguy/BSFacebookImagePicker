//
//  CXLoginView`.m
//  FBAlbumPicker
//
//  Created by Brad Smith on 2/3/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

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
