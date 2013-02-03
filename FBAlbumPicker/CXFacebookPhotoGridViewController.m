//
//  CXFacebookPhotoGridViewController.m
//  FBAlbumPicker
//
//  Created by Brad Smith on 1/22/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import "CXFacebookPhotoGridViewController.h"
#import "JSFacebook.h"
#import "UILoadingView.h"
#import "AFJSONRequestOperation.h"
#import "AFNetworking.h"
#import "GKImageCropViewController.h"
#import "CXFacebookPhotoGridTableViewCell.h"

@interface CXFacebookPhotoGridViewController ()

@end

@implementation CXFacebookPhotoGridViewController

@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
      self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

-(void) viewDidLoad {
  self.tableView.rowHeight = 80;
  
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (self.photos.count < 1) {
    [self loadFromNetwork];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.photos count] / 4 + (([self.photos count] % 4)?1:0);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSUInteger start = indexPath.row * 4;

  NSUInteger end = MIN(start + 4, self.photos.count);

  NSArray *images = [self.photos objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(start, (end-start))]];
  
  CXFacebookPhotoGridTableViewCell *tvc = [[CXFacebookPhotoGridTableViewCell alloc] initWithReuseIdentifier:nil];
  tvc.images = images;
  tvc.navigationController = self.navigationController;
  tvc.delegate = self;
  
  return tvc;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void) loadMoreFromNetWork {
  NSURL *url = [NSURL URLWithString:self.nextURL];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];

  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    NSArray *photos = [JSON objectForKey:@"data"];
    self.nextURL = [[JSON objectForKey:@"paging"] objectForKey:@"next"];
    [self.photos addObjectsFromArray:photos];
    [self.tableView reloadData];
    
    if (self.nextURL) {
      [self loadMoreFromNetWork];
    }
  } failure:nil];
  [operation start];
}


-(void)showLoadingView {
  self.tableView.scrollEnabled = NO;
  _loadingView = [[UILoadingView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:_loadingView];
}


-(void)hideLoadingView {
  [_loadingView removeFromSuperview];
  self.tableView.scrollEnabled = YES;
}

-(void) loadFromNetwork {
  [self showLoadingView];
  
  NSString *token = [[JSFacebook sharedInstance] accessToken];
  NSString *fields = @"picture,source,height,width";
  NSString *path = [NSString stringWithFormat:@"https://graph.facebook.com/%@/photos?fields=%@&access_token=%@",self.albumID,fields,token];
  
  NSURL *url = [NSURL URLWithString:path];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    NSArray *photos = [JSON objectForKey:@"data"];
    self.nextURL = [[JSON objectForKey:@"paging"] objectForKey:@"next"];
    
    self.photos = [[NSMutableArray alloc] initWithArray:photos];
    [self hideLoadingView];
    [self.tableView reloadData];
    
    if (self.nextURL) {
      [self loadMoreFromNetWork];
    }
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
    NSLog(@"sss");
  }];
  [operation start];
}

#pragma mark -
#pragma mark CXFacebookPhotoGridTableViewCellDelegate
-(void) facebookPhotoGridTableViewCell:(CXFacebookPhotoGridTableViewCell *)cell didSelectPhoto:(NSDictionary *)photo withPreviewImage:(UIImage *)previewImage {
  NSString *sourceURL = [photo objectForKey:@"source"];
  NSString *previewURL = [photo objectForKey:@"picture"];
  
  CGFloat height = [[photo objectForKey:@"height"] floatValue];
  CGFloat width = [[photo objectForKey:@"width"] floatValue];
  
  
  GKImageCropViewController *cropController = [[GKImageCropViewController alloc] init];
  cropController.contentSizeForViewInPopover = self.navigationController.contentSizeForViewInPopover;
  cropController.sourceImageSize = CGSizeMake(width, height);
  cropController.previewImage = previewImage;
  cropController.sourceImageURL = [NSURL URLWithString:sourceURL];
  cropController.delegate = self.delegate;
  [self.navigationController pushViewController:cropController animated:YES];
}
@end
