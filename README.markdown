# BSFacebookImagePicker for iOS

BSFacebookImagePicker is a drop-in replacement for UIImagePickerController that allows Users to choose photos from Facebook instead of the camera library.

BSFacebookImagePicker is lightweight and can be used with or without using the Facebook-iOS-SDK.

![Choose photos you are tagged in](http://i.imgur.com/Y5ri0jp.png "Choose photos you are tagged in")![Choose photos from your albums](http://i.imgur.com/cnGP9IM.png "Choose photos from your albums")
![Choose photos from your friends](http://i.imgur.com/AdhC47S.png "Choose photos from your friends")![Move and Scale. Just Like Apple!](http://i.imgur.com/9pwSg2O.png "Move and Scale. Just Like Apple!")

## Features

* Authentication using iOS single signon (iOS 5+), or Fast App Switching to the Facebook App
* Fallback Web-Based Authentication
* Authentication can be bypassed if you allready have a Facebook Access token 
* Allows the user to choose photos from:
    - Their own albums and profile photos
    - Ones they have been tagged in
    - Thier friends albums and profile photos
    - Ones thier frineds have been tagged in
* Uses an idential API to UIImagePickerController, so it can be used as a direct drop-in
* BSFacebookImagePicker is currently localized to the following languages:
    - English
    - German
    - Spanish
    - French
    - Itallian
    - Japaneese
    - Korean
    - Russian
    - Chineese (simplified)
* Skinable using UIAppearance


## Requirements

  FBAlbumPicker is build using Modern ARC based Objective-C
  AFNetworking is used for the networking
  Every attempt has been made to ensure compatibility with older versions of iOS
  

## Usage
``` objective-c
//Super easy
- (void) launchPicker {
  BSFacebookImagePickerController *picker = [[BSFacebookImagePickerController alloc] init];
  //Change to your facebook App ID and App Secret
  picker.facebookAppID = @"00000000";
  picker.facebookAppSecret = @"111111111";
  picker.delegate = self;
  [self.window.rootViewController presentViewController:picker animated:YES completion:nil];
}

//Note: BSFacebookImagePickerControllerDelegate uses the same method signatures of UIImagePickerController (drop in)
- (void)imagePickerController:(BSFacebookImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *image = info[@"UIImagePickerControllerEditedImage"];
  imageView.image = image;
  [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(BSFacebookImagePickerController *)picker {
  [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

//Inside your Application Delegate for login support:
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  [BSFacebookImagePickerController handleCallbackURL:url];
  return YES;
}
```


## Warning

This software is not yet complete.  There are a few loose ends that need to be finished before it is production ready.  I am sharing it a bit early to give s few people a heads up on what I am working on.
* Proper localilizations are not yet checked in.  The files are stubbed out but they are still engilish.  I would love some help here if you want to pitch in.  Otherwise this is going to cost me a few hundred bucks.
* The promised API to allow implementors to use existing Facebook tokens they have allready retrieved from the facebook-ios-sdk or other means has not yet been implemented
* The library is still dependant on AFNetworking.  I would like to break that dependancy in the spirit of lightweightedness.
* 

## Skinning
![Look Ma, I'm Red!](http://i.imgur.com/UzDP4F7.png "Look Ma, I'm Red!")

``` objective-c
//Skinning is super easy.  BSFacebookImagePicker uses stardard apple controls, so UIAppearance *just works*

- (void) launchPicker {
  [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
  [[UIToolbar appearance] setTintColor:[UIColor redColor]];

  BSFacebookImagePickerController *picker = [[BSFacebookImagePickerController alloc] init];
  picker.delegate = self;
  [self.window.rootViewController presentViewController:picker animated:YES completion:nil];
}

```


## Shout Outs
The following projects proved very usefull while developing this:
* The official Facebook iOS SDK https://github.com/facebook/facebook-ios-sdk  
* Scott Raymond and Mattt Thompson's well written AFNetworking https://github.com/AFNetworking/AFNetworking
* Jernej Strasner's JSFacebook https://github.com/jernejstrasner/JSFacebook



