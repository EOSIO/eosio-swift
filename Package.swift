// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EosioSwift",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "EosioSwift",
            targets: ["EosioSwift"])
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.0.0"),
        .package(url: "https://github.com/mxcl/PromiseKit", from: "6.8.0"),
        .package(name: "PMKFoundation", url: "https://github.com/PromiseKit/Foundation", from: "3.0.0"),
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs", from: "9.0.0"),
        .package(url: "https://github.com/realm/SwiftLint", from: "0.39.1")
    ],
    targets: [
        .target(
            name: "EosioSwift",
            dependencies: [
                "PromiseKit",
                "PMKFoundation",
                "BigInt"
            ]),
        .testTarget(
            name: "EosioSwiftTests",
            dependencies: [
                "EosioSwift",
                .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs")
            ])
    ]
)
