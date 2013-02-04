//
//  CXFacebookAlbumPicker.m
//  FBAlbumPicker
//
//  Created by Brad Smith on 1/22/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import "CXFacebookImagePickerController.h"
#import "JSFacebook.h"
#import "AFNetworking.h"
#import "CXFacebookPhotoGridViewController.h"
#import "CXFacebookAlbumPickerController.h"
#import "CXFacebookFriendsViewController.h"

#define kFacebookAppID @"471843082842813"
#define kFacebookAppSecret @"eea58faf22d13ee032e674979474342a"


@interface CXFacebookImagePickerController (private)
- (void)setupCancelButton;
@end

@implementation CXFacebookImagePickerController

@synthesize delegate, viewControllers;

#pragma mark -
#pragma mark View Lifecycle
- (id)init {
  if ([super init]) {
    
    [self.navigationController setToolbarItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil]]];
    
    CXFacebookAlbumPickerController *albumPicker = [[CXFacebookAlbumPickerController alloc] init];
    
    CXFacebookPhotoGridViewController *photosOfYou = [[CXFacebookPhotoGridViewController alloc] init];
    photosOfYou.title = @"Your Photos";
    NSString *token = [[JSFacebook sharedInstance] accessToken];
    NSString *fields = @"picture,source,height,width";
    NSString *path = [NSString stringWithFormat:@"https://graph.facebook.com/me/photos?access_token=%@&fields=%@",token,fields];
    photosOfYou.url = [NSURL URLWithString:path];
    photosOfYou.delegate = self.delegate;
    
    CXFacebookFriendsViewController *friendsViewController = [[CXFacebookFriendsViewController alloc] init];
    
    self.viewControllers = @[photosOfYou,albumPicker,friendsViewController];
    
    _currentViewController = albumPicker;

  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  [self setUpToolbar];
  self.title = NSLocalizedString(@"CHOOSE_ALBUM", @"");
  self.view.backgroundColor = [UIColor greenColor];
  [self setupCancelButton];
  [self.view addSubview:_currentViewController.view];
  _currentViewController.view.frame = self.view.bounds;
  [(CXFacebookAlbumPickerController *)_currentViewController setNavigationController:self.navigationController];
}

-(void) setUpToolbar{
  UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"PHOTOS_OF_YOU",@""),
                                                                                     NSLocalizedString(@"ALBUMS",@""),
                                                                                     NSLocalizedString(@"FRIENDS",@"")]];
  segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
  segmentedControl.selectedSegmentIndex = 1;
  [segmentedControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
  self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                        [[UIBarButtonItem alloc] initWithCustomView:segmentedControl],
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]
                      ];
  
}


- (void)setupCancelButton {
  UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
  self.navigationItem.rightBarButtonItem = cancel;
}



#pragma mark -
#pragma mark LoadingView





-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if ([[JSFacebook sharedInstance] isSessionValid]) {
    
  }
  else {
    _loginView = [[CXLoginView alloc] initWithFrame:self.view.bounds];
    [_loginView.loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginView];
  }
  [_currentViewController viewDidAppear:animated];
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setToolbarHidden:NO animated:animated];
  [_currentViewController viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.navigationController setToolbarHidden:YES animated:animated];
  [_currentViewController viewWillDisappear:animated];
}

#pragma mark -
#pragma mark Buttons
- (void)loginButtonPressed:(id)sender {
  [[JSFacebook sharedInstance] setFacebookAppID:kFacebookAppID];
	[[JSFacebook sharedInstance] setFacebookAppSecret:kFacebookAppSecret];
	NSArray *permissions = @[@"user_photos"];
  [[JSFacebook sharedInstance] loginWithPermissions:permissions onSuccess:^(void) {
    NSLog(@"Sucessfully logged in!");
    [_loginView removeFromSuperview];
   } onError:^(NSError *error) {
     NSLog(@"Error while logging in: %@", [error localizedDescription]);
   }];
}

-(void) cancelButtonPressed:(id)sender {
  [self.delegate imagePickerControllerDidCancel:self];
}

#pragma mark -

-(void) segmentedControlValueDidChange:(UISegmentedControl *)control {
  UIViewController *nextViewController = [self.viewControllers objectAtIndex:control.selectedSegmentIndex];
  [_currentViewController viewWillDisappear:YES];
  [_currentViewController.view removeFromSuperview];
  [_currentViewController viewDidDisappear:YES];
  [nextViewController viewWillAppear:YES];
  [self.view addSubview:nextViewController.view];
  [nextViewController viewDidAppear:YES];
  _currentViewController = nextViewController;
  _currentViewController.view.frame = self.view.bounds;
  [self.navigationController setToolbarHidden:NO animated:NO];
  [(CXFacebookAlbumPickerController *)_currentViewController setNavigationController:self.navigationController];

}
@end
