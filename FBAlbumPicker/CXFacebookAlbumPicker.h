//
//  CXFacebookAlbumPicker.h
//  FBAlbumPicker
//
//  Created by Brad Smith on 1/22/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILoadingView.h"

@interface CXFacebookAlbumPicker : UITableViewController {
  UILoadingView *_loadingView;
}

@property (nonatomic, strong) NSMutableArray *albums;

-(void) loadAlbumsFromNetwork;


@end
