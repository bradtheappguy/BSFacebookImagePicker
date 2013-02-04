//
//  CXFacebookAlbumPicker.m
//  FBAlbumPicker
//
//  Created by Brad Smith on 1/22/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import "CXFacebookAlbumPickerController.h"
#import "CXFacebookPhotoGridViewController.h"


@implementation CXFacebookAlbumPickerController



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
  //[tvc.imageView setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:@"albumPlaceholder"]];
  [tvc.imageView setImage:[UIImage imageNamed:@"albumPlaceholder"]];
  
  UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
  [iv setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:@"albumPlaceholder"]];
  [tvc.contentView addSubview:iv];
  
  return tvc;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CXFacebookPhotoGridViewController *vc = [[CXFacebookPhotoGridViewController alloc] init];
  vc.title =  (self.items)[indexPath.row][@"name"];
  NSString *albumID =  (self.items)[indexPath.row][@"id"];;
  vc.delegate = self.delegate;
  
  NSString *token = [[JSFacebook sharedInstance] accessToken];
  NSString *fields = @"picture,source,height,width";
  NSString *path = [NSString stringWithFormat:@"https://graph.facebook.com/%@/photos?fields=%@&access_token=%@",albumID,fields,token];
  vc.url = [NSURL URLWithString:path];
  vc.navigationController = self.navigationController;
  [self.navigationController pushViewController:vc animated:YES];
}

@end
