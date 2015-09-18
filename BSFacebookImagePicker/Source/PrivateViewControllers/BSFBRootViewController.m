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

#import "BSFBRootViewController.h"
#import "BSFacebook.h"
#import "AFNetworking.h"
#import "BSFBPhotoGridViewController.h"
#import "BSFBAlbumPickerController.h"
#import "BSFBFriendsViewController.h"




@interface BSFBRootViewController (private)
- (void)setupCancelButton;
@end

@implementation BSFBRootViewController

@synthesize delegate, viewControllers;

#pragma mark -
#pragma mark View Lifecycle
- (id)init {
  if (self = [super init]) {
    
    [self.navigationController setToolbarItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil]]];
    
    NSString *token = [[BSFacebook sharedInstance] accessToken];
    NSString *fields = @"id,photos.limit(1).fields(picture),count,name";
    NSString *path = [NSString stringWithFormat:@"https://graph.facebook.com/me/albums?fields=%@&access_token=%@",fields,token];
    
    BSFBAlbumPickerController *albumPicker = [[BSFBAlbumPickerController alloc] init];
    albumPicker.url = [NSURL URLWithString:path];
    
    BSFBPhotoGridViewController *photosOfYou = [[BSFBPhotoGridViewController alloc] init];


    fields = @"picture,source,height,width";
    path = [NSString stringWithFormat:@"https://graph.facebook.com/me/photos?access_token=%@&fields=%@",token,fields];
    photosOfYou.url = [NSURL URLWithString:path];
    
    BSFBFriendsViewController *friendsViewController = [[BSFBFriendsViewController alloc] init];
    NSMutableArray *controllers = [@[photosOfYou,albumPicker,friendsViewController] mutableCopy];
    if (![BSFacebook sharedInstance].showFriendsPhotos) {
        [controllers removeObject:friendsViewController];
    }
  
    self.viewControllers = controllers;
    
    _currentViewController = albumPicker;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginView) name:@"USER_DID_LOGOUT" object:nil];

  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupToolbar];
  self.title = Localized(@"CHOOSE_ALBUM");
  self.view.backgroundColor = [UIColor greenColor];
  [self setupCancelButton];
  self.edgesForExtendedLayout=UIRectEdgeNone;
  [self.view addSubview:_currentViewController.view];
  _currentViewController.view.frame = self.view.bounds;
  [(BSFBAlbumPickerController *)_currentViewController setNavigationController:self.navigationController];
  [(BSFBAlbumPickerController *)_currentViewController setDelegate:self.delegate];
}

-(void) setupToolbar {
  NSMutableArray *segments = [@[Localized(@"PHOTOS_OF_YOU"),
                                Localized(@"ALBUMS"),
                                Localized(@"FRIENDS")] mutableCopy];
  if (![BSFacebook sharedInstance].showFriendsPhotos) {
        [segments removeObject:Localized(@"FRIENDS")];
  }
    
  UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
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



-(void) showLoginView {
  if (!_loginView) {
    _loginView = [[BSFBLoginView alloc] initWithFrame:self.view.bounds];
    [_loginView.loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  }
  [self.view addSubview:_loginView];
  self.title = Localized(@"LOGIN");
}


-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [(BSFBAlbumPickerController *)_currentViewController setDelegate:self.delegate];
  [(BSFBAlbumPickerController *)_currentViewController setNavigationController:self.navigationController];
  
  [_currentViewController viewDidAppear:animated];
  [(BSFBAlbumPickerController *)_currentViewController setNavigationController:self.navigationController];
  [(BSFBAlbumPickerController *)_currentViewController setDelegate:self.delegate];
}


-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if ([[BSFacebook sharedInstance] isSessionValid]) {
    [self.navigationController setToolbarHidden:NO animated:animated];
  }
  else {
    [self.navigationController setToolbarHidden:YES animated:animated];
  }
  if ([[BSFacebook sharedInstance] isSessionValid]) {
    [[BSFacebook sharedInstance] extendAccessTokenExpiration];
  }
  else {
    [self showLoginView];
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
    
	NSMutableArray *permissions = [@[@"user_photos,friends_photos"] mutableCopy];
    if (![BSFacebook sharedInstance].showFriendsPhotos) {
        [permissions removeObject:@"friends_photos"];
    }
  [[BSFacebook sharedInstance] loginWithPermissions:permissions onSuccess:^(void) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_DID_LOGIN" object:nil];
    NSLog(@"Sucessfully logged in!");
    [self.navigationController setToolbarHidden:NO];
    [_loginView removeFromSuperview];
    self.title = Localized(@"ALBUMS");
   } onError:^(NSError *error) {
     NSLog(@"Error while logging in: %@", [error localizedDescription]);
   }];
}

-(void) cancelButtonPressed:(id)sender {
  [self.delegate imagePickerControllerDidCancel:(BSFacebookImagePickerController *)self.navigationController];
}

#pragma mark -

-(void) segmentedControlValueDidChange:(UISegmentedControl *)control {
  UIViewController *nextViewController = [self.viewControllers objectAtIndex:control.selectedSegmentIndex];
  [_currentViewController viewWillDisappear:YES];
  [_currentViewController.view removeFromSuperview];
  [_currentViewController viewDidDisappear:YES];
  [nextViewController viewWillAppear:YES];
  NSArray *titles = @[Localized(@"PHOTOS_OF_YOU"),Localized(@"ALBUMS"),Localized(@"FRIENDS")];
  self.title = [titles objectAtIndex:control.selectedSegmentIndex];
  [self.view addSubview:nextViewController.view];
  [nextViewController viewDidAppear:YES];
  [(BSFBAlbumPickerController *)nextViewController setNavigationController:self.navigationController];
  [(BSFBAlbumPickerController *)nextViewController setDelegate:self.delegate];
  
  _currentViewController = nextViewController;
  _currentViewController.view.frame = self.view.bounds;
  [self.navigationController setToolbarHidden:NO animated:NO];

}
@end
