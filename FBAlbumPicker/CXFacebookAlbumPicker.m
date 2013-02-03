//
//  CXFacebookAlbumPicker.m
//  FBAlbumPicker
//
//  Created by Brad Smith on 1/22/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import "CXFacebookAlbumPicker.h"
#import "JSFacebook.h"
#import "AFNetworking.h"
#import "CXFacebookPhotoGridViewController.h"

#define kFacebookAppID @"471843082842813"
#define kFacebookAppSecret @"eea58faf22d13ee032e674979474342a"


@interface CXFacebookAlbumPicker (private)
- (void)setupCancelButton;
@end

@implementation CXFacebookAlbumPicker

#pragma mark -
#pragma mark View Lifecycle
- (id)init {
  if ([super initWithStyle:UITableViewStylePlain]) {
   
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Choose Album";
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self setupCancelButton];
}


- (void)setupCancelButton {
  UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
  self.navigationItem.leftBarButtonItem = cancel;
}



#pragma mark -


-(void)showLoadingView {
  self.tableView.scrollEnabled = NO;
  _loadingView = [[UILoadingView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:_loadingView];
}


-(void)hideLoadingView {
  [_loadingView removeFromSuperview];
  self.tableView.scrollEnabled = YES;
}


-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if ([[JSFacebook sharedInstance] isSessionValid]) {
    [self loadAlbumsFromNetwork];
  }
  else {
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(20, 100, 280, 40);
    [loginButton setTitle:@"Login to Facebook" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
  }
}

#pragma mark -
#pragma mark Buttons
- (void)loginButtonPressed:(id)sender {
  [[JSFacebook sharedInstance] setFacebookAppID:kFacebookAppID];
	[[JSFacebook sharedInstance] setFacebookAppSecret:kFacebookAppSecret];
	NSArray *permissions = @[@"user_photos"];
  [[JSFacebook sharedInstance] loginWithPermissions:permissions onSuccess:^(void) {
    NSLog(@"Sucessfully logged in!");
    // Successfully logged in
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XXX" object:nil];  
    [self loadAlbumsFromNetwork];
   } onError:^(NSError *error) {
     NSLog(@"Error while logging in: %@", [error localizedDescription]);
     // There was an error
     [[NSNotificationCenter defaultCenter] postNotificationName:@"YYY" object:nil];
   }];
}

-(void) cancelButtonPressed:(id)sender {
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

-(void) loadAlbumsFromNetwork {
  [self showLoadingView];
  
  NSString *token = [[JSFacebook sharedInstance] accessToken];
  NSString *fields = @"id,photos.limit(1).fields(picture),count,name";
  NSString *path = [NSString stringWithFormat:@"https://graph.facebook.com/me/albums?fields=%@&access_token=%@",fields,token];
  
  NSURL *url = [NSURL URLWithString:path];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    NSArray *albums = [JSON objectForKey:@"data"];
    self.albums = [[NSMutableArray alloc] initWithArray:albums];
    [self hideLoadingView];
    [self.tableView reloadData];
    
  } failure:nil];
  [operation start];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.albums count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *tvc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  NSString *albumName = [[self.albums objectAtIndex:indexPath.row] objectForKey:@"name"];
  NSNumber *count = [[self.albums objectAtIndex:indexPath.row] objectForKey:@"count"];
  
  NSDictionary *attributes = @{ NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:15] };
  NSDictionary *boldAttributes = @{ NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:15] };
  
  NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%@)",albumName,(count?count:@"0")] attributes:boldAttributes];
  [text setAttributes:attributes range:NSMakeRange(albumName.length + 1, text.length-(albumName.length + 1))];
  
  [tvc.textLabel setAttributedText:text];
  
  NSString *picture = [[[[[self.albums objectAtIndex:indexPath.row] objectForKey:@"photos"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"picture"];
  
  tvc.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  tvc.imageView.clipsToBounds = YES;
  tvc.imageView.contentMode = UIViewContentModeScaleAspectFill;
  [tvc.imageView setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:@"albumPlaceholder"]];

  
  return tvc;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  CXFacebookPhotoGridViewController *vc = [[CXFacebookPhotoGridViewController alloc] init];
  vc.title =  [[self.albums objectAtIndex:indexPath.row] objectForKey:@"name"];
  vc.albumID =  [[self.albums objectAtIndex:indexPath.row] objectForKey:@"id"];;
  
  [self.navigationController pushViewController:vc animated:YES];
}

@end
