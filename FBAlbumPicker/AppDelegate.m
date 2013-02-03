//
//  CXAppDelegate.m
//  FBAlbumPicker
//
//  Created by Brad Smith on 1/22/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import "AppDelegate.h"
#import "JSFacebook.h"
#import "CXFacebookAlbumPicker.h"

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	 self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  [self.window makeKeyAndVisible];
  
  
  UIViewController *vc = [[UIViewController alloc] init];
  vc.view.backgroundColor = [UIColor whiteColor];
  
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  button.frame = CGRectMake(0, 0, self.window.bounds.size.width-40, 40);
  [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [vc.view addSubview:button];
  
  self.window.rootViewController = vc;
  
  
 
  return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
  NSLog(@"Open URL: %@", url);
  [[JSFacebook sharedInstance] handleCallbackURL:url];
  return YES;
}


-(void) buttonPressed:(id) sender {
  CXFacebookAlbumPicker *albumPicker = [[CXFacebookAlbumPicker alloc] init];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:albumPicker];
  [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
}
@end
