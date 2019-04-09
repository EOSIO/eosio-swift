# EOSIO SDK for Swift: Softkey Signature Provider ![EOSIO Alpha](https://img.shields.io/badge/EOSIO-Alpha-blue.svg)
[![Software License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/EOSIO/eosio-swift/blob/master/LICENSE)
[![Swift 4.2](https://img.shields.io/badge/Language-Swift_4.2-orange.svg)](https://swift.org)
![](https://img.shields.io/badge/Deployment%20Target-iOS%2011-blue.svg)

Softkey Signature Provider is an example pluggable signature provider for [EOSIO SDK for Swift](https://github.com/EOSIO/eosio-swift). It allows for signing transactions using in-memory K1 keys.

**Important:** Softkey Signature Provider stores keys in memory and is therefore not secure. It should only be used for development purposes. In production, we strongly recommend using a signature provider that interfaces with a secure vault, authenticator or wallet.

*All product and company names are trademarks™ or registered® trademarks of their respective holders. Use of them does not imply any affiliation with or endorsement by them.*

## Contents

- [About Signature Providers](#about-signature-providers)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Direct Usage](#direct-usage)
- [Library Methods](#library-methods)
- [Want to Help?](#want-to-help)
- [License & Legal](#license)

## About Signature Providers

The Signature Provider abstraction is arguably the most useful of all of the [EOSIO SDK for Swift](https://github.com/EOSIO/eosio-swift) providers. It is responsible for:

* finding out what keys are available for signing (`getAvailableKeys`), and
* requesting and obtaining transaction signatures with a subset of the available keys (`signTransaction`).

By simply switching out the signature provider on a transaction, signature requests can be routed any number of ways. Need a signature from keys in the platform's Keychain or Secure Enclave? Configure the `EosioTransaction` with a conforming signature provider that exposes that functionality. Need signatures from a wallet on the user's device? A signature provider can do that too!

All signature providers must conform to the [EosioSignatureProviderProtocol](EosioSwift/EosioSignatureProviderProtocol/EosioSignatureProviderProtocol.swift) Protocol.

## Prerequisites

* Xcode 10 or higher
* CocoaPods 1.5.3 or higher
* For iOS, iOS 11+

## Installation

Softkey Signature Provider is intended to be used in conjunction with [EOSIO SDK for Swift](https://github.com/EOSIO/eosio-swift) as a provider plugin.

To use Softkey Signature Provider with EOSIO SDK for Swift in your app, add the following pods to your [Podfile](https://guides.cocoapods.org/syntax/podfile.html):

```ruby
use_frameworks!

target "Your Target" do
  pod "EosioSwift", "~> 0.0.1" # EOSIO SDK for Swift core library
  pod "EosioSwiftSoftkeySignatureProvider", "~> 0.0.1" # pod for this library
  # add other providers for EOSIO SDK for Swift
  pod "EosioSwiftAbieos", "~> 0.0.1" # serialization provider
end
```

Then run `pod install`.

Now Softkey Signature Provider is ready for use within EOSIO SDK for Swift according to the [EOSIO SDK for Swift Basic Usage instructions](https://github.com/EOSIO/eosio-swift/tree/develop#basic-usage).

## Direct Usage

```swift
let signProvider = try? EosioSwiftSoftkeySignatureProvider(privateKeys: privateKeysArray)
let publicKeysArray = signProvider?.getAvailableKeys() // Returns the public keys.
```

To sign an `EosioTransaction`, create an `EosioTransactionSignatureRequest` object and call the `signTransaction(request:completion:)` method with the request:

```swift
let signRequest = createSignatureRequest()
signProvider.signTransaction(request: signRequest){ (response) in
    ...
}
```

## Library Methods

This library is an example implementation of `EosioSignatureProviderProtocol`. It implements the following methods:

* `signTransaction(request:completion:)` signs an `EosioTransaction`.
* `getAvailableKeys()` returns an array, containing the public keys associated with the private keys that the object is initialized with.

## Want to help?

Interested in contributing? That's awesome! Here are some [Contribution Guidelines](./CONTRIBUTING.md) and the [Code of Conduct](./CONTRIBUTING.md#conduct).

## License

[MIT](./LICENSE)

## Important

See LICENSE for copyright and license terms.  Block.one makes its contribution on a voluntary basis as a member of the EOSIO community and is not responsible for ensuring the overall performance of the software or any related applications.  We make no representation, warranty, guarantee or undertaking in respect of the software or any related documentation, whether expressed or implied, including but not limited to the warranties or merchantability, fitness for a particular purpose and noninfringement. In no event shall we be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or documentation or the use or other dealings in the software or documentation.  Any test results or performance figures are indicative and will not reflect performance under all conditions.  Any reference to any third party or third-party product, service or other resource is not an endorsement or recommendation by Block.one.  We are not responsible, and disclaim any and all responsibility and liability, for your use of or reliance on any of these resources. Third-party resources may be updated, changed or terminated at any time, so the information here may be out of date or inaccurate.

Wallets and related components are complex software that require the highest levels of security.  If incorrectly built or used, they may compromise users’ private keys and digital assets. Wallet applications and related components should undergo thorough security evaluations before being used.  Only experienced developers should work with this software.
