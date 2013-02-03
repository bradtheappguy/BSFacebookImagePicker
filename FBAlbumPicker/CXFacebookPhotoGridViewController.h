//
//  CXFacebookPhotoGridViewController.h
//  FBAlbumPicker
//
//  Created by Brad Smith on 1/22/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXFacebookPhotoGridViewController : UITableViewController
@property (nonatomic) NSString *albumID;
@property (nonatomic) NSMutableArray *photos;
@property (nonatomic) NSString *nextURL;

-(void) loadFromNetwork;

@end
