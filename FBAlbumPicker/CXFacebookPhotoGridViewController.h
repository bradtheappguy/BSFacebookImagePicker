//
//  CXFacebookPhotoGridViewController.h
//  FBAlbumPicker
//
//  Created by Brad Smith on 1/22/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CXFacebookImagePickerDelegate;

@interface CXFacebookPhotoGridViewController : UITableViewController
@property (nonatomic) NSString *albumID;
@property (nonatomic) NSMutableArray *photos;
@property (nonatomic) NSString *nextURL;
@property(weak) id <CXFacebookImagePickerDelegate> delegate;

-(void) loadFromNetwork;

@end
