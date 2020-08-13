// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EosioSwiftAbieosSerializationProvider",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "EosioSwiftAbieosSerializationProvider",
            targets: ["Abieos", "EosioSwiftAbieosSerializationProvider"]
        ),
    ],
    dependencies: [
        .package(name: "EosioSwift", url: "https://github.com/EOSIO/eosio-swift", .branch("spm-support")),
        .package(url: "https://github.com/realm/SwiftLint", from: "0.39.1")
    ],
    targets: [
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
                "LICENSE.txt"
            ],
            cSettings: [
                // Probably want to remove this later when we get support for gnu++17 in
                // cxxLanguageSettings and can ditch unsafeFlags.
                .unsafeFlags(["-Wno-everything"])
            ],
            cxxSettings: [
                // Right now the cxxLanguageSettings don't support specifying c++17 or gnu++17.
                // Sadly it isn't planned to land in 5.3 either.  So for now the only option is
                // unsafeFlags.  While we are at it, might as well supress the warnings from the
                // c/c++ code we don't need to see.
                .unsafeFlags(["-std=gnu++17", "-Wno-everything"])
            ]
        ),
        .target(
            name: "EosioSwiftAbieosSerializationProvider",
            dependencies: ["Abieos", "EosioSwift"],
            path: "Sources/EosioSwiftAbieosSerializationProvider",
            resources: [
                .copy("abi.abi.json"),
                .copy("eosio.assert.abi.json"),
                .copy("transaction.abi.json")
            ]
        ),
        .testTarget(
            name: "EosioSwiftAbieosSerializationProviderTests",
            dependencies: ["EosioSwiftAbieosSerializationProvider"]),
    ]
)
