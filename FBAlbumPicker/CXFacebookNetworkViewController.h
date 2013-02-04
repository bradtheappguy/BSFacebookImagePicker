//
//  CXFacebookNetworkViewController.h
//  FBAlbumPicker
//
//  Created by Brad Smith on 2/3/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILoadingView.h"
#import "CXFacebookImagePickerController.h"

@interface CXFacebookNetworkViewController : UITableViewController {
  UIView *_loadingView;
}

@property (weak) id <CXFacebookImagePickerDelegate> delegate;
@property (weak) UINavigationController *navigationController;


-(void)showLoadingView;
-(void)hideLoadingView;

@end
