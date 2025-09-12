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
            targets: ["AllianceReactNativeBridgeWrapper","Hermes","Blaze"]),
    ],
    targets: [
        .target(
            name: "AllianceReactNativeBridgeWrapper",
            dependencies: [
                .target(name: "AllianceReactNativeBridge"),
                "BlazeResources"
            ],
            path: "AllianceReactNativeBridgeWrapper"
        ),
        .binaryTarget(
            name: "AllianceReactNativeBridge",
            url: "https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.1.17/AllianceReactNativeBridge.xcframework.zip",
            checksum: "e4cfb7b11f2a7e9c82f4aa39c1f356583952c09ffbe58f7044e86eb56e23ef4d"
        ),
         .binaryTarget(
            name: "Hermes",
            url: "https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.1.17/hermes.xcframework.zip",
            checksum: "b95292f9b5f801a976cfb30dc227b2694803239bacf88f695b80aaadf1f4bfb5"
        ),
        .binaryTarget(
           name: "Blaze",
           url: "https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.1.17/BlazeSDK.xcframework.zip",
           checksum: "124258a9ab4252a9ec484920697eba4f8d7c7e4798b9794a65dbcfaa24450977"
       ),
       .target(
           name: "BlazeResources",
           resources: [
               .copy("Resources/blaze-rtn-sdk-bundle.bundle")
           ],
           path: "Resources"
       )
    ]
)
