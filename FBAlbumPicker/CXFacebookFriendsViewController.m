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
