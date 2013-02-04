//
//  CXFacebookAlbumPicker.h
//  FBAlbumPicker
//
//  Created by Brad Smith on 1/22/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILoadingView.h"

@protocol CXFacebookImagePickerDelegate;

@interface CXFacebookImagePickerController : UITableViewController {
  UILoadingView *_loadingView;
}

@property (nonatomic, strong) NSMutableArray *albums;
@property (weak) id <CXFacebookImagePickerDelegate> delegate;

-(void) loadAlbumsFromNetwork;

@end


@protocol CXFacebookImagePickerDelegate <UIImagePickerControllerDelegate>
- (void)imagePickerController:(CXFacebookImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(CXFacebookImagePickerController *)picker;
@end
