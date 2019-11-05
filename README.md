![Swift Logo](https://github.com/EOSIO/eosio-swift-ecc/raw/master/img/swift-logo.png)
# EOSIO SDK for Swift: ECC ![EOSIO Alpha](https://img.shields.io/badge/EOSIO-Alpha-blue.svg)

[![Software License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/EOSIO/eosio-swift/blob/master/LICENSE)
[![Swift 5.0](https://img.shields.io/badge/Language-Swift_5.0-orange.svg)](https://swift.org)
![](https://img.shields.io/badge/Deployment%20Target-iOS%2011-blue.svg)

EOSIO SDK for Swift: ECC is a library for working with public and private keys, cryptographic signatures, encryption/decryption, etc. as part of the [EOSIO SDK for Swift](https://github.com/EOSIO/eosio-swift) family of libraries.

*All product and company names are trademarks™ or registered® trademarks of their respective holders. Use of them does not imply any affiliation with or endorsement by them.*

## Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Functionality](#functionality)
- [Documentation](#documentation)
- [Want to Help?](#want-to-help)
- [License & Legal](#license)

## Prerequisites

* Xcode 10 or higher
* CocoaPods 1.5.3 or higher
* For iOS, iOS 11+

## Installation

To use ECC in your application, add the following pod to your [Podfile](https://guides.cocoapods.org/syntax/podfile.html):

```ruby
use_frameworks!

target "Your Target" do
  pod "EosioSwiftEcc", "~> 0.2.1"
end
```

Then run `pod install`.

## Functionality

ECC provides the following methods, among others. This list will expand as more are added.

* `EosioEccSign.signWithK1(...)`: Sign data with a K1 key for validation on an EOSIO chain.
* `EccRecoverKey.recoverPublicKey(...)`: Recover a public key from a private key or from a signature and message.
* `EccRecoverKey.recid(...)`: Get the Recovery ID for a signature, message and target public key.

## Documentation

Please refer to the generated code documentation at https://eosio.github.io/eosio-swift-ecc or by cloning this repo and opening the `docs/index.html` file in your browser.

## Want to help?

Interested in contributing? That's awesome! Here are some [Contribution Guidelines](https://github.com/EOSIO/eosio-swift-ecc/blob/master/CONTRIBUTING.md) and the [Code of Conduct](https://github.com/EOSIO/eosio-swift-ecc/blob/master/CONTRIBUTING.md#conduct).

## License

[MIT](https://github.com/EOSIO/eosio-swift-ecc/blob/master/LICENSE)

## Important

See LICENSE for copyright and license terms.  Block.one makes its contribution on a voluntary basis as a member of the EOSIO community and is not responsible for ensuring the overall performance of the software or any related applications.  We make no representation, warranty, guarantee or undertaking in respect of the software or any related documentation, whether expressed or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall we be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or documentation or the use or other dealings in the software or documentation. Any test results or performance figures are indicative and will not reflect performance under all conditions.  Any reference to any third party or third-party product, service or other resource is not an endorsement or recommendation by Block.one.  We are not responsible, and disclaim any and all responsibility and liability, for your use of or reliance on any of these resources. Third-party resources may be updated, changed or terminated at any time, so the information here may be out of date or inaccurate.  Any person using or offering this software in connection with providing software, goods or services to third parties shall advise such third parties of these license terms, disclaimers and exclusions of liability.  Block.one, EOSIO, EOSIO Labs, EOS, the heptahedron and associated logos are trademarks of Block.one.

Wallets and related components are complex software that require the highest levels of security.  If incorrectly built or used, they may compromise users’ private keys and digital assets. Wallet applications and related components should undergo thorough security evaluations before being used.  Only experienced developers should work with this software.
