//
//  CXFacebookNetworkViewController.m
//  FBAlbumPicker
//
//  Created by Brad Smith on 2/3/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import "CXFacebookNetworkViewController.h"

@interface CXFacebookNetworkViewController ()

@end

@implementation CXFacebookNetworkViewController

@synthesize delegate, navigationController;

-(void)showLoadingView {
  if (!_loadingView) {
      _loadingView = [[UILoadingView alloc] initWithFrame:self.view.bounds];
  }
  self.tableView.scrollEnabled = NO;
  [self.view addSubview:_loadingView];
}


-(void)hideLoadingView {
  [_loadingView removeFromSuperview];
  self.tableView.scrollEnabled = YES;
}


@end
