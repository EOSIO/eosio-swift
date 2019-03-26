# EOSIO SDK for Swift ![EOSIO Alpha](https://img.shields.io/badge/EOSIO-Alpha-blue.svg)

[![Software License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/EOSIO/eosio-swift/blob/master/LICENSE)
[![Swift 4.2](https://img.shields.io/badge/Language-Swift_4.2-orange.svg)](https://swift.org)
![](https://img.shields.io/badge/Deployment%20Target-iOS%2012-blue.svg)

This library is a required dependency and contains fundamental classes that power following libraries:

* [Softkey Signature Provider](https://github.com/EOSIO/eosio-swift-softkey-signature-provider) (sign transactions)
* [ABIEOS Serialization Provider](https://github.com/EOSIO/eosio-swift-abieos-serialization-provider) (broadcast to blockchain)
* [Vault](https://github.com/EOSIO) (Manage keys)


## Basic Usage

To communicate with blockchain you need to build a `transaction` class instance. It has 3 necessary components:

* `RPCProvider` (communicate with `nodeos`)
* `serializationProvider` (convert `JSON` to `binary` and vice-versa)
* `signatureProvider` (add a signature)

```
var transaction = EosioTransaction()

transaction.rpcProvider = yourRPCProvider
transaction.serializationProvider = yourSerializationProvider
transaction.signatureProvider = yourSignatureProvider

// then you call
transaction.signAndBroadcast()

```

To learn how to use the library refer to [Example App](https://github.com/EOSIO/eosio-reference-ios-authenticator-app).

## Contents of the library

`Transaction class`

* creates, signs and broadcasts transactions

`Remote Procedure Call (RPC) provider`

* communicates with `nodeos` (aka blockchain endpoint) with convenient methods

`EosioAbiProvider`

* wraps `Remote Procedure Call (RPC) provider` with convenience methods

As well the following: `EosioAbiProviderProtocol`, `EosioRpcProviderProtocol`, `EosioSerializationProviderProtocol` and  `EosioSignatureProviderProtocol`

## Installation
It hasn't been decided if this library is going to be destributed as a `pod` with all other dependencies included. Or people would have to install other dependencies (like `eosio-swift-softkey-signature-provider`) separately and store them in the same folder.

## Want to contribute?
Here are [Contribution Guidelines](https://github.com/EOSIO/eosio-swift/blob/master/CONTRIBUTING.md) and [Code of Conduct](./CONTRIBUTING.md#conduct)

## License
[MIT](https://github.com/EOSIO/eosio-swift/blob/master/LICENSE)


## Important

See LICENSE for copyright and license terms.  Block.one makes its contribution on a voluntary basis as a member of the EOSIO community and is not responsible for ensuring the overall performance of the software or any related applications.  We make no representation, warranty, guarantee or undertaking in respect of the software or any related documentation, whether expressed or implied, including but not limited to the warranties or merchantability, fitness for a particular purpose and noninfringement. In no event shall we be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or documentation or the use or other dealings in the software or documentation.  Any test results or performance figures are indicative and will not reflect performance under all conditions.  Any reference to any third party or third-party product, service or other resource is not an endorsement or recommendation by Block.one.  We are not responsible, and disclaim any and all responsibility and liability, for your use of or reliance on any of these resources. Third-party resources may be updated, changed or terminated at any time, so the information here may be out of date or inaccurate.
