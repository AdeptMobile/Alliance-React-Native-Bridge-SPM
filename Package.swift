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
            url: "https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.1.0/AllianceReactNativeBridge.xcframework.zip",
            checksum: "9df791690499603555afc3d1763d5974962652904fd024be4769a7c7a9ec9a7a"
        ),
         .binaryTarget(
            name: "Hermes",
            url: "https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.1.0/hermes.xcframework.zip",
            checksum: "cb99c771310d9cc03e7eeb1648b0282c3e993612905b5b32cf859a6ed7a68db8"
        )
    ]
)
