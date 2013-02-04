//
//  CXFacebookNetworkViewController.h
//  FBAlbumPicker
//
//  Created by Brad Smith on 2/3/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILoadingView.h"

@interface CXFacebookNetworkViewController : UITableViewController {
  UIView *_loadingView;
}

-(void)showLoadingView;
-(void)hideLoadingView;

@end
