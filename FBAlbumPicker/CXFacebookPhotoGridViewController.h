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


@interface CXFacebookPhotoGridViewController : CXFacebookNetworkViewController {
  CXEmptyView *_emptyView;
}

@property (nonatomic) NSURL *url;
@property (nonatomic) NSMutableArray *photos;
@property (nonatomic) NSString *nextURL;


-(void) loadFromNetwork;

@end
