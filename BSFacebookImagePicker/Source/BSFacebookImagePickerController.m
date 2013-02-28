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

#import "BSFacebookImagePickerController.h"

#import "BSFBRootViewController.h"

@interface BSFacebookImagePickerController (/* private */) {
  BSFBRootViewController *_albumPicker;
}

@end

@implementation BSFacebookImagePickerController

- (id)init {
  _albumPicker = [[BSFBRootViewController alloc] init];
  if (self = [super initWithRootViewController:_albumPicker]) {
    
  }
  return self;
}

- (void) setDelegate:(id)delegate {
  [super setDelegate:delegate];
  _albumPicker.delegate = delegate;
}

@end
