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

@interface CXFacebookPhotoGridViewController ()

@end

@implementation CXFacebookPhotoGridViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
  [self loadFromNetwork];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *tvc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
   NSString *picture = [[self.photos objectAtIndex:indexPath.row] objectForKey:@"picture"];
  
  tvc.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
  tvc.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  tvc.imageView.clipsToBounds = YES;
  tvc.imageView.contentMode = UIViewContentModeScaleAspectFill;
  [tvc.imageView setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:@"fox"]];
  return tvc;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
  NSString *pictureURL = [photo objectForKey:@"source"];
  
  CGFloat height = [[photo objectForKey:@"height"] floatValue];
  
  CGFloat width = [[photo objectForKey:@"width"] floatValue];
  
  
  GKImageCropViewController *cropController = [[GKImageCropViewController alloc] init];
  cropController.contentSizeForViewInPopover = self.contentSizeForViewInPopover;
  cropController.sourceImageSize = CGSizeMake(width, height);
  cropController.sourceImageURL = [NSURL URLWithString:pictureURL];
  
 // cropController.delegate = self;
  [self.navigationController pushViewController:cropController animated:YES];
  
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

-(void) loadFromNetwork {
  //[self showLoadingView];
  
  NSString *token = [[JSFacebook sharedInstance] accessToken];
  NSString *fields = @"picture,source,height,width";
  NSString *path = [NSString stringWithFormat:@"https://graph.facebook.com/%@/photos?fields=%@&access_token=%@",self.albumID,fields,token];
  
  NSURL *url = [NSURL URLWithString:path];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    NSArray *photos = [JSON objectForKey:@"data"];
    self.nextURL = [[JSON objectForKey:@"paging"] objectForKey:@"next"];
    
    self.photos = [[NSMutableArray alloc] initWithArray:photos];
   // [self hideLoadingView];
    [self.tableView reloadData];
    
    if (self.nextURL) {
      [self loadMoreFromNetWork];
    }
  } failure:nil];
  [operation start];
}

@end
