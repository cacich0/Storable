// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Storable",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "Storable",
            targets: ["Storable"]),
    ],
    targets: [
        .target(
            name: "Storable"
        )
    ]
)
