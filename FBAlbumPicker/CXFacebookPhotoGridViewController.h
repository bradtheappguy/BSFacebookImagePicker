//
//  CXFacebookPhotoGridViewController.h
//  FBAlbumPicker
//
//  Created by Brad Smith on 1/22/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXEmptyView.h"
#import "CXFacebookNetworkViewController.h"

@protocol CXFacebookImagePickerDelegate;

@interface CXFacebookPhotoGridViewController : CXFacebookNetworkViewController {
  CXEmptyView *_emptyView;
}

@property (nonatomic) NSURL *url;
@property (nonatomic) NSMutableArray *photos;
@property (nonatomic) NSString *nextURL;
@property (weak, nonatomic) id <CXFacebookImagePickerDelegate> delegate;

@property UINavigationController *navigationController;

-(void) loadFromNetwork;

@end
