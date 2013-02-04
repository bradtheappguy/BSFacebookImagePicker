# FBAlbumPicker for iOS

FBAlbumPicker is a drop-in replacement for UIImagePickerController that allows Users to choose photos from Facebook instead of the camera library.

FBAlbumPicker is lightweight and can be used with or without using the Facebook-iOS-SDK.

## Features

  Authentication using iOS single signup (iOS 5+), or Fast App Switching to the Facebook App
  Fallback Web-Based Authentication
  Authentication can be bypassed if you allready have a Facebook Access token 
  Allows the user to choose photos from:
    - Their own albums and profile photos
    - Ones they have been tagged in
    - Thier friends albums and profile photos
    - Ones thier frineds have been tagged in
  Uses an idential API to UIImagePickerController, so it can be used as a direct drop-in

## Requirements

  FBAlbumPicker is build using Modern ARC based Objective-C
  AFNetworking is used for the networking
  Every attempt has been made to ensure compatibility with older versions of iOS



