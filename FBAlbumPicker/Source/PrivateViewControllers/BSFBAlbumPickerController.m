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

#import "BSFBAlbumPickerController.h"
#import "BSFBPhotoGridViewController.h"


@implementation BSFBAlbumPickerController

static NSString *albumPlaceholderImageName = @"BSFBAlbumPicker.bundle/albumPlaceholder";


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.items count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *tvc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  tvc.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
  tvc.textLabel.numberOfLines = 0;
  
  NSString *albumName = (self.items)[indexPath.row][@"name"];
  NSNumber *count = (self.items)[indexPath.row][@"count"];
  
  NSDictionary *attributes = @{ NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:15] };
  NSDictionary *boldAttributes = @{ NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:15] };
  
  NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ (%@)",albumName,(count?count:@"0")] attributes:boldAttributes];
  [text setAttributes:attributes range:NSMakeRange(albumName.length + 1, text.length-(albumName.length + 1))];
  
  [tvc.textLabel setAttributedText:text];
  
  NSString *picture = (self.items)[indexPath.row][@"photos"][@"data"][0][@"picture"];
  
  tvc.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  tvc.imageView.clipsToBounds = YES;
  tvc.imageView.contentMode = UIViewContentModeScaleAspectFill;
  [tvc.imageView setImage:[UIImage imageNamed:albumPlaceholderImageName]];
  
  UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
  [iv setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:albumPlaceholderImageName]];
  [tvc.contentView addSubview:iv];
  
  return tvc;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  BSFBPhotoGridViewController *vc = [[BSFBPhotoGridViewController alloc] init];
  vc.title =  (self.items)[indexPath.row][@"name"];
  NSString *albumID =  (self.items)[indexPath.row][@"id"];;
  vc.delegate = self.delegate;
  
  NSString *fields = @"picture,source,height,width";
  NSString *path = [NSString stringWithFormat:@"https://graph.facebook.com/%@/photos?fields=%@",albumID,fields];
  vc.url = [NSURL URLWithString:path];
  vc.navigationController = self.navigationController;
  [self.navigationController pushViewController:vc animated:YES];
}

@end
