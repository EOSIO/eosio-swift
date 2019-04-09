![Swift Logo](img/swift-logo.png)
# EOSIO SDK for Swift ![EOSIO Alpha](https://img.shields.io/badge/EOSIO-Alpha-blue.svg)


[![Software License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/EOSIO/eosio-swift/blob/master/LICENSE)
[![Swift 4.2](https://img.shields.io/badge/Language-Swift_4.2-orange.svg)](https://swift.org)
![](https://img.shields.io/badge/Deployment%20Target-iOS%2011-blue.svg)

EOSIO SDK for Swift is an API for integrating with EOSIO-based blockchains using the [EOSIO RPC API](https://developers.eos.io/eosio-nodeos/reference).

To date, EOSIO SDK for Swift has only been tested on iOS. The goal, however, is for the core library to run anywhere Swift runs, adding other targets (macOS, watchOS, tvOS) as the library matures.

*All product and company names are trademarks™ or registered® trademarks of their respective holders. Use of them does not imply any affiliation with or endorsement by them.*

## Contents

- [Installation](#installation)
- [Basic Usage](#basic-usage)
- [Provider Protocol Architecture](#provider-protocol-architecture)
- [RPC: Using the Default RPC Provider](#rpc-using-the-default-rpc-provider)
- [What's Next for the SDK](#whats-next-for-the-sdk)
- [Want to Help?](#want-to-help)
- [License & Legal](#license)

## Installation

### Prerequisites

* Xcode 10 or higher
* CocoaPods 1.5.3 or higher
* For iOS, iOS 11+*

***Note:** [ABIEOS Serialization Provider](https://github.com/EOSIO/eosio-swift-abieos-serialization-provider) requires iOS 12+ at the moment.

### Instructions

1. Clone this repo
1. Clone any provider repos into the same directory
1. Run `pod install`

### Example Installation

These example instructions set you up with the providers used in the following [Basic Usage](#basic-usage) example.

All of the following repos must be cloned into the same directory as sibling of one another:

1. Clone this repo
1. Clone the [ABIEOS Serialization Provider](https://github.com/EOSIO/eosio-swift-abieos-serialization-provider) repo
1. Clone the [Softkey Signature Provider](https://github.com/EOSIO/eosio-swift-softkey-signature-provider) repo
1. From the core `eosio-swift` directory, run `pod install`

You're all set for the [Basic Usage](#basic-usage) example!

As soon as these pods are published publicly, these installation instructions will be updated.

## Basic Usage

Transactions are instantiated as an `EosioTransaction()` and must then be configured with a number of providers prior to use. (See [Provider Protocol Architecture](#provider-protocol-architecture) below for more information about providers.)

```swift
import EosioSwift
import EosioSwiftAbieos
import EosioSwiftSoftkeySignatureProvider

...

let transaction = EosioTransaction()
transaction.rpcProvider = EosioRpcProvider(endpoint: URL(string: "http://localhost:8888")!)
transaction.serializationProvider = AbiEos()
transaction.signatureProvider = try! EosioSwiftSoftkeySignatureProvider(privateKeys: ["yourPrivateKey"])
```

Actions can now be appended to the transaction, which can, in turn, be signed and broadcast:

```swift
let action = try! EosioTransaction.Action(
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

transaction.actions.append(action)

transaction.signAndBroadcast { (result) in
    print(try! transaction.toJson(prettyPrinted: true))
    switch result {
    case .failure (let error):
        print(error.reason)
    case .success:
        if let transactionId = transaction.transactionId {
            print("SUCCESS!")
            print(transactionId)
        }
    }
}
```

**Note:** Currently, providers must be set on each and every transaction. We are, however, considering the introduction of a convenience transaction factory in future versions to streamline transaction creation and configuration.

## Provider Protocol Architecture

The core EOSIO SDK for Swift library uses a provider-protocol-driven architecture to provide maximum flexibility in a variety of environments and use cases. `EosioTransaction` leverages those providers to prepare and process transactions. EOSIO SDK for Swift exposes four protocols. You, the developer, get to choose which conforming implementations to use.

### Signature Provider Protocol

The Signature Provider abstraction is arguably the most useful of all of the providers. It is responsible for _a)_ finding out what keys are available for signing and _b)_ requesting and obtaining transaction signatures with a subset of the available keys.

By simply switching out the signature provider on a transaction, signature requests can be routed any number of ways. Need a signature from keys in the platform's Keychain or Secure Enclave? Configure the `EosioTransaction` with a conforming signature provider that exposes that functionality. Need signatures from a wallet on the user's device? A signature provider can do that too!

EOSIO SDK for Swift _does not include_ a signature provider implementation; one must be installed separately.

* [EosioSignatureProviderProtocol](EosioSwift/EosioSignatureProviderProtocol/EosioSignatureProviderProtocol.swift)
* [Softkey Signature Provider](https://github.com/EOSIO/eosio-swift-softkey-signature-provider) - Example signature provider for signing transactions using K1 keys in memory.*

*_Softkey Signature Provider stores keys in memory and is therefore not secure. It should only be used for development purposes. In production, we strongly recommend using a signature provider that interfaces with a secure vault, authenticator or wallet._

### RPC Provider Protocol

The RPC Provider is responsible for all [RPC calls to nodeos](https://developers.eos.io/eosio-nodeos/reference), as well as general network handling (Reachability, retry logic, etc.) While EOSIO SDK for Swift includes an [RPC Provider implementation](#rpc-using-the-default-rpc-provider), it must still be set explicitly when creating an `EosioTransaction`, as it must be instantiated with an endpoint. (The default implementation suffices for most use cases.)

* [EosioRpcProviderProtocol](EosioSwift/EosioRpcProviderProtocol/EosioRpcProviderProtocol.swift)
* [Default EosioRpcProvider Implementation](EosioSwift/EosioRpcProvider/EosioRpcProvider.swift)
* [Nodeos RPC Reference Documentation](https://developers.eos.io/eosio-nodeos/reference)

### Serialization Provider Protocol

The Serialization Provider is responsible for ABI-driven transaction and action serialization and deserialization between JSON and binary data representations. These implementations often contain platform-sensitive C++ code and larger dependencies such as OpenSSL. For those reasons, EOSIO SDK for Swift _does not include_ a serialization provider implementation; one must be installed separately.

* [EosioSerializationProviderProtocol](EosioSwift/EosioSerializationProviderProtocol/EosioSerializationProviderProtocol.swift)
* [ABIEOS Serialization Provider Implementation](https://github.com/EOSIO/eosio-swift-abieos-serialization-provider) - Currently supports iOS 12+

### ABI Provider Protocol

The ABI Provider is responsible for fetching and caching ABIs for use during serialization and deserialization. If none is explicitly set on the `EosioTransaction`, the default [EosioAbiProvider](EosioSwift/EosioAbiProviderProtocol/EosioAbiProvider.swift) will be used. (The default implementation suffices for most use cases.)

* [EosioAbiProviderProtocol](EosioSwift/EosioAbiProviderProtocol/EosioAbiProviderProtocol.swift)
* [Default EosioAbiProvider Implementation](EosioSwift/EosioAbiProviderProtocol/EosioAbiProvider.swift)

## RPC: Using the Default RPC Provider

EOSIO Swift includes a [default RPC Provider implementation](EosioSwift/EosioRpcProvider/EosioRpcProvider.swift) for communicating with EOSIO nodes using the [EOSIO RPC API](https://developers.eos.io/eosio-nodeos/reference). Alternate RPC providers can be used assuming they conform to the minimal [RPC Provider Protocol](EosioSwift/EosioRpcProviderProtocol/EosioRpcProviderProtocol.swift). The core EOSIO SDK for Swift library depends only on the five RPC endpoints set forth in that Protocol. Other endpoints, however, are exposed in the [default RPC provider](EosioSwift/EosioRpcProvider/EosioRpcProvider.swift).

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

## What's Next for the SDK?

We're always looking for ways to improve EOSIO SDK for Swift. Here are a few ideas around how we'd like to see the library progress. Check out our [#enhancement Issues](issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement) for more.

* Implement a Transaction factory so that providers don't have to be set explicitly for every transaction
* Improve RPC response marshalling; build out new and existing response structs
* Make Transaction properties immutable once signatures are present
* Add networking enhancements to the default RPC provider (_e.g._, retry logic, endpoint failover, offline handling)
* Improve general error handling
* Add MacOS support and other targets

## Want to help?

Interested in contributing? That's awesome! Here are some [Contribution Guidelines](./CONTRIBUTING.md) and the [Code of Conduct](./CONTRIBUTING.md#conduct).

## License

[MIT](https://github.com/EOSIO/eosio-swift/blob/master/LICENSE)

## Important

See LICENSE for copyright and license terms.  Block.one makes its contribution on a voluntary basis as a member of the EOSIO community and is not responsible for ensuring the overall performance of the software or any related applications.  We make no representation, warranty, guarantee or undertaking in respect of the software or any related documentation, whether expressed or implied, including but not limited to the warranties or merchantability, fitness for a particular purpose and noninfringement. In no event shall we be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or documentation or the use or other dealings in the software or documentation.  Any test results or performance figures are indicative and will not reflect performance under all conditions.  Any reference to any third party or third-party product, service or other resource is not an endorsement or recommendation by Block.one.  We are not responsible, and disclaim any and all responsibility and liability, for your use of or reliance on any of these resources. Third-party resources may be updated, changed or terminated at any time, so the information here may be out of date or inaccurate.
