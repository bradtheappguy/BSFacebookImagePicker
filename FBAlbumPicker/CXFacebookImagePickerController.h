//
//  CXFacebookAlbumPicker.h
//  FBAlbumPicker
//
//  Created by Brad Smith on 1/22/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILoadingView.h"
#import "CXLoginView.h"

@protocol CXFacebookImagePickerDelegate;

@interface CXFacebookImagePickerController : UIViewController {
  CXLoginView *_loginView;
  
  UIViewController *_currentViewController;
}

@property (weak) id <CXFacebookImagePickerDelegate> delegate;

@property (nonatomic) NSArray *viewControllers;

@end


@protocol CXFacebookImagePickerDelegate <UIImagePickerControllerDelegate>
- (void)imagePickerController:(CXFacebookImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(CXFacebookImagePickerController *)picker;
@end
