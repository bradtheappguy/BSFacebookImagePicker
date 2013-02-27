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

#import "CXFacebookPhotoGridViewController.h"
#import "ImageCropViewController.h"




@implementation CXFacebookPhotoGridViewController




-(void) viewDidLoad {
  [super viewDidLoad];
  self.tableView.rowHeight = 80;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.items count] / 4 + (([self.items count] % 4)?1:0);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSUInteger start = indexPath.row * 4;

  NSUInteger end = MIN(start + 4, self.items.count);

  NSArray *images = [self.items objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(start, (end-start))]];
  
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

-(void) loadMoreFromNetwork {
  NSURL *url = [NSURL URLWithString:self.nextURL];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];

  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    NSArray *photos = JSON[@"data"];
    self.nextURL = JSON[@"paging"][@"next"];
    [self.items addObjectsFromArray:photos];
    [self.tableView reloadData];
    
    
    if (self.nextURL) {
      [self loadMoreFromNetwork];
    }
  } failure:nil];
  [operation start];
}


#pragma mark -
#pragma mark CXFacebookPhotoGridTableViewCellDelegate
-(void) facebookPhotoGridTableViewCell:(CXFacebookPhotoGridTableViewCell *)cell didSelectPhoto:(NSDictionary *)photo withPreviewImage:(UIImage *)previewImage {
  NSString *sourceURL = photo[@"source"];  
  CGFloat height = [photo[@"height"] floatValue];
  CGFloat width = [photo[@"width"] floatValue];
  
  
  ImageCropViewController *cropController = [[ImageCropViewController alloc] init];
  cropController.contentSizeForViewInPopover = self.navigationController.contentSizeForViewInPopover;
  cropController.sourceImageSize = CGSizeMake(width, height);
  cropController.previewImage = previewImage;
  cropController.sourceImageURL = [NSURL URLWithString:sourceURL];
  cropController.delegate = self.delegate;
  [self.navigationController pushViewController:cropController animated:YES];
}
@end
