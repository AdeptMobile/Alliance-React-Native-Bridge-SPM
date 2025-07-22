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
            targets: ["AllianceReactNativeBridgeWrapper","Hermes"]),
    ],
    targets: [
        .target(
            name: "AllianceReactNativeBridgeWrapper",
            dependencies: [
                .target(name: "AllianceReactNativeBridge")
            ],
            path: "AllianceReactNativeBridgeWrapper"
        ),
        .binaryTarget(
            name: "AllianceReactNativeBridge",
            url: "https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.1.9/AllianceReactNativeBridge.xcframework.zip",
            checksum: "b0bd31867297e5acddd3c1cb630c1cc4f8b6f778ded30790f74bdc6a8a2b4b07"
        ),
         .binaryTarget(
            name: "Hermes",
            url: "https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.1.9/hermes.xcframework.zip",
            checksum: "8ba465fdb278d24906a8de462e8541c838c75354e71854e99e9135f98a12f328"
        )
    ]
)
