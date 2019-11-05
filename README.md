![Swift Logo](https://github.com/EOSIO/eosio-swift-softkey-signature-provider/raw/master/img/swift-logo.png)
# EOSIO SDK for Swift: Softkey Signature Provider ![EOSIO Alpha](https://img.shields.io/badge/EOSIO-Alpha-blue.svg)

[![Software License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/EOSIO/eosio-swift/blob/master/LICENSE)
[![Swift 5.0](https://img.shields.io/badge/Language-Swift_5.0-orange.svg)](https://swift.org)
![](https://img.shields.io/badge/Deployment%20Target-iOS%2011-blue.svg)

Softkey Signature Provider is an example pluggable signature provider for [EOSIO SDK for Swift](https://github.com/EOSIO/eosio-swift). It allows for signing transactions using in-memory K1 keys.

**Important:** Softkey Signature Provider stores keys in memory and is therefore not secure. It should only be used for development purposes. In production, we strongly recommend using a signature provider that interfaces with a secure vault, authenticator or wallet, such as the [EOSIO SDK for Swift: Vault Signature Provider](https://github.com/EOSIO/eosio-swift-vault-signature-provider).

*All product and company names are trademarks™ or registered® trademarks of their respective holders. Use of them does not imply any affiliation with or endorsement by them.*

## Contents

- [About Signature Providers](#about-signature-providers)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Direct Usage](#direct-usage)
- [Documentation](#documentation)
- [iOS Example App](#ios-example-app)
- [Library Methods](#library-methods)
- [Want to Help?](#want-to-help)
- [License & Legal](#license)

## About Signature Providers

The Signature Provider abstraction is arguably the most useful of all of the [EOSIO SDK for Swift](https://github.com/EOSIO/eosio-swift) providers. It is responsible for:

* finding out what keys are available for signing (`getAvailableKeys`), and
* requesting and obtaining transaction signatures with a subset of the available keys (`signTransaction`).

By simply switching out the signature provider on a transaction, signature requests can be routed any number of ways. Need software signing? [Configure the `EosioTransaction`](https://github.com/EOSIO/eosio-swift#basic-usage) with this signature provider. Need a signature from keys in the platform's Keychain or Secure Enclave? Take a look at the [Vault Signature Provider](https://github.com/EOSIO/eosio-swift-vault-signature-provider). Need signatures from a wallet on the user's device? A signature provider can do that too!

All signature providers must conform to the [`EosioSignatureProviderProtocol`](https://github.com/EOSIO/eosio-swift/blob/master/EosioSwift/EosioSignatureProviderProtocol/EosioSignatureProviderProtocol.swift) Protocol.

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
  pod "EosioSwift", "~> 0.2.1" # EOSIO SDK for Swift core library
  pod "EosioSwiftSoftkeySignatureProvider", "~> 0.2.1" # pod for this library
  # add other providers for EOSIO SDK for Swift
  pod "EosioSwiftAbieosSerializationProvider", "~> 0.2.1" # serialization provider

```

Then run `pod install`.

Now Softkey Signature Provider is ready for use within EOSIO SDK for Swift according to the [EOSIO SDK for Swift Basic Usage instructions](https://github.com/EOSIO/eosio-swift/tree/master#basic-usage).

## Direct Usage

Generally, signature providers are called by [`EosioTransaction`](https://github.com/EOSIO/eosio-swift/blob/master/EosioSwift/EosioTransaction/EosioTransaction.swift) during signing. ([See an example here.](https://github.com/EOSIO/eosio-swift#basic-usage)) If you find, however, that you need to get available keys or request signing directly, this library can be invoked as follows:

```swift
let signProvider = try? EosioSoftkeySignatureProvider(privateKeys: privateKeysArray)
let publicKeysArray = signProvider?.getAvailableKeys() // Returns the public keys.
```

To sign an [`EosioTransaction`](https://github.com/EOSIO/eosio-swift/blob/master/EosioSwift/EosioTransaction/EosioTransaction.swift), create an [`EosioTransactionSignatureRequest`](https://github.com/EOSIO/eosio-swift/blob/master/EosioSwift/EosioSignatureProviderProtocol/EosioSignatureProviderProtocol.swift) object and call the `EosioSoftkeySignatureProvider.signTransaction(request:completion:)` method with the request:

```swift
var signRequest = EosioTransactionSignatureRequest()
signRequest.serializedTransaction = serializedTransaction
signRequest.publicKeys = publicKeys
signRequest.chainId = chainId

signProvider.signTransaction(request: signRequest) { (response) in
    ...
}
```

## Documentation

Please refer to the generated code documentation at https://eosio.github.io/eosio-swift-softkey-signature-provider or by cloning this repo and opening the `docs/index.html` file in your browser.

## iOS Example App

If you'd like to see the EOSIO SDK for Swift: Softkey Signature Provider in action, check out our open source [iOS Example App](https://github.com/EOSIO/eosio-swift-ios-example-app)--a working application that fetches an account's token balance and pushes a transfer action.

## Library Methods

This library is an example implementation of [`EosioSignatureProviderProtocol`](https://github.com/EOSIO/eosio-swift/blob/master/EosioSwift/EosioSignatureProviderProtocol/EosioSignatureProviderProtocol.swift). It implements the following protocol methods:

* `EosioSoftkeySignatureProvider.signTransaction(request:completion:)` signs an [`EosioTransaction`](https://github.com/EOSIO/eosio-swift/blob/master/EosioSwift/EosioTransaction/EosioTransaction.swift).
* `EosioSoftkeySignatureProvider.getAvailableKeys(...)` returns an array containing the public keys associated with the private keys that the object is initialized with.

To initialize the implementation:

* `EosioSoftkeySignatureProvider.init(privateKeys:)` initializes the signature provider with an array of private keys as strings.

## Want to help?

Interested in contributing? That's awesome! Here are some [Contribution Guidelines](https://github.com/EOSIO/eosio-swift-softkey-signature-provider/blob/master/CONTRIBUTING.md) and the [Code of Conduct](https://github.com/EOSIO/eosio-swift-softkey-signature-provider/blob/master/CONTRIBUTING.md#conduct).

## License

[MIT](https://github.com/EOSIO/eosio-swift-softkey-signature-provider/blob/master/LICENSE)

## Important

See LICENSE for copyright and license terms.  Block.one makes its contribution on a voluntary basis as a member of the EOSIO community and is not responsible for ensuring the overall performance of the software or any related applications.  We make no representation, warranty, guarantee or undertaking in respect of the software or any related documentation, whether expressed or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall we be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or documentation or the use or other dealings in the software or documentation. Any test results or performance figures are indicative and will not reflect performance under all conditions.  Any reference to any third party or third-party product, service or other resource is not an endorsement or recommendation by Block.one.  We are not responsible, and disclaim any and all responsibility and liability, for your use of or reliance on any of these resources. Third-party resources may be updated, changed or terminated at any time, so the information here may be out of date or inaccurate.  Any person using or offering this software in connection with providing software, goods or services to third parties shall advise such third parties of these license terms, disclaimers and exclusions of liability.  Block.one, EOSIO, EOSIO Labs, EOS, the heptahedron and associated logos are trademarks of Block.one.

Wallets and related components are complex software that require the highest levels of security.  If incorrectly built or used, they may compromise users’ private keys and digital assets. Wallet applications and related components should undergo thorough security evaluations before being used.  Only experienced developers should work with this software.
