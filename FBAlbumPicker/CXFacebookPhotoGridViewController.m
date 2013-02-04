//
//  CXFacebookPhotoGridViewController.m
//  FBAlbumPicker
//
//  Created by Brad Smith on 1/22/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import "CXFacebookPhotoGridViewController.h"
#import "JSFacebook.h"
#import "AFJSONRequestOperation.h"
#import "AFNetworking.h"
#import "GKImageCropViewController.h"
#import "CXFacebookPhotoGridTableViewCell.h"
#import "CXEmptyView.h"

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
    NSArray *photos = JSON[@"data"];
    self.nextURL = JSON[@"paging"][@"next"];
    [self.photos addObjectsFromArray:photos];
    [self.tableView reloadData];
    
    
    if (self.nextURL) {
      [self loadMoreFromNetWork];
    }
  } failure:nil];
  [operation start];
}


-(void)showEmptyView {
  self.tableView.scrollEnabled = NO;
  _emptyView = [[CXEmptyView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:_emptyView];
}


-(void)hideEmptyView {
  [_emptyView removeFromSuperview];
  self.tableView.scrollEnabled = YES;
}

-(void) loadFromNetwork {
  [self showLoadingView];

  NSURL *url = self.url;
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    NSArray *photos = JSON[@"data"];
    self.nextURL = JSON[@"paging"][@"next"];
    
    self.photos = [[NSMutableArray alloc] initWithArray:photos];
    [self hideLoadingView];
    [self.tableView reloadData];
    
    if (self.nextURL) {
      [self loadMoreFromNetWork];
    }
    if (self.photos.count < 1) {
      [self showEmptyView];
    }
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
    NSLog(@"sss");
  }];
  [operation start];
}

#pragma mark -
#pragma mark CXFacebookPhotoGridTableViewCellDelegate
-(void) facebookPhotoGridTableViewCell:(CXFacebookPhotoGridTableViewCell *)cell didSelectPhoto:(NSDictionary *)photo withPreviewImage:(UIImage *)previewImage {
  NSString *sourceURL = photo[@"source"];  
  CGFloat height = [photo[@"height"] floatValue];
  CGFloat width = [photo[@"width"] floatValue];
  
  
  GKImageCropViewController *cropController = [[GKImageCropViewController alloc] init];
  cropController.contentSizeForViewInPopover = self.navigationController.contentSizeForViewInPopover;
  cropController.sourceImageSize = CGSizeMake(width, height);
  cropController.previewImage = previewImage;
  cropController.sourceImageURL = [NSURL URLWithString:sourceURL];
  cropController.delegate = self.delegate;
  [self.navigationController pushViewController:cropController animated:YES];
}
@end
