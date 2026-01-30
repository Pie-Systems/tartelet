// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CircleCI",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "CircleCIData", targets: ["CircleCIData"]),
        .library(name: "CircleCIDomain", targets: ["CircleCIDomain"]),
    ],
    dependencies: [
        .package(path: "../Keychain"),
    ],
    targets: [
        .target(name: "CircleCIData", dependencies: ["CircleCIDomain", "Keychain"]),
        .target(name: "CircleCIDomain"),
    ]
)
