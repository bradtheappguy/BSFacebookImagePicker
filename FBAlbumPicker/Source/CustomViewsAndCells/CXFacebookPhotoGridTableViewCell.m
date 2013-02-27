/*
 * Copyright 2013 Brad Smith
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "CXFacebookPhotoGridTableViewCell.h"
#import "AFNetworking.h"
#import "ImageCropViewController.h"

static CGFloat kThumbnailLength = 75;
static CGFloat kThumbnailMargin = 4;
static NSUInteger kNumberOfImages = 4;


@implementation CXFacebookPhotoGridTableViewCell
@synthesize navigationController;
@synthesize delegate;


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      
      _imageViews = [[NSMutableArray alloc] initWithCapacity:4];
      for (int c = 0; c < kNumberOfImages ;c++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kThumbnailMargin*(c+1)) + (kThumbnailLength*c), 2, kThumbnailLength, kThumbnailLength)];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:imageView];
        imageView.tag = c;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPressed:)];
        tap.delegate = self;
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
  for (int c = 0; c < ((images.count < kNumberOfImages)?images.count:kNumberOfImages); c++) {
    [_imageViews[c] setImageWithURL:[NSURL URLWithString:images[c][@"picture"]]];
  }
}

- (void) imageViewPressed:(UITapGestureRecognizer *)recoginizer {
  NSUInteger index = recoginizer.view.tag;
  if (index < _images.count) {
    NSDictionary *photo = _images[recoginizer.view.tag];
    [self.delegate facebookPhotoGridTableViewCell:self didSelectPhoto:photo withPreviewImage:[(UIImageView *)recoginizer.view image]];
  }
}




@end
