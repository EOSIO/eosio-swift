// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EosioSwift",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "EosioSwift",
            targets: ["EosioSwift"]
        ),
        .library(
            name: "EosioSwiftAbieosSerializationProvider",
            targets: ["Abieos", "EosioSwiftAbieosSerializationProvider"]
        ),
        .library(
            name: "EosioSwiftEcc",
            targets: ["libtom", "EosioSwiftEcc"]
        ),
        .library(
            name: "EosioSwiftSoftkeySignatureProvider",
            targets: ["EosioSwiftSoftkeySignatureProvider"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.0.0"),
        .package(url: "https://github.com/mxcl/PromiseKit", from: "6.8.0"),
        .package(name: "PMKFoundation", url: "https://github.com/PromiseKit/Foundation", from: "3.0.0"),
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs", from: "9.0.0"),
        .package(url: "https://github.com/realm/SwiftLint", from: "0.39.1"),
        .package(url: "https://github.com/ddddxxx/Semver", from: "0.2.1"),
    ],
    targets: [
        .target(
            name: "EosioSwift",
            dependencies: [
                "PromiseKit",
                "PMKFoundation",
                "BigInt",
                "Semver"
            ],
            path: "Sources/EosioSwift"
        ),
        .target(
            name: "Abieos",
            dependencies: [],
            path: "Sources/Abieos",
            /*
                SPM 5.3 requires everything in the Sources directory to be a known type, declared as a
                resource or excluded.  Unfortunately 5.3 does not recognize hpp headers as valid source
                files.  The compiler still finds them as they are included by cpp files though.  Temp
                work around is to exclude them.  See this thread for more information:
                https://forums.swift.org/t/spm-packagedescription-5-3-does-not-recognize-hpp-headers-as-such-and-asks-for-them-to-be-excluded-or-used-as-resources/38466
            */
            exclude: [
                "abieos.hpp",
                "abieos_exception.hpp",
                "abieos_numeric.hpp",
                "abieos_ripemd160.hpp",
                "eosio/abi.hpp",
                "eosio/asset.hpp",
                "eosio/bytes.hpp",
                "eosio/chain_conversions.hpp",
                "eosio/chain_types.hpp",
                "eosio/check.hpp",
                "eosio/convert.hpp",
                "eosio/crypto.hpp",
                "eosio/fixed_bytes.hpp",
                "eosio/float.hpp",
                "eosio/for_each_field.hpp",
                "eosio/from_bin.hpp",
                "eosio/from_json.hpp",
                "eosio/from_string.hpp",
                "eosio/murmur.hpp",
                "eosio/name.hpp",
                "eosio/opaque.hpp",
                "eosio/operators.hpp",
                "eosio/reflection.hpp",
                "eosio/ship_protocol.hpp",
                "eosio/stream.hpp",
                "eosio/symbol.hpp",
                "eosio/time.hpp",
                "eosio/to_bin.hpp",
                "eosio/to_json.hpp",
                "eosio/to_key.hpp",
                "eosio/types.hpp",
                "eosio/varint.hpp",
                "eosio/fpconv.license",
                "fuzzer.hpp",
                "LICENSE.txt"
            ]
        ),
        .target(
            name: "EosioSwiftAbieosSerializationProvider",
            dependencies: ["Abieos", "EosioSwift"],
            path: "Sources/EosioSwiftAbieosSerializationProvider",
            resources: [
                .copy("eosio.assert.abi.json"),
                .copy("transaction.abi.json")
            ]
        ),
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
        .target(
            name: "EosioSwiftSoftkeySignatureProvider",
            dependencies: ["EosioSwift", "EosioSwiftEcc"],
            path: "Sources/EosioSwiftSoftkeySignatureProvider"
        ),
        .testTarget(
            name: "EosioSwiftTests",
            dependencies: [
                "EosioSwift",
                .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs")
            ],
            path: "Tests/EosioSwiftTests"
        ),
        .testTarget(
            name: "EosioSwiftAbieosSerializationProviderTests",
            dependencies: ["EosioSwiftAbieosSerializationProvider"],
            path: "Tests/EosioSwiftAbieosSerializationProviderTests"
        ),
        .testTarget(
            name: "EosioSwiftEccTests",
            dependencies: ["EosioSwiftEcc"],
            path: "Tests/EosioSwiftEccTests"
        ),
        .testTarget(
            name: "EosioSwiftSoftkeySignatureProviderTests",
            dependencies: ["EosioSwiftSoftkeySignatureProvider"],
            path: "Tests/EosioSwiftSoftkeySignatureProviderTests"
        ),
        // Temporary test targets for trying out transactions to local chain
        .testTarget(
            name: "EosioSwiftIntegrationTests",
            dependencies: ["EosioSwift", "EosioSwiftSoftkeySignatureProvider", "EosioSwiftAbieosSerializationProvider"],
            path: "Tests/EosioSwiftIntegrationTests"
        ),
    ],
    cxxLanguageStandard: .cxx1z
)
