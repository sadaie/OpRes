// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "OpRes",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v5)
    ],
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
    ],
    swiftLanguageVersions: [ .v5 ]
)
