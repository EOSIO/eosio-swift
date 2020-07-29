// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EosioSwiftEcc",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "EosioSwiftEcc",
            targets: ["EosioSwiftEcc_CPP", "EosioSwiftEcc"]),
    ],
    dependencies: [
        .package(name: "EosioSwift", url: "https://github.com/EOSIO/eosio-swift", .branch("spm-support")),
        // Have to use SSH form since the repo is currently private.
        .package(name: "openssl", url: "git@github.com:EOSIO/openssl-xcframework.git", .branch("master")),
        .package(url: "https://github.com/realm/SwiftLint", from: "0.39.1")
    ],
    targets: [
        .target(
            name: "EosioSwiftEcc_CPP",
            dependencies: ["openssl"],
            path: "Sources/CPP"
        ),
        .target(
            name: "EosioSwiftEcc",
            dependencies: ["EosioSwiftEcc_CPP", "EosioSwift"],
            path: "Sources/Swift"
        ),
        .testTarget(
            name: "EosioSwiftEccTests",
            dependencies: ["EosioSwiftEcc"]),
    ]
)
