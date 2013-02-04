//
//  CXFacebookAlbumPicker.h
//  FBAlbumPicker
//
//  Created by Brad Smith on 1/22/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXLoginView.h"
#import "CXFacebookNetworkViewController.h"

@protocol CXFacebookImagePickerDelegate;

@interface CXFacebookAlbumPickerController : CXFacebookNetworkViewController

@property (nonatomic, strong) NSMutableArray *albums;
@property (weak) id <CXFacebookImagePickerDelegate> delegate;

@property (weak) UINavigationController *navigationController;

-(void) loadAlbumsFromNetwork;

@end

