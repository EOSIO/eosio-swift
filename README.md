![Swift Logo](https://raw.githubusercontent.com/EOSIO/eosio-swift/master/img/swift-logo.png)
# EOSIO SDK for Swift

[![Software License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/EOSIO/eosio-swift/blob/master/LICENSE)
[![Swift 5.2](https://img.shields.io/badge/Language-Swift_5.2-orange.svg)](https://swift.org)
![](https://img.shields.io/badge/Deployment%20Target-iOS%2012-blue.svg)

EOSIO SDK for Swift is a set of components for integrating with EOSIO-based blockchains. It contains:

* EosioSwift, the core component for communicating and transacting with EOSIO-based blockchains using the [EOSIO RPC API](https://developers.eos.io/manuals/eos/latest/nodeos/plugins/chain_api_plugin/api-reference/index).
* ABIEOS Serialization Provider, a pluggable serialization provider for EosioSwift. Serialization providers are responsible for ABI-driven transaction and action serialization and deserialization between JSON and binary data representations. This particular serialization provider wraps [ABIEOS](https://github.com/EOSIO/abieos), a C/C++ library that facilitates this conversion.
* ECC, a component for working with public and private keys, cryptographic signatures, encryption/decryption, etc.
* Softkey Signature Provider, an example pluggable signature provider for EosioSwift. It allows for signing transactions using in-memory K1 keys.

To date, EOSIO SDK for Swift has only been tested on iOS. The goal, however, is for the core library to run anywhere Swift runs, adding other targets (macOS, watchOS, tvOS) as the library matures.

*All product and company names are trademarks™ or registered® trademarks of their respective holders. Use of them does not imply any affiliation with or endorsement by them.*

## Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
    - [Cocoapods](#cocoapods)
- [Basic Usage](#basic-usage)
    - [Working With Transactions](#working-with-transactions)
    - [The Transaction Factory](#the-transaction-factory)
    - [Usage With PromiseKit](#usage-with-promisekit)
    - [ABIEOS Serialization Provider Usage](#abieos-serialization-provider-usage)
    - [ECC Usage](#ecc-usage)
    - [Softkey Signature Provider Usage](#softkey-signature-provider-usage)
    - [Key Management and Signing Utilities](#key-management-and-signing-utilities)
- [Other Examples](#other-examples)
- [Code Documentation](#code-documentation)
- [Provider Protocol Architecture](#provider-protocol-architecture)
- [RPC: Using the Default RPC Provider](#rpc-using-the-default-rpc-provider)
- [Want to Help?](#want-to-help)
- [License & Legal](#license)

## Prerequisites

* Xcode 11 or higher
* CocoaPods 1.9.3 or higher OR
* Swift Package Manager (SPM) 5.2 or higher
* For iOS, iOS 12+

## Installation

### Swift Package Manager

Depending on the component(s) you wish to use, the appropriate dependencies will also be installed for you. For example, if you wished to use `EosioSwiftAbieosSerializationProvider`, then the main `EosioSwift` component would also be installed.

If you wish to use all of the components, add the `EosioSwift`, `EosioSwiftAbieosSerializationProvider`, `EosioSwiftEcc` and `EosioSwiftSoftkeySignatureProvider` products from `https://github.com/EOSIO/eosio-swift` to your application dependencies.

Or to include it into a library, add the following to your `Package.swift` definition:

```swift
// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyName",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "MyLibrary",
            targets: ["MyLibrary"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "EosioSwift", url: "https://github.com/EOSIO/eosio-swift", from: "1.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "MyLibrary",
            dependencies: [
                .product(name: "EosioSwift", package: "EosioSwift"),
                .product(name: "EosioSwiftAbieosSerializationProvider", package: "EosioSwift"),
                .product(name: "EosioSwiftEcc", package: "EosioSwift"),
                .product(name: "EosioSwiftSoftkeySignatureProvider", package: "EosioSwift"),
        ]),
        .testTarget(
            name: "MyLibraryTests",
            dependencies: ["MyLibrary"]),
    ]
)
```

Technically, in the full definition, not all of the components would have to be specified as dependencies since `EosioSwiftSoftkeySignatureProvider` depends on `EosioSwiftEcc` and `EosioSwift` and would include them automatically, but all products are listed here for illustration purposes.

If you only want some of the components, you can remove the unwanted dependencies in the product name definition for your target.

### CocoaPods

All of the EOSIO SDK for Swift components are separated as subspecs in Cocoapods. If you install the entire pod from EOSIO SDK for Swift, you will get the main EosioSwift API, ABIEOS Serialization Provider, ECC and Softkey Signature Provider. To do this, add the following to your [Podfile](https://guides.cocoapods.org/syntax/podfile.html):

```ruby
use_frameworks!

target "Your Target" do
  pod "EosioSwift", "~> 1.0.0"
end
```

Then run `pod install`. And you're all set for the [Basic Usage](#basic-usage) example!

If you wish to use only some of the components, add the subspecs you want out of the list below to your [Podfile](https://guides.cocoapods.org/syntax/podfile.html):

```ruby
use_frameworks!

target "Your Target" do
  pod "EosioSwift/Core", "~> 1.0.0" # The main Eosio Swift API
  pod "EosioSwift/AbieosSerializationProvider", "~> 1.0.0" # serialization provider
  pod "EosioSwift/Ecc", "~> 1.0.0" # ECC, mostly a dependency, normally do not need to specify
  pod "EosioSwift/SoftkeySignatureProvider", "~> 1.0.0" # experimental signature provider for development only

end
```

Then run `pod install`. And you're all set for the [Basic Usage](#basic-usage) example!

## Basic Usage

### Working With Transactions

Transactions are instantiated as an [`EosioTransaction`](EosioSwift/EosioTransaction/EosioTransaction.swift) and must then be configured with a number of providers prior to use. (See [Provider Protocol Architecture](#provider-protocol-architecture) below for more information about providers.)

```swift
import EosioSwift
import EosioSwiftAbieosSerializationProvider
import EosioSwiftSoftkeySignatureProvider
```

Then, inside a `do...catch` or throwing function, do the following:

```swift
let transaction = EosioTransaction()
transaction.rpcProvider = EosioRpcProvider(endpoint: URL(string: "http://localhost:8888")!)
transaction.serializationProvider = EosioAbieosSerializationProvider()
transaction.signatureProvider = try EosioSoftkeySignatureProvider(privateKeys: ["yourPrivateKey"])

/// Actions can now be added to the transaction, which can, in turn, be signed and broadcast:

let action = try EosioTransaction.Action(
    account: EosioName("eosio.token"),
    name: EosioName("transfer"),
    authorization: [EosioTransaction.Action.Authorization(
        actor: EosioName("useraaaaaaaa"),
        permission: EosioName("active"))
    ],
    data: Transfer(
        from: EosioName("useraaaaaaaa"),
        to: EosioName("useraaaaaaab"),
        quantity: "42.0000 SYS",
        memo: "")
)

transaction.add(action: action)

transaction.signAndBroadcast { (result) in
    switch result {
    case .failure (let error):
        // Handle error.
    case .success:
        // Handle success.
    }
}
```

Starting with version 1.0, it is possible to configure transactions to use the last irreversible block rather than a block `blocksBehind` the current head block of the chain. The number of `blocksBehind` or the `expireSeconds` can also be adjusted. This is done by modifying the `Transaction.Config` before calling `prepare`, `sign` or `signAndBroadcast`. When `useLastIrreversible` is true, then `blocksBehind` is ignored. `Transaction.Config` defaults `useLastIrreversible` to `true` to help minimize micro-forking of transactions under certain conditions.

```swift
let transaction = EosioTransaction()
transaction.rpcProvider = EosioRpcProvider(endpoint: URL(string: "http://localhost:8888")!)
transaction.serializationProvider = EosioAbieosSerializationProvider()
transaction.signatureProvider = try EosioSoftkeySignatureProvider(privateKeys: ["yourPrivateKey"])

// Modify the transaction configuration.
transaction.config.useLastIrreversible = false

// Modify expireSeconds if desired.
transaction.config.expireSeconds = 60 * 8

// Add actions, sign, broadcast etc. as shown above...

```

### The Transaction Factory

Alternatively, to avoid having to set the providers on every transaction, you can use the [`EosioTransactionFactory`](Sources/EosioSwift/EosioTransaction/EosioTransactionFactory.swift) convenience class, as follows:

```swift
let rpcProvider = EosioRpcProvider(endpoint: URL(string: "http://localhost:8888")!)
let signatureProvider = try EosioSoftkeySignatureProvider(privateKeys: ["yourPrivateKey"])
let serializationProvider = EosioAbieosSerializationProvider()

let myTestnet = EosioTransactionFactory(rpcProvider: rpcProvider, signatureProvider: signatureProvider, serializationProvider: serializationProvider)

let transaction = myTestnet.newTransaction()
// add actions, sign and broadcast!

let anotherTransaction = myTestnet.newTransaction()
// add actions, sign and broadcast!
...
```

### Usage With PromiseKit

Most `EosioTransaction` and RPC endpoint methods will return Promises if you ask them. Simply call the method with `.promise` as the first parameter and drop the callback. For example:

```swift
firstly {
    transaction.signAndBroadcast(.promise)
}.done { _ in
    // Handle success.
}.catch { error in
    // Handle error.
}
```

### ABIEOS Serialization Provider Usage

If you wish to use ABIEOS Serialization Provider directly, its public methods can be called like this:

```swift
let abieos: EosioAbieosSerializationProvider? = EosioAbieosSerializationProvider()
let hex = "1686755CA99DE8E73E1200" // some binary data
let json = "{"name": "John"}" // some JSON

let jsonToBinaryTransaction = try? abieos?.serializeTransaction(json: json)
let binaryToJsonTransaction = try? abieos?.deserializeTransaction(hex: hex)
```

### ECC Usage

ECC provides the following methods, among others. This list will expand as more are added.

* `EosioEccSign.signWithK1(...)`: Sign data with a K1 key for validation on an EOSIO chain.
* `EccRecoverKey.recoverPublicKey(...)`: Recover a public key from a private key or from a signature and message.
* `EccRecoverKey.recid(...)`: Get the Recovery ID for a signature, message and target public key.

### Softkey Signature Provider Usage

**Important:** Softkey Signature Provider stores keys in memory and is therefore not secure. It should only be used for development purposes. In production, we strongly recommend using a signature provider that interfaces with a secure vault, authenticator or wallet, such as the Vault Signature Provider from [EOSIO SDK for Swift: Vault](https://github.com/EOSIO/eosio-swift-vault).

Generally, signature providers are called by [`EosioTransaction`](Sources/EosioSwift/EosioTransaction/EosioTransaction.swift) during signing. ([See an example here.](https://github.com/EOSIO/eosio-swift#basic-usage)) If you find, however, that you need to get available keys or request signing directly, this library can be invoked as follows:

```swift
let signProvider = try? EosioSoftkeySignatureProvider(privateKeys: privateKeysArray)
let publicKeysArray = signProvider?.getAvailableKeys() // Returns the public keys.
```

To sign an [`EosioTransaction`](Sources/EosioSwift/EosioTransaction/EosioTransaction.swift), create an [`EosioTransactionSignatureRequest`](Sources/EosioSwift/EosioSignatureProviderProtocol/EosioSignatureProviderProtocol.swift) object and call the `EosioSoftkeySignatureProvider.signTransaction(request:completion:)` method with the request:

```swift
var signRequest = EosioTransactionSignatureRequest()
signRequest.serializedTransaction = serializedTransaction
signRequest.publicKeys = publicKeys
signRequest.chainId = chainId

signProvider.signTransaction(request: signRequest) { (response) in
    ...
}
```

### Key Management and Signing Utilities

Utilities for key generation and management and other signing functionality can be found in the [EOSIO SDK for Swift: Vault](https://github.com/EOSIO/eosio-swift-vault) library.

## Other Examples

More examples can be found in the [EXAMPLES.md](EXAMPLES.md) document.

## Code Documentation

Please refer to the generated code documentation at https://eosio.github.io/eosio-swift/ or by cloning this repo and opening any of the following files in your browser:

* `docs/EosioSwift/index.html`
* `docs/EosioSwiftAbieosSerializationProvider/index.html`
* `docs/EosioSwiftEcc/index.html`
* `docs/EosioSwiftSoftkeySignatureProvider/index.html`

Documentation can be regenerated or updated by running the `update_documentation.sh` script in the repo.

## Provider Protocol Architecture

The core EOSIO SDK for Swift library uses a provider-protocol-driven architecture to provide maximum flexibility in a variety of environments and use cases. `EosioTransaction` leverages those providers to prepare and process transactions. EOSIO SDK for Swift exposes four protocols. You, the developer, get to choose which conforming implementations to use.

### Signature Provider Protocol

The Signature Provider abstraction is arguably the most useful of all of the [EOSIO SDK for Swift](https://github.com/EOSIO/eosio-swift) providers. It is responsible for:

* finding out what keys are available for signing (`getAvailableKeys`), and
* requesting and obtaining transaction signatures with a subset of the available keys (`signTransaction`).

By simply switching out the signature provider on a transaction, signature requests can be routed any number of ways. Need software signing? [Configure the `EosioTransaction`](#basic-usage) with the [Softkey Signature Provider](#softkey-signature-provider-usage) signature provider. Need a signature from keys in the platform's Keychain or Secure Enclave? Take a look at the [Vault Signature Provider](https://github.com/EOSIO/eosio-swift-vault). Need signatures from a wallet on the user's device? A signature provider can do that too!

All signature providers must conform to the [`EosioSignatureProviderProtocol`](Sources/EosioSwift/EosioSignatureProviderProtocol/EosioSignatureProviderProtocol.swift) Protocol.

EOSIO SDK for Swift does include a signature provider implementation; `EosioSoftkeySignatureProvider`, an example signature provider for signing transactions using K1 keys in memory. _This signature provider stores keys in memory and is therefore not secure. It should only be used for development purposes. In production, we strongly recommend using a signature provider that interfaces with a secure vault, authenticator or wallet._

While it is possible to use `EosioSoftkeySignatureProvider`, [Vault Signature Provider](https://github.com/EOSIO/eosio-swift-vault), a signature provider implementation for signing transactions using keys stored in Keychain or the device's Secure Enclave, is strongly recommended.

### RPC Provider Protocol

The RPC Provider is responsible for all [RPC calls to nodeos](https://developers.eos.io/manuals/eos/latest/nodeos/plugins/chain_api_plugin/api-reference/index), as well as general network handling (Reachability, retry logic, etc.) While EOSIO SDK for Swift includes an [RPC Provider implementation](#rpc-using-the-default-rpc-provider), it must still be set explicitly when creating an `EosioTransaction`, as it must be instantiated with an endpoint. (The default implementation suffices for most use cases.)

* [`EosioRpcProviderProtocol`](Sources/EosioSwift/EosioRpcProviderProtocol/EosioRpcProviderProtocol.swift) - All RPC providers must conform to this protocol.
* [`EosioRpcProvider`](Sources/EosioSwift/EosioRpcProvider/EosioRpcProvider.swift) Default Implementation - Default RPC provider implementation included in EOSIO SDK for Swift.
* [Nodeos RPC Reference Documentation](https://developers.eos.io/manuals/eos/latest/nodeos/plugins/chain_api_plugin/api-reference/index) - Nodeos RPC reference.

### Serialization Provider Protocol

The Serialization Provider is responsible for ABI-driven transaction and action serialization and deserialization between JSON and binary data representations. These implementations often contain platform-sensitive C++ code and larger dependencies. EOSIO SDK for Swift does include a serialization provider implementation.

* [`EosioSerializationProviderProtocol`](Sources/EosioSwift/EosioSerializationProviderProtocol/EosioSerializationProviderProtocol.swift) - All serialization providers must conform to this protocol.
* [`EosioAbieosSerializationProvider`](Sources/EosioSwiftAbieosSerializationProvider/EosioAbieosSerializationProvider.swift) - Serialization/deserialization using ABIEOS. Currently supports iOS 12+.

### ABI Provider Protocol

The ABI Provider is responsible for fetching and caching ABIs for use during serialization and deserialization. If none is explicitly set on the `EosioTransaction`, the default [`EosioAbiProvider`](Sources/EosioSwift/EosioAbiProviderProtocol/EosioAbiProvider.swift) will be used. (The default implementation suffices for most use cases.)

* [`EosioAbiProviderProtocol`](Sources/EosioSwift/EosioAbiProviderProtocol/EosioAbiProviderProtocol.swift) - All ABI providers must conform to this protocol.
* [`EosioAbiProvider`](Sources/EosioSwift/EosioAbiProviderProtocol/EosioAbiProvider.swift) Default Implementation - Default ABI provider implementation included in EOSIO SDK for Swift.

## RPC: Using the Default RPC Provider

EOSIO Swift includes a default RPC Provider implementation ([`EosioRpcProvider`](Sources/EosioSwift/EosioRpcProvider/EosioRpcProvider.swift)) for communicating with EOSIO nodes using the [EOSIO RPC API](https://developers.eos.io/manuals/eos/latest/nodeos/plugins/chain_api_plugin/api-reference/index). Alternate RPC providers can be used assuming they conform to the minimal [`EosioRpcProviderProtocol`](Sources/EosioSwift/EosioRpcProviderProtocol/EosioRpcProviderProtocol.swift). The core EOSIO SDK for Swift library depends only on five of the six RPC endpoints set forth in that Protocol. `pushTransaction` is no longer used by the core library but has been retained for backwards compatibility. Other endpoints, however, are exposed in the default [`EosioRpcProvider`](Sources/EosioSwift/EosioRpcProvider/EosioRpcProvider.swift).

Calls can be made to any of the available endpoints as follows:

```swift
rpcProvider.getInfo { (infoResponse) in
    switch infoResponse {
    case .failure(let error):
        // handle the error
    }
    case .success(let info) {
        // do stuff with the info!
        print(info.chainId)
    }
}
```

Attempts are made to marshall the responses into convenient Swift structs. More deeply nested response properties may be presented as a dictionary.

Each response struct will also contain a `_rawResponse` property. In the event the returned struct is missing a property you were expecting from the response, inspect the `_rawResponse`. You will likely find it there.

Response structs are currently incomplete. Some responses will _only_ return the `_rawResponse`. We aim to continue improving response marshalling. And we invite you to [help us improve](#want-to-help) responses too.

## Want to help?

Interested in contributing? That's awesome! Here are some [Contribution Guidelines](https://github.com/EOSIO/eosio-swift/blob/master/CONTRIBUTING.md) and the [Code of Conduct](https://github.com/EOSIO/eosio-swift/blob/master/CONTRIBUTING.md#conduct).

We're always looking for ways to improve EOSIO SDK for Swift. Check out our [#enhancement Issues](https://github.com/EOSIO/eosio-swift/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement) for ways you can pitch in.

## License

[MIT](https://github.com/EOSIO/eosio-swift/blob/master/LICENSE)

## Important

See LICENSE for copyright and license terms.  Block.one makes its contribution on a voluntary basis as a member of the EOSIO community and is not responsible for ensuring the overall performance of the software or any related applications.  We make no representation, warranty, guarantee or undertaking in respect of the software or any related documentation, whether expressed or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall we be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or documentation or the use or other dealings in the software or documentation. Any test results or performance figures are indicative and will not reflect performance under all conditions.  Any reference to any third party or third-party product, service or other resource is not an endorsement or recommendation by Block.one.  We are not responsible, and disclaim any and all responsibility and liability, for your use of or reliance on any of these resources. Third-party resources may be updated, changed or terminated at any time, so the information here may be out of date or inaccurate.  Any person using or offering this software in connection with providing software, goods or services to third parties shall advise such third parties of these license terms, disclaimers and exclusions of liability.  Block.one, EOSIO, EOSIO Labs, EOS, the heptahedron and associated logos are trademarks of Block.one.

Wallets and related components are complex software that require the highest levels of security.  If incorrectly built or used, they may compromise users’ private keys and digital assets. Wallet applications and related components should undergo thorough security evaluations before being used.  Only experienced developers should work with this software.
