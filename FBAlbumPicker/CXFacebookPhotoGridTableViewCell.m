//
//  CXFacebookPhotoGridTableViewCell.m
//  FBAlbumPicker
//
//  Created by Brad Smith on 2/2/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import "CXFacebookPhotoGridTableViewCell.h"
#import "AFNetworking.h"
#import "GKImageCropViewController.h"

@implementation CXFacebookPhotoGridTableViewCell
@synthesize navigationController;
@synthesize delegate;

static CGFloat kThumbnailLength = 75;
static CGFloat kThumbnailMargin = 4;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      
      _imageViews = [[NSMutableArray alloc] initWithCapacity:4];
      for (int c = 0; c < 4;c++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kThumbnailMargin*(c+1)) + (75*c), 2, 75, 75)];
        imageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:imageView];
        imageView.tag = c;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPressed:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        [_imageViews addObject:imageView];
      }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImages:(NSArray *)images {
  _images = images;

  if (images.count >= 1) [[_imageViews objectAtIndex:0] setImageWithURL:[NSURL URLWithString:[[images objectAtIndex:0] objectForKey:@"picture"]]];
  if (images.count >= 2) [[_imageViews objectAtIndex:1] setImageWithURL:[NSURL URLWithString:[[images objectAtIndex:1] objectForKey:@"picture"]]];
  if (images.count >= 3) [[_imageViews objectAtIndex:2] setImageWithURL:[NSURL URLWithString:[[images objectAtIndex:2] objectForKey:@"picture"]]];
  if (images.count >= 4) [[_imageViews objectAtIndex:3] setImageWithURL:[NSURL URLWithString:[[images objectAtIndex:3] objectForKey:@"picture"]]];
}

- (void) imageViewPressed:(UITapGestureRecognizer *)recoginizer {
  
  NSDictionary *photo = [_images objectAtIndex:recoginizer.view.tag];
  [self.delegate facebookPhotoGridTableViewCell:self didSelectPhoto:photo];
  
  
  

}

@end
