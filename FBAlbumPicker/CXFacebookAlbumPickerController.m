//
//  CXFacebookAlbumPicker.m
//  FBAlbumPicker
//
//  Created by Brad Smith on 1/22/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import "CXFacebookAlbumPickerController.h"
#import "JSFacebook.h"
#import "AFNetworking.h"
#import "CXFacebookPhotoGridViewController.h"

#define kFacebookAppID @"471843082842813"
#define kFacebookAppSecret @"eea58faf22d13ee032e674979474342a"


@interface CXFacebookAlbumPickerController (private)
- (void)setupCancelButton;
@end

@implementation CXFacebookAlbumPickerController


#pragma mark -
#pragma mark View Lifecycle
- (id)init {
  if ([super initWithStyle:UITableViewStylePlain]) {
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.tableView.backgroundColor = [UIColor whiteColor];
}


#pragma mark -
#pragma mark LoadingView


-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if ([[JSFacebook sharedInstance] isSessionValid]) {
    if (self.albums.count < 1) {
      [self loadAlbumsFromNetwork];
    }
  }
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setToolbarHidden:NO animated:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.navigationController setToolbarHidden:YES animated:animated];
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
    NSArray *albums = JSON[@"data"];
    self.albums = [[NSMutableArray alloc] initWithArray:albums];
    [self hideLoadingView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
  tvc.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
  tvc.textLabel.numberOfLines = 0;
  
  NSString *albumName = (self.albums)[indexPath.row][@"name"];
  NSNumber *count = (self.albums)[indexPath.row][@"count"];
  
  NSDictionary *attributes = @{ NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:15] };
  NSDictionary *boldAttributes = @{ NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:15] };
  
  NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%@)",albumName,(count?count:@"0")] attributes:boldAttributes];
  [text setAttributes:attributes range:NSMakeRange(albumName.length + 1, text.length-(albumName.length + 1))];
  
  [tvc.textLabel setAttributedText:text];
  
  NSString *picture = (self.albums)[indexPath.row][@"photos"][@"data"][0][@"picture"];
  
  tvc.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  tvc.imageView.clipsToBounds = YES;
  tvc.imageView.contentMode = UIViewContentModeScaleAspectFill;
  //[tvc.imageView setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:@"albumPlaceholder"]];
  [tvc.imageView setImage:[UIImage imageNamed:@"albumPlaceholder"]];
  
  UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
  [iv setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:@"albumPlaceholder"]];
  [tvc.contentView addSubview:iv];
  
  return tvc;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CXFacebookPhotoGridViewController *vc = [[CXFacebookPhotoGridViewController alloc] init];
  vc.title =  (self.albums)[indexPath.row][@"name"];
  NSString *albumID =  (self.albums)[indexPath.row][@"id"];;
  vc.delegate = self.delegate;
  
  NSString *token = [[JSFacebook sharedInstance] accessToken];
  NSString *fields = @"picture,source,height,width";
  NSString *path = [NSString stringWithFormat:@"https://graph.facebook.com/%@/photos?fields=%@&access_token=%@",albumID,fields,token];
  vc.url = [NSURL URLWithString:path];
  vc.navigationController = self.navigationController;
  [self.navigationController pushViewController:vc animated:YES];
}

@end
