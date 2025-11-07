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
            targets: ["AllianceReactNativeBridgeWrapper","Hermes","BlazeSDK"]),
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
            url: "https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.2.2/AllianceReactNativeBridge.xcframework.zip",
            checksum: "c369541dfd520ad71f89a6cfcc7626b5097c3f437539dfce8705f7e0364710c4"
        ),
         .binaryTarget(
            name: "Hermes",
            url: "https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.2.2/hermes.xcframework.zip",
            checksum: "4a3712bfe47162a0bb54895c791aa5ed28f489962d4a1df51039e1857db62bd5"
        ),
        .binaryTarget(
           name: "BlazeSDK",
           url: "https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.2.2/BlazeSDK.xcframework.zip",
           checksum: "93ad03cb4a92e74b4c785b05f45f57cf53bd26fc9671313a79a44bd572a0bc3a"
       )
    ]
)
