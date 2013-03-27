Pod::Spec.new do |s|
  
  s.name         = "BSFacebookImagePicker"
  s.version      = "1.0.0"
  s.summary      = "A lightweight, drop-in replacement for UIImagePickerController to allow users to choose photos from Facebook. "
  s.homepage     = "https://github.com/bradsmithinc/BSFacebookImagePicker"
  s.license      = 'Apache (2.0)'
  s.author       = { "Brad Smith" => "bradsmithinc@gmail.com" }
  s.source       = { :git => "https://github.com/bradsmithinc/BSFacebookImagePicker.git", :tag => "1.0.0" }
  s.platform     = :ios, '5.0'
  s.source_files = 'BSFacebookImagePicker', 'BSFacebookImagePicker/**/*.{h,m}'
  s.resources    = "BSFacebookImagePicker/Public/BSFBAlbumPicker.bundle"
  s.frameworks   = 'CoreText', 'MobileCoreServices', 'SystemConfiguration', 'UIKit', 'Foundation', 'CoreGraphics'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 1.2.0'
  s.prefix_header_contents = <<-EOS
#import <Availability.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <SystemConfiguration/SystemConfiguration.h>
#define Localized(string) \\
NSLocalizedStringFromTableInBundle(string, @"FBAlbumPicker", [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource:@"BSFBAlbumPicker" ofType:@"bundle"]], @"")
EOS

end
