//
//  CXFacebookNetworkViewController.m
//  FBAlbumPicker
//
//  Created by Brad Smith on 2/3/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import "CXFacebookNetworkViewController.h"

@implementation CXFacebookNetworkViewController

@synthesize delegate, navigationController, items;

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


-(void)showLoadingView {
  if (!_loadingView) {
      _loadingView = [[UILoadingView alloc] initWithFrame:self.view.bounds];
  }
  self.tableView.scrollEnabled = NO;
  [self.view addSubview:_loadingView];
}


-(void)hideLoadingView {
  [_loadingView removeFromSuperview];
  self.tableView.scrollEnabled = YES;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
}


-(void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if ([[JSFacebook sharedInstance] isSessionValid]) {
    if (self.items.count < 1) {
      [self loadFromNetwork];
    }
  }
}

-(void) showEmptyView {
  self.tableView.scrollEnabled = NO;
  _emptyView = [[CXEmptyView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:_emptyView];
}

-(void) loadFromNetwork {
  [self showLoadingView];
  
  NSURL *url = self.url;
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                        NSArray *data = JSON[@"data"];
                                                                                        self.nextURL = JSON[@"paging"][@"next"];
                                                                                        
                                                                                        self.items = [[NSMutableArray alloc] initWithArray:data];
                                                                                        [self hideLoadingView];
                                                                                        [self.tableView reloadData];
                                                                                        
                                                                                        if (self.nextURL) {
                                                                                          [self loadMoreFromNetWork];
                                                                                        }
                                                                                        if (self.items.count < 1) {
                                                                                          [self showEmptyView];
                                                                                        }
                                                                                      } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
                                                                                        NSLog(@"sss");
                                                                                      }];
  [operation start];
}

-(void) loadMoreFromNetWork {
  
}

@end
