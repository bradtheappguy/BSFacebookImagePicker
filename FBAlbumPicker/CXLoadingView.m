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

#import "CXLoadingView.h"

static NSUInteger kSpinnerPadding = 5;

@interface CXLoadingView (/* private */) {
  UILabel *_label;
  UIActivityIndicatorView *_spinner;
}
@end


@implementation CXLoadingView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_spinner startAnimating];
		
    _label = [[UILabel alloc] initWithFrame:self.bounds];
		_label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
		_label.textColor = _spinner.color;
    _label.text = NSLocalizedString(@"LOADING", @"");;
		[_label sizeToFit];
    
    [self setBackgroundColor:[UIColor whiteColor]];
		[self addSubview:_label];
		[self addSubview:_spinner];
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	}
	return self;
}


- (void)layoutSubviews {
  
  //Allign Vertically
	_label.center = self.center;
	_spinner.center = self.center;
  
	CGRect labelFrame = _label.frame;
	CGRect spinnerFrame = _spinner.frame;
  
  //Calculate Width
	CGFloat totalWidth = spinnerFrame.size.width + kSpinnerPadding + labelFrame.size.width;
	
  //Align Horizontally
  spinnerFrame.origin.x = self.bounds.origin.x + (self.bounds.size.width-totalWidth)/2;
	labelFrame.origin.x = spinnerFrame.origin.x + spinnerFrame.size.width + kSpinnerPadding;
	_label.frame = labelFrame;
	_spinner.frame = spinnerFrame;
}

@end
