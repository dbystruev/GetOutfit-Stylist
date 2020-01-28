# GetOutfit Stylist

GetOutfit.app for Stylists.

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
  - change project's *Bundle Identifier* in Xcode your *iOS Bundle ID* from Firebase

- [ios/Runner/Info.plist](https://github.com/dbystruev/GetOutfit-Stylist/blob/master/ios/Runner/Info.plist):
  - replace *CFBundleURLSchemes* string value with REVERSED_CLIENT_ID string value from ***ios/Runner/GoogleService-Info.plist***, or
  - edit *URL Types > Item 0 > URL Schemes > Item 0* in ***Info.plist*** with Xcode

### Android
- [android/app/build.gradle](https://github.com/dbystruev/GetOutfit-Stylist/blob/master/android/app/build.gradle):
  - change android { defaultConfig { applicationId }} to your *Android package name* from Firebase

### Run project
```bash
flutter run
```
