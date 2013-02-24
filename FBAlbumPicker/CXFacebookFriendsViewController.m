//
//  CXFacebookFriendsViewController.m
//  FBAlbumPicker
//
//  Created by Brad Smith on 2/3/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import "CXFacebookFriendsViewController.h"
#import "CXFacebookAlbumPickerController.h"


@implementation CXFacebookFriendsViewController



- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.rowHeight = 50;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) loadFromNetwork {
  NSString *fields = @"id,name,picture";
  NSString *path = [NSString stringWithFormat:@"https://graph.facebook.com/me/friends?fields=%@",fields];
  
  self.url = [NSURL URLWithString:path];
  
  [super loadFromNetwork];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = nil;
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  cell.textLabel.text = self.items[indexPath.row][@"name"];
  [cell.imageView setImageWithURL:[NSURL URLWithString:self.items[indexPath.row][@"picture"][@"data"][@"url"]] placeholderImage:[UIImage imageNamed:@"albumPlaceholder"]];
  
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *token = [[JSFacebook sharedInstance] accessToken];
  NSString *fields = @"id,photos.limit(1).fields(picture),count,name";
  NSString *userID = self.items[indexPath.row][@"id"];
  NSString *path = [NSString stringWithFormat:@"https://graph.facebook.com/%@/albums?fields=%@",userID,fields];
  
  CXFacebookAlbumPickerController *albumPicker = [[CXFacebookAlbumPickerController alloc] init];
  albumPicker.url = [NSURL URLWithString:path];
  albumPicker.navigationController = self.navigationController;
  albumPicker.delegate  = self.delegate;
  [self.navigationController pushViewController:albumPicker animated:YES];
}

@end
