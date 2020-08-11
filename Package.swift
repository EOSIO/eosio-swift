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
            targets: ["libtom", "EosioSwiftEcc"]),
    ],
    dependencies: [
        .package(name: "EosioSwift", url: "https://github.com/EOSIO/eosio-swift", .branch("spm-support")),
        .package(url: "https://github.com/realm/SwiftLint", from: "0.39.1")
    ],
    targets: [
        .target(
            name: "libtom",
            dependencies: [],
            path: "Sources/libtom",
            cSettings: [
                .define("MP_NO_DEV_URANDOM"),
                .define("LTM_DESC"),
                .define("LTC_SOURCE"),
                .define("LTC_NO_TEST"),
                .headerSearchPath("libtomcrypt/headers"),
                .headerSearchPath("libtommath")
            ]
        ),
        .target(
            name: "EosioSwiftEcc",
            dependencies: ["libtom", "EosioSwift"],
            path: "Sources/EosioSwiftEcc"
        ),
        .testTarget(
            name: "EosioSwiftEccTests",
            dependencies: ["EosioSwiftEcc"]),
    ]
)
