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

#import "BSFBImageCropViewController.h"
#import "BSFBImageCropView.h"

@interface BSFBImageCropViewController ()

@property (nonatomic, strong) BSFBImageCropView *imageCropView;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *useButton;

- (void)cancelButtonPressed:(id)sender;
- (void)useButtonPressed:(id)sender;
- (void)setupNavigationBar;
- (void)setupCropView;

@end

@implementation BSFBImageCropViewController

static CGSize kCropSize = {300, 300};

#pragma mark -
#pragma mark Getter/Setter

@synthesize previewImage, delegate, sourceImageSize, sourceImageURL;
@synthesize imageCropView;
@synthesize toolbar;
@synthesize cancelButton;
@synthesize useButton;

#pragma mark -
#pragma Private Methods


- (void)cancelButtonPressed:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}


- (void)useButtonPressed:(id)sender {
  NSDictionary *dict = @{UIImagePickerControllerEditedImage: [self.imageCropView croppedImage]};
  [self.delegate imagePickerController:(BSFacebookImagePickerController *)self.navigationController didFinishPickingMediaWithInfo:dict];
}


- (void)setupNavigationBar {
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancelButtonPressed:)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:Localized(@"USE")
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(useButtonPressed:)];
}


- (void)setupCropView {
  self.imageCropView = [[BSFBImageCropView alloc] initWithFrame:self.view.bounds];
  self.imageCropView.imageSize = self.sourceImageSize;
  [self.imageCropView setImageURLToCrop:sourceImageURL withPlaceholderImage:self.previewImage];
  [self.imageCropView setCropSize:kCropSize];
  [self.view addSubview:self.imageCropView];
}

- (void)setupCancelButton {
  self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  
  [self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"BSFBAlbumPicker.bundle/PLCameraSheetButton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
  [self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"BSFBAlbumPicker.bundle/PLCameraSheetButtonPressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
  
  [[self.cancelButton titleLabel] setFont:[UIFont boldSystemFontOfSize:11]];
  [[self.cancelButton titleLabel] setShadowOffset:CGSizeMake(0, 1)];
  [self.cancelButton setFrame:CGRectMake(0, 0, 50, 30)];
  [self.cancelButton setTitle:Localized(@"CANCEL") forState:UIControlStateNormal];
  [self.cancelButton setTitleColor:[UIColor colorWithRed:0.173 green:0.176 blue:0.176 alpha:1] forState:UIControlStateNormal];
  [self.cancelButton setTitleShadowColor:[UIColor colorWithRed:0.827 green:0.831 blue:0.839 alpha:1] forState:UIControlStateNormal];
  [self.cancelButton  addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)setupUseButton {
  self.useButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.useButton setBackgroundImage:[[UIImage imageNamed:@"BSFBAlbumPicker.bundle/PLCameraSheetDoneButton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
  [self.useButton setBackgroundImage:[[UIImage imageNamed:@"BSFBAlbumPicker.bundle/PLCameraSheetDoneButtonPressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
  [[self.useButton titleLabel] setFont:[UIFont boldSystemFontOfSize:11]];
  [[self.useButton titleLabel] setShadowOffset:CGSizeMake(0, -1)];
  [self.useButton setFrame:CGRectMake(0, 0, 50, 30)];
  [self.useButton setTitle:Localized(@"USE") forState:UIControlStateNormal];
  [self.useButton setTitleShadowColor:[UIColor colorWithRed:0.118 green:0.247 blue:0.455 alpha:1] forState:UIControlStateNormal];
  [self.useButton  addTarget:self action:@selector(useButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  
}

- (UIImage *)_toolbarBackgroundImage {
  CGFloat components[] = {
    1., 1., 1., 1.,
    123./255., 125/255., 132./255., 1.
  };
  
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 54), YES, 0.0);
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 2);
  
  CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, 0), CGPointMake(0, 54), kCGImageAlphaNoneSkipFirst);
  
  UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	
	CGGradientRelease(gradient);
  CGColorSpaceRelease(colorSpace);
  UIGraphicsEndImageContext();
  
  return viewImage;
}


- (void)setupToolbar {
  self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
  [self.toolbar setBackgroundImage:[self _toolbarBackgroundImage] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
  [self.view addSubview:self.toolbar];
  
  [self setupCancelButton];
  [self setupUseButton];
  
  UILabel *info = [[UILabel alloc] initWithFrame:CGRectZero];
  info.text = Localized(@"MOVE_AND_SCALE");
  info.textColor = [UIColor colorWithRed:0.173 green:0.173 blue:0.173 alpha:1];
  info.backgroundColor = [UIColor clearColor];
  info.shadowColor = [UIColor colorWithRed:0.827 green:0.831 blue:0.839 alpha:1];
  info.shadowOffset = CGSizeMake(0, 1);
  info.font = [UIFont boldSystemFontOfSize:18];
  [info sizeToFit];
  
  UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
  UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *lbl = [[UIBarButtonItem alloc] initWithCustomView:info];
  UIBarButtonItem *use = [[UIBarButtonItem alloc] initWithCustomView:self.useButton];
  
  [self.toolbar setItems:@[cancel, flex, lbl, flex, use]];
}

#pragma mark -
#pragma Super Class Methods

- (id)init {
  self = [super init];
  if (self) {
    // Custom initialization
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = Localized(@"CHOOSE_PHOTO");
  [self setupNavigationBar];
  [self setupCropView];
  [self setupToolbar];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)viewDidUnload {
  [super viewDidUnload];
}


- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  self.imageCropView.frame = self.view.bounds;
  self.toolbar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 54, 320, 54);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
