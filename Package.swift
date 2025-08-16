// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HerschelMessages",
    platforms: [.macOS(.v15), .iOS(.v18)],
    products: [
        .library(
            name: "HerschelMessages",
            targets: ["HerschelMessages"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: "HerschelMessages",
            dependencies: [
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ]
        ),
        .testTarget(
            name: "HerschelMessagesTests",
            dependencies: ["HerschelMessages"]
        ),
    ]
)
