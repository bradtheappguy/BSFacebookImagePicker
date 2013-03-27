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

@protocol BSFacebookImagePickerControllerDelegate;


/*!
 @class      BSFacebookImagePickerController
 @abstract   The BSFacebookImagePickerController class provides an interface for selecting photos from Facebook.
 @discussion The BSFacebookImagePickerController class manages all user interaction, including authenticaion.  The client 
             needs to set a Facebook App ID and Facebook App Secret.  These may be obtained from http://facebook.com/developers.  
             The provided delegate will be informed of the chosen photo, any possible failure, or the user's intent to cancel
             the operation.
*/
@interface BSFacebookImagePickerController : UINavigationController

/*!
 @property   facebookAppID
 @abstract   The Facebook App ID of the Facebook App used.
 */
@property (nonatomic) NSString *facebookAppID;

/*!
 @property   facebookAppSecret
 @abstract   The Facebook App Secret of the Facebook App used.
 */
@property (nonatomic) NSString *facebookAppSecret;

/*!
 @property   delegate
 @abstract   The delegate to be assigned to notify the client when a photo has been chosen, an error has occured, or
             the user has canceled.
 */
@property(nonatomic, assign) id <BSFacebookImagePickerControllerDelegate, UINavigationControllerDelegate> delegate;


/*!
 @method     handleCallbackURL:
 @abstract   Authenticates user to Facebook by handling a Facebook CAllback URL that luanched the host app.
 @discussion When using the Facebook Single Signon authentication method, the client should pass in the URL
             that launched the application from the Application Delegate, in order to allow BSFacebookImagePickerController 
             to complate the authentication process.
 */
+ (void)handleCallbackURL:(NSURL *)url;

/*!
 @method     logout
 @abstract   Logs the user out of Facebook.
 @discussion This method logs the user out of Facebook.
 */
+ (void)logout;

@end


/*!
 @protocol    MFMailComposeViewControllerDelegate
 @abstract    Protocol for delegate callbacks to BSFacebookImagePickerController instances.
 @discussion  This protocol must be implemented for delegates of BSFacebookImagePickerController instances.  It will
 be called at various times when the user has chosen a photo, canceled the operation or when an error has occured.
 */
@protocol BSFacebookImagePickerControllerDelegate <UIImagePickerControllerDelegate>

/*!
 @method     imagePickerController:didFinishPickingMediaWithInfo:
 @abstract   Delegate callback which is called upon user chosing a photo from Facebook.
 @discussion This delegate callback will be called when the user chooses a photo.  Upon this call, the client
 should remove the view associated with the controller, typically by dismissing modally.
 @param      controller   The BSFacebookImagePickerController instance which is returning the result.
 @param      info         NSDictionary containing the result
 */
- (void)imagePickerController:(BSFacebookImagePickerController *)controller didFinishPickingMediaWithInfo:(NSDictionary *)info;

/*!
 @method     mailComposeController:didFinishWithResult:error:
 @abstract   Delegate callback which is called upon user's canaclation of the photo picking process.
 @discussion This delegate callback will be called when the user cancels the photo picking process. Upon this call, the client
 should remove the view associated with the controller, typically by dismissing modally.
 @param      controller   The BSFacebookImagePickerController instance which is returning the result.
 */
- (void)imagePickerControllerDidCancel:(BSFacebookImagePickerController *)picker;
@end