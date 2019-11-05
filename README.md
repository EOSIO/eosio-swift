![Swift Logo](https://raw.githubusercontent.com/EOSIO/eosio-swift/master/img/swift-logo.png)
# EOSIO SDK for Swift ![EOSIO Alpha](https://img.shields.io/badge/EOSIO-Alpha-blue.svg)

[![Software License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/EOSIO/eosio-swift/blob/master/LICENSE)
[![Swift 5.0](https://img.shields.io/badge/Language-Swift_5.0-orange.svg)](https://swift.org)
![](https://img.shields.io/badge/Deployment%20Target-iOS%2011-blue.svg)

EOSIO SDK for Swift is an API for integrating with EOSIO-based blockchains using the [EOSIO RPC API](https://developers.eos.io/eosio-nodeos/reference). For a high-level introduction to our Swift and Java SDKs, check out our announcement on Medium: [EOSIO™ Software Release: Native SDKs for Swift and Java](https://medium.com/eosio/eosio-software-release-native-sdks-for-swift-and-java-e6086ddd37b8).

To date, EOSIO SDK for Swift has only been tested on iOS. The goal, however, is for the core library to run anywhere Swift runs, adding other targets (macOS, watchOS, tvOS) as the library matures.

*All product and company names are trademarks™ or registered® trademarks of their respective holders. Use of them does not imply any affiliation with or endorsement by them.*

## Contents

- [Installation](#installation)
- [Basic Usage](#basic-usage)
    - [Working With Transactions](#working-with-transactions)
    - [The Transaction Factory](#the-transaction-factory)
    - [Usage With PromiseKit](#usage-with-promisekit)
    - [Key Management and Signing Utilities](#key-management-and-signing-utilities)
- [iOS Example App](#ios-example-app)
- [Documentation](#documentation)
- [Provider Protocol Architecture](#provider-protocol-architecture)
- [RPC: Using the Default RPC Provider](#rpc-using-the-default-rpc-provider)
- [Want to Help?](#want-to-help)
- [License & Legal](#license)

## Installation

### Prerequisites

* Xcode 10 or higher
* CocoaPods 1.5.3 or higher
* For iOS, iOS 11+*

***Note:** [ABIEOS Serialization Provider](https://github.com/EOSIO/eosio-swift-abieos-serialization-provider) requires iOS 12+ at the moment.

### Instructions

To use EOSIO SDK for Swift in your app, add the following pods to your [Podfile](https://guides.cocoapods.org/syntax/podfile.html):

```ruby
use_frameworks!

target "Your Target" do
  pod "EosioSwift", "~> 0.2.1" # pod for this library
  # Providers for EOSIO SDK for Swift
  pod "EosioSwiftAbieosSerializationProvider", "~> 0.2.1" # serialization provider
  pod "EosioSwiftSoftkeySignatureProvider", "~> 0.2.1" # experimental signature provider for development only
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

### The Transaction Factory

Alternatively, to avoid having to set the providers on every transaction, you can use the [`EosioTransactionFactory`](EosioSwift/EosioTransaction/EosioTransactionFactory.swift) convenience class, as follows:

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

### Key Management and Signing Utilities

Utilities for key generation and management and other signing functionality can be found in the [EOSIO SDK for Swift: Vault](https://github.com/EOSIO/eosio-swift-vault) library.

## iOS Example App

If you'd like to see EOSIO SDK for Swift in action, check out our open source [iOS Example App](https://github.com/EOSIO/eosio-swift-ios-example-app)--a working application that fetches an account's token balance and pushes a transfer action.

## Documentation

Please refer to the generated code documentation at https://eosio.github.io/eosio-swift/ or by cloning this repo and opening the `docs/index.html` file in your browser.

## Provider Protocol Architecture

The core EOSIO SDK for Swift library uses a provider-protocol-driven architecture to provide maximum flexibility in a variety of environments and use cases. `EosioTransaction` leverages those providers to prepare and process transactions. EOSIO SDK for Swift exposes four protocols. You, the developer, get to choose which conforming implementations to use.

### Signature Provider Protocol

The Signature Provider abstraction is arguably the most useful of all of the providers. It is responsible for _a)_ finding out what keys are available for signing and _b)_ requesting and obtaining transaction signatures with a subset of the available keys.

By simply switching out the signature provider on a transaction, signature requests can be routed any number of ways. Need a signature from keys in the platform's Keychain or Secure Enclave? Configure the `EosioTransaction` with the [EOSIO SDK for Swift: Vault Signature Provider](https://github.com/EOSIO/eosio-swift-vault-signature-provider). Need signatures from a wallet on the user's device? A signature provider can do that too!

EOSIO SDK for Swift _does not include_ a signature provider implementation; one must be installed separately. All signature providers must conform to the [`EosioSignatureProviderProtocol`](EosioSwift/EosioSignatureProviderProtocol/EosioSignatureProviderProtocol.swift).

* [Vault Signature Provider](https://github.com/EOSIO/eosio-swift-vault-signature-provider) - Signature provider implementation for signing transactions using keys stored in Keychain or the device's Secure Enclave.
* [Softkey Signature Provider](https://github.com/EOSIO/eosio-swift-softkey-signature-provider) - Example signature provider for signing transactions using K1 keys in memory. _This signature provider stores keys in memory and is therefore not secure. It should only be used for development purposes. In production, we strongly recommend using a signature provider that interfaces with a secure vault, authenticator or wallet._
* [Reference iOS Authenticator Signature Provider](https://github.com/EOSIO/eosio-swift-reference-ios-authenticator-signature-provider) - Native iOS Apps using this signature provider are able to integrate with the [EOSIO Reference iOS Authenticator App](https://github.com/EOSIO/eosio-reference-ios-authenticator-app), allowing their users to sign in and approve transactions via the authenticator app.

### RPC Provider Protocol

The RPC Provider is responsible for all [RPC calls to nodeos](https://developers.eos.io/eosio-nodeos/reference), as well as general network handling (Reachability, retry logic, etc.) While EOSIO SDK for Swift includes an [RPC Provider implementation](#rpc-using-the-default-rpc-provider), it must still be set explicitly when creating an `EosioTransaction`, as it must be instantiated with an endpoint. (The default implementation suffices for most use cases.)

* [`EosioRpcProviderProtocol`](EosioSwift/EosioRpcProviderProtocol/EosioRpcProviderProtocol.swift) - All RPC providers must conform to this protocol.
* [`EosioRpcProvider`](EosioSwift/EosioRpcProvider/EosioRpcProvider.swift) Default Implementation - Default RPC provider implementation included in EOSIO SDK for Swift.
* [Nodeos RPC Reference Documentation](https://developers.eos.io/eosio-nodeos/reference) - Nodeos RPC reference.

### Serialization Provider Protocol

The Serialization Provider is responsible for ABI-driven transaction and action serialization and deserialization between JSON and binary data representations. These implementations often contain platform-sensitive C++ code and larger dependencies. For those reasons, EOSIO SDK for Swift _does not include_ a serialization provider implementation; one must be installed separately.

* [`EosioSerializationProviderProtocol`](EosioSwift/EosioSerializationProviderProtocol/EosioSerializationProviderProtocol.swift) - All serialization providers must conform to this protocol.
* [ABIEOS Serialization Provider Implementation](https://github.com/EOSIO/eosio-swift-abieos-serialization-provider) - Serialization/deserialization using ABIEOS. Currently supports iOS 12+.

### ABI Provider Protocol

The ABI Provider is responsible for fetching and caching ABIs for use during serialization and deserialization. If none is explicitly set on the `EosioTransaction`, the default [`EosioAbiProvider`](EosioSwift/EosioAbiProviderProtocol/EosioAbiProvider.swift) will be used. (The default implementation suffices for most use cases.)

* [`EosioAbiProviderProtocol`](EosioSwift/EosioAbiProviderProtocol/EosioAbiProviderProtocol.swift) - All ABI providers must conform to this protocol.
* [`EosioAbiProvider`](EosioSwift/EosioAbiProviderProtocol/EosioAbiProvider.swift) Default Implementation - Default ABI provider implementation included in EOSIO SDK for Swift.

## RPC: Using the Default RPC Provider

EOSIO Swift includes a default RPC Provider implementation ([`EosioRpcProvider`](EosioSwift/EosioRpcProvider/EosioRpcProvider.swift)) for communicating with EOSIO nodes using the [EOSIO RPC API](https://developers.eos.io/eosio-nodeos/reference). Alternate RPC providers can be used assuming they conform to the minimal [`EosioRpcProviderProtocol`](EosioSwift/EosioRpcProviderProtocol/EosioRpcProviderProtocol.swift). The core EOSIO SDK for Swift library depends only on the five RPC endpoints set forth in that Protocol. Other endpoints, however, are exposed in the default [`EosioRpcProvider`](EosioSwift/EosioRpcProvider/EosioRpcProvider.swift).

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

Response structs for the alpha release are incomplete. Some responses will only return the `_rawResponse`. We aim to continue improving response marshalling. And we invite you to [help us improve](#want-to-help) responses too.

## Want to help?

Interested in contributing? That's awesome! Here are some [Contribution Guidelines](https://github.com/EOSIO/eosio-swift/blob/master/CONTRIBUTING.md) and the [Code of Conduct](https://github.com/EOSIO/eosio-swift/blob/master/CONTRIBUTING.md#conduct).

We're always looking for ways to improve EOSIO SDK for Swift. Check out our [#enhancement Issues](https://github.com/EOSIO/eosio-swift/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement) for ways you can pitch in.

## License

[MIT](https://github.com/EOSIO/eosio-swift/blob/master/LICENSE)

## Important

See LICENSE for copyright and license terms.  Block.one makes its contribution on a voluntary basis as a member of the EOSIO community and is not responsible for ensuring the overall performance of the software or any related applications.  We make no representation, warranty, guarantee or undertaking in respect of the software or any related documentation, whether expressed or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall we be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or documentation or the use or other dealings in the software or documentation. Any test results or performance figures are indicative and will not reflect performance under all conditions.  Any reference to any third party or third-party product, service or other resource is not an endorsement or recommendation by Block.one.  We are not responsible, and disclaim any and all responsibility and liability, for your use of or reliance on any of these resources. Third-party resources may be updated, changed or terminated at any time, so the information here may be out of date or inaccurate.  Any person using or offering this software in connection with providing software, goods or services to third parties shall advise such third parties of these license terms, disclaimers and exclusions of liability.  Block.one, EOSIO, EOSIO Labs, EOS, the heptahedron and associated logos are trademarks of Block.one.

Wallets and related components are complex software that require the highest levels of security.  If incorrectly built or used, they may compromise users’ private keys and digital assets. Wallet applications and related components should undergo thorough security evaluations before being used.  Only experienced developers should work with this software.
