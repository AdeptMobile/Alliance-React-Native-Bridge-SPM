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
            url: "https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.0.0/AllianceReactNativeBridge.xcframework.zip",
            checksum: "1bb649d049ee5ee60b383a69f304518f2bcbfb6629bb4ad0d5d9db92e96bc442"
        ),
         .binaryTarget(
            name: "Hermes",
            url: "https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.0.0/hermes.xcframework.zip",
            checksum: "b0e8d9c39b0c95aa26d0e74b474d1ed0bf5e4cf24f2eabbc2feec2bbab989f1f"
        )
    ]
)
