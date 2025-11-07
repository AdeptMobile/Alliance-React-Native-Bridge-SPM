Steps to create a new release:

1. Make sure you can build the RN Source Project

2. Create the archives on the terminal command line. We will need 2 of them.
   One for the device and one for sim. Make sure you are on the directory containing the xcworkspace.
   Remove the files in the archives directory then run these commands.

   - For Device Archive:

   xcodebuild archive -workspace AllianceReactNativeBridge.xcworkspace -scheme AllianceReactNativeBridge -sdk iphoneos -archivePath "./archives/ios_devices.xcarchive" BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO

   - For Sim Archive

   xcodebuild archive -workspace AllianceReactNativeBridge.xcworkspace -scheme AllianceReactNativeBridge -sdk iphonesimulator -archivePath "./archives/ios_simulators.xcarchive" BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO

   Then remove the xcframework in the build directory and then run the command below to create the XCFramework for the bridge.

   xcodebuild -create-xcframework -framework ./archives/ios_devices.xcarchive/Products/Library/Frameworks/AllianceReactNativeBridge.framework -framework ./archives/ios_simulators.xcarchive/Products/Library/Frameworks/AllianceReactNativeBridge.framework -output build/AllianceReactNativeBridge.xcframework

   If anything in the source project changed you will need to create a new checksum hash. First compress into a zip file and run this command on it.

   swift package compute-checksum AllianceReactNativeBridge.xcframework.zip

   We will use this checksum later

3. Prepare the binary frameworks. Ensure all three required frameworks are ready:
   - AllianceReactNativeBridge.xcframework.zip
   - hermes.xcframework.zip
   - BlazeSDK.xcframework.zip

   If Hermes changed at all then we will need to regrab it. If not then continue using the same as we have been using, no change in checksum. If hermes did
   change then we will need to grab it from the pods directory. It is located in the

   Pods/hermes-engine/destroot/Library/Frameworks/universal directory

   You will also need to go into the info.plist file for Hermes and remove all the DebugSymbolsPath line items in each of the items in the Available Libraries.
   This causes an error if it is not removed in compilation.

   If hermes did change you will need to zip it and run a checksum on it

   swift package compute-checksum hermes.xcframework.zip

4. Generate a release

   Option A: Automated script (recommended)

   Run the create_release.sh script from this directory. It will:
   - Display current versions in Package.swift
   - Prompt for new version
   - Calculate checksums for all three frameworks from ../alliance-react-native-bridge/ios/dist
   - Update Package.swift with new version and checksums
   - Create git tag
   - Create draft release and upload zip files (requires GitHub CLI)

   ./create_release.sh

   Option B: Manual process

   a. Modify the package file:

   Change the path for each xcframework to point to the next tag/release version

   example: if the next version is 1.0.1 which you will create next then change the path from

     url: "<https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.0.0/AllianceReactNativeBridge.xcframework.zip>",

   to

     url: "<https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.0.1/AllianceReactNativeBridge.xcframework.zip>",

   This must be done for all three frameworks: AllianceReactNativeBridge, Hermes, and BlazeSDK.

   Likewise if the checksum changed, change the checksum value for all three as well.

   You can now save the package and move on to creating the new release.

   b. Hit the tags link or use this url > <https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/tags>

      Switch to Releases and tap 'Draft a new release'

      Select choose a tag and create a new tag for the release.

      Type in a title and any notes you want to add.

      Drop in all three binary zip files: AllianceReactNativeBridge.xcframework.zip, hermes.xcframework.zip, and BlazeSDK.xcframework.zip.

      Publish and then you are done :)
