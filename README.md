![Swift Logo](https://github.com/EOSIO/eosio-swift-abieos-serialization-provider/raw/master/img/swift-logo.png)
# EOSIO SDK for Swift: ABIEOS Serialization Provider ![EOSIO Alpha](https://img.shields.io/badge/EOSIO-Alpha-blue.svg)

[![Software License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/EOSIO/eosio-swift/blob/master/LICENSE)
![Language C++/Swift](https://img.shields.io/badge/Language-C%2B%2B%2FSwift-yellow.svg)
![](https://img.shields.io/badge/Deployment%20Target-iOS%2012-blue.svg)

ABIEOS Serialization Provider is a pluggable serialization provider for [EOSIO SDK for Swift](https://github.com/EOSIO/eosio-swift).

Serialization providers are responsible for ABI-driven transaction and action serialization and deserialization between JSON and binary data representations. This particular serialization provider wraps [ABIEOS](https://github.com/EOSIO/abieos), a C/C++ library that facilitates this conversion.

*All product and company names are trademarks™ or registered® trademarks of their respective holders. Use of them does not imply any affiliation with or endorsement by them.*

## Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Direct Usage](#direct-usage)
- [Documentation](#documentation)
- [iOS Example App](#ios-example-app)
- [Want to Help?](#want-to-help)
- [License & Legal](#license)

## Prerequisites

* Xcode 10 or higher
* CocoaPods 1.5.3 or higher
* For iOS, iOS 12+

This project relies on platform functionality only present in iOS 12+. Therefore, any project depending on ABIEOS Serialization Provider with [EOSIO SDK for Swift](https://github.com/EOSIO/eosio-swift) **must be an iOS 12+ project**. Other serialization providers, however, can be created to support iOS 11. If your project requires iOS 11 support, or if you'd like to create a serialization provider and have questions, please reach out to us by [logging an issue](https://github.com/EOSIO/eosio-swift-abieos-serialization-provider/issues/new).

## Installation

ABIEOS Serialization Provider is intended to be used in conjunction with [EOSIO SDK for Swift](https://github.com/EOSIO/eosio-swift) as a provider plugin.

To use ABIEOS Serialization Provider with EOSIO SDK for Swift in your app, add the following pods to your [Podfile](https://guides.cocoapods.org/syntax/podfile.html):

```ruby
use_frameworks!

target "Your Target" do
  pod "EosioSwift", "~> 0.2.1" # EOSIO SDK for Swift core library
  pod "EosioSwiftAbieos", "~> 0.2.1" # pod for this library
  # add other providers for EOSIO SDK for Swift
  pod "EosioSwiftSoftkeySignatureProvider", "~> 0.2.1" # experimental provider for development only
end
```

Then run `pod install`.

Now ABIEOS Serialization Provider is ready for use within EOSIO SDK for Swift according to the [EOSIO SDK for Swift Basic Usage instructions](https://github.com/EOSIO/eosio-swift/tree/master#basic-usage).

## Direct Usage

If you wish to use ABIEOS Serialization Provider directly, its public methods can be called like this:

```swift
let abieos: EosioAbieosSerializationProvider? = EosioAbieosSerializationProvider()
let hex = "1686755CA99DE8E73E1200" // some binary data
let json = "{"name": "John"}" // some JSON

let jsonToBinaryTransaction = try? abieos?.serializeTransaction(json: json)
let binaryToJsonTransaction = try? abieos?.deserializeTransaction(hex: hex)
```

## Documentation

Please refer to the generated code documentation at https://eosio.github.io/eosio-swift-abieos-serialization-provider or by cloning this repo and opening the `docs/index.html` file in your browser.

## iOS Example App

If you'd like to see the EOSIO SDK for Swift: ABIEOS Serialization Provider in action, check out our open source [iOS Example App](https://github.com/EOSIO/eosio-swift-ios-example-app)--a working application that fetches an account's token balance and pushes a transfer action.

## Want to help?

Interested in contributing? That's awesome! Here are some [Contribution Guidelines](https://github.com/EOSIO/eosio-swift-abieos-serialization-provider/blob/master/CONTRIBUTING.md) and the [Code of Conduct](https://github.com/EOSIO/eosio-swift-abieos-serialization-provider/blob/master/CONTRIBUTING.md#conduct).

## License

[MIT](https://github.com/EOSIO/eosio-swift-abieos-serialization-provider/blob/master/LICENSE)

## Important

See LICENSE for copyright and license terms.  Block.one makes its contribution on a voluntary basis as a member of the EOSIO community and is not responsible for ensuring the overall performance of the software or any related applications.  We make no representation, warranty, guarantee or undertaking in respect of the software or any related documentation, whether expressed or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall we be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or documentation or the use or other dealings in the software or documentation. Any test results or performance figures are indicative and will not reflect performance under all conditions.  Any reference to any third party or third-party product, service or other resource is not an endorsement or recommendation by Block.one.  We are not responsible, and disclaim any and all responsibility and liability, for your use of or reliance on any of these resources. Third-party resources may be updated, changed or terminated at any time, so the information here may be out of date or inaccurate.  Any person using or offering this software in connection with providing software, goods or services to third parties shall advise such third parties of these license terms, disclaimers and exclusions of liability.  Block.one, EOSIO, EOSIO Labs, EOS, the heptahedron and associated logos are trademarks of Block.one.

Wallets and related components are complex software that require the highest levels of security.  If incorrectly built or used, they may compromise users’ private keys and digital assets. Wallet applications and related components should undergo thorough security evaluations before being used.  Only experienced developers should work with this software.
