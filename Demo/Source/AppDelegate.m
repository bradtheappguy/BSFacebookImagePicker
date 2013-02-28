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


#import "AppDelegate.h"
#import "BSFacebook.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
#define kFacebookAppID @"235162033164366"
#define kFacebookAppSecret @"46919046df740b4eec16ddeac86b9dc5"
  [[BSFacebook sharedInstance] setFacebookAppID:kFacebookAppID];
  [[BSFacebook sharedInstance] setFacebookAppSecret:kFacebookAppSecret];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [self.window makeKeyAndVisible];
  
  UIViewController *vc = [[UIViewController alloc] init];
  vc.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
  
  imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
  imageView.backgroundColor = [UIColor lightGrayColor];
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  [vc.view addSubview:imageView];
  
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [button setTitle:@"Chose Image From Facebook" forState:UIControlStateNormal];
  button.frame = CGRectMake(20, 330, self.window.bounds.size.width-40, 40);
  [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [vc.view addSubview:button];
  
  UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
  logoutButton.frame = CGRectMake(20, 390, self.window.bounds.size.width/2-50, 40);
  [logoutButton addTarget:self action:@selector(logoutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [vc.view addSubview:logoutButton];
  
  self.window.rootViewController = vc;
  return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  NSLog(@"Open URL: %@", url);
  [[BSFacebook sharedInstance] handleCallbackURL:url];
  return YES;
}


-(void) buttonPressed:(id) sender {
  BSFacebookImagePickerController *albumPicker = [[BSFacebookImagePickerController alloc] init];
  albumPicker.delegate = self;
  [self.window.rootViewController presentViewController:albumPicker animated:YES completion:nil];
}
 
-(void) logoutButtonPressed:(id) sender {
  [[BSFacebook sharedInstance] logout];
}

#pragma mark
#pragma mark BSFacebookImagePickerControllerDelegate Methods
- (void)imagePickerController:(BSFacebookImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *image = info[@"UIImagePickerControllerEditedImage"];
  imageView.image = image;
  [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(BSFacebookImagePickerController *)picker {
  [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end