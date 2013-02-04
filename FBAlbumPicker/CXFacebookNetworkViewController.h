//
//  CXFacebookNetworkViewController.h
//  FBAlbumPicker
//
//  Created by Brad Smith on 2/3/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILoadingView.h"
#import "JSFacebook.h"
#import "CXFacebookImagePickerController.h"
#import "AFNetworking.h"
#import "CXEmptyView.h"

@interface CXFacebookNetworkViewController : UITableViewController {
  UIView *_loadingView;
  CXEmptyView *_emptyView;
}

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic) NSURL *url;
@property (nonatomic) NSString *nextURL;



@property (weak) id <CXFacebookImagePickerDelegate> delegate;
@property (weak) UINavigationController *navigationController;

-(void) loadFromNetwork;
-(void)showLoadingView;
-(void)hideLoadingView;
-(void) loadMoreFromNetWork;

@end
