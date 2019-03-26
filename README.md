# EOSIO SDK for Swift Softkey Signature Provider

Using this Software Development Kit (SDK) you can sign transactions using `K1` type private key.

## Basic Usage
```
do{
    let signProvider = try EosioSwiftSoftkeySignatureProvider(privateKeys: ["K1privatKeyString"])
    let publicKey = try Data(eosioPublicKey:publicKeyString)
    let privateKey = try Data(eosioPrivateKey: privateKeyString)
    let serializedTransaction = "some transaction".data(using: .utf8)!
    let sig = try EosioEccSign.signWithK1(publicKey: publicKey, privateKey: privateKey, data: serializedTransaction)
    let recoveredPubKey = try recoverPublicKey(signature: sig, message: serializedTransaction)
    let signReq = createSignatureRequest(transactionString: "some transaction")
    
    signProvider.signTransaction(request: signReq) { (response) in
        let yourSignature = response.signedTransaction?.signatures.first
    }   
 }catch{}
```

## Contents of the library

Implementation of the following methods:

* `signatureProvider.signTransaction(request: signatureRequest)` signs transactions
* `signatureProvider.getAvailableKeys()` requests supporting app to share available public keys that could be used for signature


## Installation
It hasn't been decided if this library is going to be destributed as a `pod` with all other dependencies included. Or people would have to install other dependencies (like `eosio-swift-softkey-signature-provider`) separately and store them in the same folder.

## Contributing

[Contributing Guide](./CONTRIBUTING.md)

[Code of Conduct](./CONTRIBUTING.md#conduct)

## License

[MIT](./LICENSE)

## Important

See LICENSE for copyright and license terms.  Block.one makes its contribution on a voluntary basis as a member of the EOSIO community and is not responsible for ensuring the overall performance of the software or any related applications.  We make no representation, warranty, guarantee or undertaking in respect of the software or any related documentation, whether expressed or implied, including but not limited to the warranties or merchantability, fitness for a particular purpose and noninfringement. In no event shall we be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or documentation or the use or other dealings in the software or documentation.  Any test results or performance figures are indicative and will not reflect performance under all conditions.  Any reference to any third party or third-party product, service or other resource is not an endorsement or recommendation by Block.one.  We are not responsible, and disclaim any and all responsibility and liability, for your use of or reliance on any of these resources. Third-party resources may be updated, changed or terminated at any time, so the information here may be out of date or inaccurate.
