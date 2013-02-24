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
  if (self = [super init]) {
    
    [self.navigationController setToolbarItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil]]];
    
    NSString *token = [[JSFacebook sharedInstance] accessToken];
    NSString *fields = @"id,photos.limit(1).fields(picture),count,name";
    NSString *path = [NSString stringWithFormat:@"https://graph.facebook.com/me/albums?fields=%@&access_token=%@",fields,token];
    
    CXFacebookAlbumPickerController *albumPicker = [[CXFacebookAlbumPickerController alloc] init];
    albumPicker.url = [NSURL URLWithString:path];
    
    CXFacebookPhotoGridViewController *photosOfYou = [[CXFacebookPhotoGridViewController alloc] init];
    photosOfYou.title = @"Your Photos";

    fields = @"picture,source,height,width";
    path = [NSString stringWithFormat:@"https://graph.facebook.com/me/photos?access_token=%@&fields=%@",token,fields];
    photosOfYou.url = [NSURL URLWithString:path];
    
    CXFacebookFriendsViewController *friendsViewController = [[CXFacebookFriendsViewController alloc] init];
    
    self.viewControllers = @[photosOfYou,albumPicker,friendsViewController];
    
    _currentViewController = albumPicker;

  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupToolbar];
  self.title = NSLocalizedString(@"CHOOSE_ALBUM", @"");
  self.view.backgroundColor = [UIColor greenColor];
  [self setupCancelButton];
  [self.view addSubview:_currentViewController.view];
  _currentViewController.view.frame = self.view.bounds;
  [(CXFacebookAlbumPickerController *)_currentViewController setNavigationController:self.navigationController];
  [(CXFacebookAlbumPickerController *)_currentViewController setDelegate:self.delegate];
}

-(void) setupToolbar {
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
  [(CXFacebookAlbumPickerController *)_currentViewController setDelegate:self.delegate];
  [(CXFacebookAlbumPickerController *)_currentViewController setNavigationController:self.navigationController];
  if ([[JSFacebook sharedInstance] isSessionValid]) {
    
  }
  else {
    _loginView = [[CXLoginView alloc] initWithFrame:self.view.bounds];
    [_loginView.loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginView];
  }
  [_currentViewController viewDidAppear:animated];
  [(CXFacebookAlbumPickerController *)_currentViewController setNavigationController:self.navigationController];
  [(CXFacebookAlbumPickerController *)_currentViewController setDelegate:self.delegate];
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if ([[JSFacebook sharedInstance] isSessionValid]) {
    [self.navigationController setToolbarHidden:NO animated:animated];
  }
  else {
    [self.navigationController setToolbarHidden:YES animated:animated];
  }
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
	NSArray *permissions = @[@"user_photos,friends_photos"];
  [[JSFacebook sharedInstance] loginWithPermissions:permissions onSuccess:^(void) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_DID_LOGIN" object:nil];
    NSLog(@"Sucessfully logged in!");
    [self.navigationController setToolbarHidden:NO];
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
  [(CXFacebookAlbumPickerController *)nextViewController setNavigationController:self.navigationController];
  [(CXFacebookAlbumPickerController *)nextViewController setDelegate:self.delegate];
  
  _currentViewController = nextViewController;
  _currentViewController.view.frame = self.view.bounds;
  [self.navigationController setToolbarHidden:NO animated:NO];

}
@end
