// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "OpRes",
    products: [
        .library(
            name: "OpRes",
            targets: ["OpRes"]),
    ],
    targets: [
        .target(
            name: "OpRes",
            dependencies: []),
        .testTarget(
            name: "OpResTests",
            dependencies: ["OpRes"]),
    ]
)
