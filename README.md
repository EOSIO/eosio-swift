# EOSIO SDK for Swift Softkey Signature Provider

Using this framework, you can sign an `EosioTransactionRequest` using `K1` type private keys.

## Basic Usage

```
let signProvider = try? EosioSwiftSoftkeySignatureProvider(privateKeys: privateKeysArray)
let publicKeysArray = signProvider?.getAvailableKeys() // Returns the public keys.
```

To sign a `EosioTransaction`, you should first create an `EosioTransactionSignatureRequest` object and call `signTransaction(request:completion:)` function with the request:

```
let signRequest = createSignatureRequest()
signProvider.signTransaction(request: signRequest){ (response) in 
    ...
}
```

## Contents of the library

This library is an example implementation of `EosioSignatureProviderProtocol`. It implements the following methods:

* `signTransaction(request:completion:)` signs an `EosioTransaction`.
* `getAvailableKeys()` returns an array, containing the public keys associated with the private keys that the object is initialized with.


## Installation
It hasn't been decided if this library is going to be destributed as a `pod` with all other dependencies included. Or people would have to install other dependencies (like `eosio-swift-softkey-signature-provider`) separately and store them in the same folder.

## Contributing

[Contributing Guide](./CONTRIBUTING.md)

[Code of Conduct](./CONTRIBUTING.md#conduct)

## License

[MIT](./LICENSE)

## Important

See LICENSE for copyright and license terms.  Block.one makes its contribution on a voluntary basis as a member of the EOSIO community and is not responsible for ensuring the overall performance of the software or any related applications.  We make no representation, warranty, guarantee or undertaking in respect of the software or any related documentation, whether expressed or implied, including but not limited to the warranties or merchantability, fitness for a particular purpose and noninfringement. In no event shall we be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or documentation or the use or other dealings in the software or documentation.  Any test results or performance figures are indicative and will not reflect performance under all conditions.  Any reference to any third party or third-party product, service or other resource is not an endorsement or recommendation by Block.one.  We are not responsible, and disclaim any and all responsibility and liability, for your use of or reliance on any of these resources. Third-party resources may be updated, changed or terminated at any time, so the information here may be out of date or inaccurate.
