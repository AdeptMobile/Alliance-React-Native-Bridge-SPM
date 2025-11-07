// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AllianceReactNativeBridge",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AllianceReactNativeBridge",
            targets: ["AllianceReactNativeBridgeWrapper","Hermes","BlazeSDK","BlazeGAM"]),
    ],
    targets: [
        .target(
            name: "AllianceReactNativeBridgeWrapper",
            dependencies: [
                .target(name: "AllianceReactNativeBridge"),
            ],
            path: "AllianceReactNativeBridgeWrapper"
        ),
        .binaryTarget(
            name: "AllianceReactNativeBridge",
            url: "https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.2.0/AllianceReactNativeBridge.xcframework.zip",
            checksum: "2a96ae0dd9c25bcd884dd20376e3fdd44697370f865b8964634dbe4a3b6f4d5e"
        ),
         .binaryTarget(
            name: "Hermes",
            url: "https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.2.0/hermes.xcframework.zip",
            checksum: "de951bd55e7b636b95b019acdf19e464e362a7e97d5a94c4d0777089ff59c5c2"
        ),
        .binaryTarget(
           name: "BlazeSDK",
           url: "https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.2.0/BlazeSDK.xcframework.zip",
           checksum: "3c6ea9b6ceea8ab6dac7a55c05bb8bbddad2bbac3bbfae475f2d2b7fe806631a"
       )
    ]
)
