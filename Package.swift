// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "EosioSwift",
    platforms: [
       .macOS(.v10_13), .iOS(.v12),
    ],
    products: [
        .library(
            name: "EosioSwift",
            targets: ["EosioSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt", from: "5.0.0"),
        .package(url: "https://github.com/mxcl/PromiseKit", from: "6.8.0"),
        .package(url: "https://github.com/PromiseKit/Foundation.git", from: "3.0.0"),
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", .branch("feature/spm-support")),
    ],
    targets: [
        .target(
            name: "EosioSwift",
            dependencies: ["BigInt", "PromiseKit", "PMKFoundation"],
            path: "EosioSwift"),
        .testTarget(
            name: "EosioSwiftTests",
            dependencies: ["EosioSwift", "OHHTTPStubsSwift"],
            path: "EosioSwiftTests"),
    ]
)
