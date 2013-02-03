//
//  CXFacebookPhotoGridTableViewCell.h
//  FBAlbumPicker
//
//  Created by Brad Smith on 2/2/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CXFacebookPhotoGridTableViewCell;

@interface CXFacebookPhotoGridTableViewCell : UITableViewCell {
  NSArray *_images;
  NSMutableArray *_imageViews;
}

@property (nonatomic) UINavigationController *navigationController;
@property  id <CXFacebookPhotoGridTableViewCell> delegate;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setImages:(NSArray *)images;

@end


@protocol CXFacebookPhotoGridTableViewCell
-(void) facebookPhotoGridTableViewCell:(CXFacebookPhotoGridTableViewCell *)cell didSelectPhoto:(NSDictionary *)photo;
@end
