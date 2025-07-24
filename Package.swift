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
            url: "https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.1.11/AllianceReactNativeBridge.xcframework.zip",
            checksum: "8cc3d902f0f7d19a24c201ab724401a8a0983aaf1004e53124be400ed5f52e04"
        ),
         .binaryTarget(
            name: "Hermes",
            url: "https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases/download/1.1.11/hermes.xcframework.zip",
            checksum: "194fa1d96ee24f8fe5a1e2e5a564d54110326f718d58829d9b97eab4fc358efc"
        )
    ]
)
