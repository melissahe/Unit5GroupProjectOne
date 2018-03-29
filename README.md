# Unit 5 - Homework [Group One]

## Overview
Powered by Foursquare, this app lets you search for venues at different locations. This app can also use your current location to give you a list of venues in the area. If you see any venues you'd like to remember and add tips about, you can create a new collection or save them to a new collection.

## Gifs
|User Allowing Location Access|User Denying Location Access|
|:-------------:|:------------:|
|<img src="https://github.com/NateMRosario/Unit5GroupProjectOne/blob/prod/Images/allow-location-access.gif" width="358" height="626">|<img src="https://github.com/NateMRosario/Unit5GroupProjectOne/blob/prod/Images/search-location.gif" width="358" height="626">|

|Get Venue Info From Map|Get List Of Venues|
|:-------------:|:------------:|
|<img src="https://github.com/NateMRosario/Unit5GroupProjectOne/blob/prod/Images/detail-venue-info-map.gif" width="358" height="626">|<img src="https://github.com/NateMRosario/Unit5GroupProjectOne/blob/prod/Images/venue-list.gif" width="358" height="626">|

|Save Venue To New Collections with Tip|Save Venue to as Existing Collection with Tip|
|:-------------:|:------------:|
|<img src="https://github.com/NateMRosario/Unit5GroupProjectOne/blob/prod/Images/save-venue-new-collection.gif" width="358" height="626">|<img src="https://github.com/NateMRosario/Unit5GroupProjectOne/blob/prod/Images/save-venue-existing-collection.gif" width="358" height="626">|

|Change Names of Collections|
|:-------------:|
|<img src="https://github.com/NateMRosario/Unit5GroupProjectOne/blob/prod/Images/change-collection-name.gif" width="358" height="626">|

|Delete Collections|Delete Venues From Collections|
|:-------------:|:-------------:|
|<img src="https://github.com/NateMRosario/Unit5GroupProjectOne/blob/prod/Images/delete-collections.gif" width="358" height="626">|<img src="https://github.com/NateMRosario/Unit5GroupProjectOne/blob/prod/Images/delete-venues-from-collections.gif" width="358" height="626">|

## Features
- Can search for venues either in a specific location or at current user location
- Can view an image associated with each venue
- Can save venues to collections and add tips about them
- Can create new and delete existing collections
- Can delete venues in existing collections

## Requirements
- iOS 8.0+ / Mac OS X 10.11+ / tvOS 9.0+
- Xcode 9.0+
- Swift 4.0+

## Installation

### CocoaPods
CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:

`$ sudo gem install cocoapods`

### Pods
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [SnapKit](http://snapkit.io/docs/)
- [KingFisher](https://github.com/onevcat/Kingfisher)

### How to Install Pods
To integrate these pods into your Xcode project using CocoaPods, specify it in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Alamofire',
    pod 'SnapKit',
    pod 'KingFisher'
end
```

Then, run the following command in Terminal:

`$ pod install`

## API Endpoints
### FourSquare API
- [FourSquare API Venues Search](https://api.foursquare.com/v2/venues/search)
- [FourSquare API Venue Photo](https://developer.foursquare.com/docs/api/venues/photos)

## Credits (Team M&M!!)
- **Project Manager**: Meseret Gebru - [GitHub](https://github.com/MeseretGebru)
- **Tech Lead**: Nathan Rosario - [GitHub](https://github.com/NateMRosario)
- **UI/UX**: Melissa He - [GitHub](https://github.com/melissahe)
- **QA**: Marlon Rugama - [GitHub](https://github.com/mrugama)

## Extra Stuff lol

### Objetives by Marlon (Objective Without the "C" LOL):
1. Assign responsibilities
2. Create a shared project on GitHub
3. Plan the way of work
4. Assign specific feature to be implemented
5. Test all the features
6. Merge in one branch
7. Submit
