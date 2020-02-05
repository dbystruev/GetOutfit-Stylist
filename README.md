# GetOutfit Stylist

GetOutfit.app for Stylists.

![Screenshot](https://github.com/dbystruev/GetOutfit-Stylist/blob/master/assets/screenshots/screenshot.png?raw=true)

## Getting Started

```bash
# Create project directory
mkdir getoutfit_stylist && cd getoutfit_stylist

# Clone the code
git clone https://github.com/dbystruev/GetOutfit-Stylist.git .

# Copy Google Firebase credentials
cp ~/Downloads/GoogleService-Info.plist ios/Runner/
cp ~/Downloads/google-services.json android/app/

# Create Flutter packages
flutter create .
```

### iOS
- [ios/Runner.xcodeproj/project.pbxproj](https://github.com/dbystruev/GetOutfit-Stylist/blob/master/ios/Runner.xcodeproj/project.pbxproj):
  - change PRODUCT_BUNDLE_IDENTIFIER (3 times) to your *iOS Bundle ID* from Firebase, or
  - change project's *Bundle Identifier* in Xcode to your *iOS Bundle ID* from Firebase

- [ios/Runner/Info.plist](https://github.com/dbystruev/GetOutfit-Stylist/blob/master/ios/Runner/Info.plist):
  - replace *CFBundleURLSchemes* string value with REVERSED_CLIENT_ID string value from ***ios/Runner/GoogleService-Info.plist***, or
  - edit *URL Types > Item 0 > URL Schemes > Item 0* in ***Info.plist*** with Xcode

### Android
- [android/app/build.gradle](https://github.com/dbystruev/GetOutfit-Stylist/blob/master/android/app/build.gradle):
  - change android { defaultConfig { applicationId }} to your *Android package name* from Firebase
  
### Build Errors
  #### 1. Firebase Error
  ```bash
  Configuring the default Firebase app...
  *** First throw call stack:
  ```
  
  #### Firebase Error Solution
  1. Remove `ios/Runner/GoogleService-Info.plist`
  2. Launch Xcode: `cd ios && open Runner.xcworkspace`
  3. Re-add `GoogleService-Info.plist` next to `Info.plist` through Xcode
  
  #### 2. xattr Error
  ```bash
  build/ios/Debug-iphonesimulator/Runner.app: resource fork, Finder information, or similar detritus not allowed
  Command CodeSign failed with a nonzero exit code
  ```
  
  #### xattr Error Solution
  `xattr -cr build/ios/Debug-iphonesimulator/Runner.app`
  
  #### 3. Other iOS Errors
  Try [guides.codepath.com/ios/Fixing-Xcode](https://guides.codepath.com/ios/Fixing-Xcode)

### Run project
```bash
flutter run
```

## Acknowledgements
[Reed Barger](https://github.com/reedbarger) for [*Build a Social Network with Flutter and Firebase*](https://www.packtpub.com/web-development/build-a-social-network-with-flutter-and-firebase-video)

User search icon designed by [Icongeek26](https://www.flaticon.com/authors/icongeek26) from [Flaticon](https://www.flaticon.com)
