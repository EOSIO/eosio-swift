# EOSIO SDK for Swift Examples

EOSIO SDK for Swift contains an exenstive set of functionality beyond the basics required for transactions.  The code snippets below show how to use some of this extended functionality.  It is important to note that these are simply example snippets and may not work the way you expect if you just copy and paste them into a method.  One common mistake is to allow the transaction or one of the providers to go out of scope, resulting in an error in the return closure when the server replies to the transaction request.  If you are seeing "self does not exist" errors when trying to send transactions or RPC calls, check to make sure that your objects are being held properly.

## Basic Transaction Examples

### Submiting a Transaction

Basic submission of a transaction is shown in the main [README.md](README.md) file at the top level of the repository.  Please see the [Basic Usage](README.md/#basic-usage) example for details.

### How to Transfer an EOSIO Token

The [Basic Usage](README.md/#basic-usage) example in the top level [README.md](README.md) file is an example of transferring an EOSIO token.  Please see that example for details.

## Extended Transaction Examples

### Retrieving Action Return Values From Transactions

This snippets calls a transaction that returns a 32-bit integer value.  The user is required to know the correct type that the action returns in order to cast successfully.  Each action will contain its return value, if the server provided one.

```
let url = URL(string: "https://my.example.blockchain")!
rpcProvider = EosioRpcProvider(endpoint: url)
transaction.rpcProvider = rpcProvider
transaction.serializationProvider = EosioAbieosSerializationProvider()
transaction.signatureProvider = try EosioSoftkeySignatureProvider(privateKeys: ["YourPrivateKey"])

let action = try EosioTransaction.Action(
    account: EosioName("returnvalue"),
    name: EosioName("actionresret"),
    authorization: [EosioTransaction.Action.Authorization(
        actor: EosioName("bob"),
        permission: EosioName("active"))
    ],
    data: [String: Any]()
)
transaction.add(action: action)

transaction.signAndBroadcast { result in
    switch result {
    case .success:
        print("Transaction successful, action return value is: \(String(describing: action.returnValue))")
        let returnValue = action.returnValue as? Int32
    case .failure(let error):
        print("Transaction failed, error: \(error)")
    }
}
```

### Accessing Extended Fields in Transaction Responses

Using `EosioTransaction.signAndBroadcast()` provides an easy way to sign and submit transactions but has a limited amount of information that it returns.  If you need to get additional information back from the blockchain, you must use `sendTransactionBase()` from [`EosioRpcProvider`](Sources/EosioSwift/EosioRpcProvider/EosioRpcProvider.swift) to submit the transaction after it is signed.  The process is much the same as a normal flow but instead of calling `signAndBroadcast()`,  use `sign()` instead and load the results into a `EosioRpcSendTransactionRequest` to be sent to the blockchain.  Afterward, the full response is available and can be decoded.  A small subset of fields are shown in the example below.  

```
transaction = EosioTransaction()
let url = URL(string: "https://my.test.blockchain")!
rpcProvider = EosioRpcProvider(endpoint: url)
transaction.rpcProvider = rpcProvider
transaction.serializationProvider = EosioAbieosSerializationProvider()

do {
    transaction.signatureProvider = try EosioSoftkeySignatureProvider(privateKeys: ["MyTestKey"])
    let action = try EosioTransaction.Action(
        account: EosioName("eosio.token"),
        name: EosioName("transfer"),
        authorization: [EosioTransaction.Action.Authorization(
                            actor: EosioName("bob"),
                            permission: EosioName("active"))
        ],
        data: Transfer(from: EosioName("bob"),
                       to: EosioName("alice"),
                       quantity: "42.0000 SYS",
                       memo: "This is only a test")
    )
    transaction.add(action: action)
    

    transaction.sign { result in
        switch result {
        case .success:
            guard let serializedTransaction = self.transaction.serializedTransaction?.hexEncodedString(),
                  let signatures = self.transaction.signatures else {
                print("Error, could not find signatures or serialized transaction.")
                return
            }
            
            let requestParameters = EosioRpcSendTransactionRequest(signatures: signatures,
                                                                   compression: 0,
                                                                   packedContextFreeData: "",
                                                                   packedTrx: serializedTransaction)
            
            self.rpcProvider.sendTransactionBase(requestParameters: requestParameters) { response in
                switch response {
                case .success(let sentResponse):
                    let transactionId = sentResponse.transactionId
                    if let sentTransactionResponse = sentResponse as? EosioRpcTransactionResponse {
                        if let processed = sentTransactionResponse.processed as [String: Any]?,
                           let receipt = processed["receipt"] as? [String: Any],
                           let status = receipt["status"] as? String {
                            // Work with values
                        } else {
                            print("Should be able to find processed.receipt.status.")
                        }
                    } else {
                        print("Concrete response type should be EosioRpcTransactionResponse.")
                    }
                case .failure(let err):
                    print("\(err.description)")
                }
            }
        case .failure(let error):
            print("Transaction failed, error: \(error)")
        }
    }
    
} catch (let error) {
    print("Handle this error: \(error.localizedDescription)")
}
```

## Extended RPC Call Examples

### Get Account Information

This snippet retrieves information for an account on the blockchain.  There are several layers of response to unpack if all information is desired.  Some portions of the response are not fully unmarshalled, either due to size or because the responses can vary in structure.  These are returned as general `[String: Any]` Swift objects.  The [NODEOS Reference](https://developers.eos.io/eosio-nodeos/reference) is helpful for decoding the parts of responses that are not fully unmarshalled.  

```
let url = URL(string: "https://my.example.blockchain")!
rpcProvider = EosioRpcProvider(endpoint: url)

let requestParameters = EosioRpcAccountRequest(accountName: "cryptkeeper")
rpcProvider.getAccount(requestParameters: requestParameters) { response in
    switch response {
    case .success(let eosioRpcAccountResponse):
        guard let response = eosioRpcAccountResponse else { 
            // Handle condition
            return 
        }
        let accountname = response.accountName
        let ramQuota = response.ramQuota.value
    
        guard let permissions = response.permissions else {
            // Handle Condition
            return
        }
        guard let activePermission = permissions.filter({$0.permName == "active"}).first else {
            print("Cannot find Active permission in permissions structure of the account")
            return
        }
        guard activePermission.parent == "owner" else {
            print("Active Key does not have proper parent.")
            return
        }
        guard let keysAndWeight = activePermission.requiredAuth.keys.first else {
            print("Cannot find key in keys structure of the account")
            return
        }
        let key = keysAndWeight.key
        guard let firstPermission = activePermission.requiredAuth.accounts.first else {
            print("Can't find permission in keys structure of the account")
            return
        }
        let actor = firstPermission.permission.actor
        let permission = firstPermission.permission.permission
        let waitSec = activePermission.requiredAuth.waits.first?.waitSec.value
        guard let dict = eosioRpcAccountResponse.totalResources as? [String: Any] else {
            print("Could not find total resources as [String: Any].")
            return
        }
        let owner = dict["owner"] as? String
        let rambytes = dict["ram_bytes"] as? UInt64

    case .failure(let err):
        print(err.description)
        XCTFail("Failed get_account")
    }
    expect.fulfill()
}
```

### Getting Transaction Information From the History Plugin

This snippet returns information on a transaction from the History API plugin.  Only a few fields are shown in the decoding example below.  The [NODEOS Reference](https://developers.eos.io/eosio-nodeos/reference) is helpful for decoding the parts of responses that are not fully unmarshalled.  

```
let url = URL(string: "https://my.test.blockchain")!
rpcProvider = EosioRpcProvider(endpoint: url)

let requestParameters = EosioRpcHistoryTransactionRequest(transactionId: "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a", blockNumHint: 21098575)
rpcProvider.getTransaction(requestParameters: requestParameters) { response in
    switch response {
    case .success(let eosioRpcGetTransactionResponse):
        let returnedId = eosioRpcGetTransactionResponse.id
        let returnedBlockNum = eosioRpcGetTransactionResponse.blockNum.value
        guard let dict = eosioRpcGetTransactionResponse.trx["trx"] as? [String: Any] else {
            print("Should find trx.trx dictionary.")
            return
        }
        if let refBlockNum = dict["ref_block_num"] as? UInt64 {
            print(refBlockNum)
        } else {
            XCTFail("Should find trx ref_block_num.")
        }
        if let signatures = dict["signatures"] as? [String] {
            print(signatures[0])
        } else {
            print("Should find trx signatures and it should match.")
        }
    case .failure(let err):
        print("Failed get_transaction call: \(err.description)")
    }
}
```

### Retrieving Values from KV Tables

This snippet retrieves values from a KV table defined by a contract on the server.  The example below is requesting the values from the contract "todo" in the table named "todo".  It is querying the index named "uuid" for the value "bf581bee-9f2c-447b-94ad-78e4984b6f51".  The encoding type of the indexValue being supplied is ".string".  Other supported encoding types can be found in the full documenation in this repo at  `docs/EosioSwift/index.html`.

```
let url = URL(string: "https://my.example.blockchain")!
rpcProvider = EosioRpcProvider(endpoint: url)

let tablesRequest = EosioRpcKvTableRowsRequest(code: "todo",
                                               table: "todo",
                                               indexName: "uuid",
                                               encodeType: .string,
                                               json: true,
                                               indexValue: "bf581bee-9f2c-447b-94ad-78e4984b6f51")

rpcProvider.getKvTableRows(requestParameters: tablesRequest) { result in
    switch result {
    case .failure(let error):
        print("Failed getKvTableRows call: \(error.localizedDescription)")
    case .success(let response):
        // Iterate through rows.  They will either be serialied strings if json equaled false
        // or they will be [String: Any] representations of the returned JSON objects if 
        // json equaled true in the request.
        response.rows.foreach { row in
            // Work with each row.
        }
    }
}
```
