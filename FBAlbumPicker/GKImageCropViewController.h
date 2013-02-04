//
//  GKImageCropViewController.h
//  GKImagePicker
//
//  Created by Georg Kitz on 6/1/12.
//  Copyright (c) 2012 Aurora Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CXFacebookImagePickerController.h"

@interface GKImageCropViewController : UIViewController{
    UIImage *_croppedImage;
}

@property (nonatomic, strong) NSURL *sourceImageURL;
@property (nonatomic, strong) UIImage *previewImage;
@property (nonatomic, assign) CGSize sourceImageSize;
@property (nonatomic, assign) CGSize cropSize; //size of the crop rect, default is 320x320
@property (nonatomic, assign) BOOL resizeableCropArea; 
@property (nonatomic, strong) id<CXFacebookImagePickerDelegate> delegate;

@end


