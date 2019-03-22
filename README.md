# EOSIO SDK for Swift ABIEOS Serialization Provider
[![Software License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/EOSIO/eosio-swift/blob/master/LICENSE)
![Lagnuage C++/Swift](https://img.shields.io/badge/Language-C%2B%2B%2FSwift-yellow.svg)
![](https://img.shields.io/badge/Deployment%20Target-iOS%2012-blue.svg)

EOSIO blockchain stores data in binary format only. This library allows you to convert JSON to Binary (and vice-versa). 

## Basic Usage

```
let abieos: AbiEos? = AbiEos()
let hex = "1686755CA99DE8E73E1200" // some binary data
let json = "{"name": "John"}" // some JSON

let jsonToBinaryTransaction = try? abieos?.serializeTransaction(json: json)
let binaryToJsonTransaction = try? abieos?.deserializeTransaction(hex: hex)
```


## Contents of the library

A Framework that encapsulates all of the C and C++ code for binary <-> JSON conversion using ABIs. Compatible with languages which can interface to C.

## Installation

This project now can be used as a cocoapod.  

OpenSSL is pulled in as a Pod dependancy using GRKOpenSSLFramework cocoapod.

A physical framework folder is now incorporated into the project. 

To build this project, you must do a `pod install`, then open the created workspace and build the framework there to confirm that it will compile and create a framework binary.

If you are using Xcode 10 and seeing some warnings when running pod install, it may be necessary to run: `gem update xcodeproj`

## Contributing

[Contributing Guide](./CONTRIBUTING.md)

[Code of Conduct](./CONTRIBUTING.md#conduct)

## License

[MIT](./LICENSE)

## Important

See LICENSE for copyright and license terms.  Block.one makes its contribution on a voluntary basis as a member of the EOSIO community and is not responsible for ensuring the overall performance of the software or any related applications.  We make no representation, warranty, guarantee or undertaking in respect of the software or any related documentation, whether expressed or implied, including but not limited to the warranties or merchantability, fitness for a particular purpose and noninfringement. In no event shall we be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or documentation or the use or other dealings in the software or documentation.  Any test results or performance figures are indicative and will not reflect performance under all conditions.  Any reference to any third party or third-party product, service or other resource is not an endorsement or recommendation by Block.one.  We are not responsible, and disclaim any and all responsibility and liability, for your use of or reliance on any of these resources. Third-party resources may be updated, changed or terminated at any time, so the information here may be out of date or inaccurate.
