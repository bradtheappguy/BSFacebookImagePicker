//
//  CXFacebookPhotoGridViewController.h
//  FBAlbumPicker
//
//  Created by Brad Smith on 1/22/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILoadingView.h"

@protocol CXFacebookImagePickerDelegate;

@interface CXFacebookPhotoGridViewController : UITableViewController {
  UILoadingView *_loadingView;
}
@property (nonatomic) NSString *albumID;
@property (nonatomic) NSMutableArray *photos;
@property (nonatomic) NSString *nextURL;
@property (weak, nonatomic) id <CXFacebookImagePickerDelegate> delegate;

-(void) loadFromNetwork;

@end
