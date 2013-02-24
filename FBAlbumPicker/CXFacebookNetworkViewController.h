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

#import <UIKit/UIKit.h>
#import "UILoadingView.h"
#import "JSFacebook.h"
#import "CXFacebookImagePickerController.h"
#import "AFNetworking.h"
#import "CXEmptyView.h"

@interface CXFacebookNetworkViewController : UITableViewController {
  UIView *_loadingView;
  CXEmptyView *_emptyView;
}

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic) NSURL *url;
@property (nonatomic) NSString *nextURL;



@property (weak) id <CXFacebookImagePickerDelegate> delegate;
@property (weak) UINavigationController *navigationController;

-(void) loadFromNetwork;
-(void) showLoadingView;
-(void) hideLoadingView;
-(void) loadMoreFromNetwork;

@end
