//
//  GKImageCropView.h
//  GKImagePicker
//
//  Created by Georg Kitz on 6/1/12.
//  Copyright (c) 2012 Aurora Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKImageCropView : UIView

@property (nonatomic, strong) NSURL *imageURLToCrop;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGSize cropSize;
@property (nonatomic, assign) BOOL resizableCropArea;

- (UIImage *)croppedImage;

- (void)setImageURLToCrop:(NSURL *)imageURLToCrop withPlaceholderImage:(UIImage *)placeholder;

@end
