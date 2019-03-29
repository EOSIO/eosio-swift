//
//  EosioSwiftSoftkeySignatureProviderTests.swift
//  EosioSwiftSoftkeySignatureProviderTests
//
//  Created by Farid Rahmani on 3/14/19.
//  Copyright © 2019 Block.one. All rights reserved.
//

import XCTest
import EosioSwift
import EosioSwiftEcc
@testable import EosioSwiftSoftkeySignatureProvider

class EosioSwiftSoftkeySignatureProviderTests: XCTestCase {
    
    
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    let privateKeyString = "PVT_K1_5KVdxcnxCmcfAd5Vod3FBuHoXDjwgdSiQRzEow8qXsMZNEX8h9a"
    let publicKeyString = "PUB_K1_7dRrMFULdLCgfNkeMdn94Wr19G4pHN87tDekRzbkMDKXrmQBVu"
    func test_init_withValidPrivateKeys_shouldSucceed() {
        XCTAssertNoThrow(try EosioSwiftSoftkeySignatureProvider(privateKeys:[privateKeyString]))
    }
    
    func test_init_withInvalidPrivateKeys_shouldThrowAnError() {
        XCTAssertThrowsError(try EosioSwiftSoftkeySignatureProvider(privateKeys: ["no valid key", privateKeyString]))
    }
    
    func test_init_withUnsupportedPrivateKeys_shouldThrowAnError() {
        XCTAssertThrowsError(try EosioSwiftSoftkeySignatureProvider(privateKeys: ["5vK9n5mLcCXGfw3mhQ42ttedQNPksJ5GktnqBTrgvWuEMSbu3RL4"]))
    }
    
    func test_getAvailableKeys_shouldReturnCorrectPublicKeys() {
        guard let signProvider = try? EosioSwiftSoftkeySignatureProvider(privateKeys: [privateKeyString]) else {
            XCTFail()
            return
        }
        
        signProvider.getAvailableKeys { (response) in
            guard let keys = response.keys, keys.contains(self.publicKeyString) else{
                XCTFail()
                return
            }
        }
        
    }
    
    func test_signTransaction_shouldSetSignedTransactionPropertyInResponseObject() {
        let trRequest = createSignatureRequest(transactionString: "some transaction")
        do {
            let signProvider = try EosioSwiftSoftkeySignatureProvider(privateKeys: [privateKeyString])
            signProvider.signTransaction(request: trRequest) { (response) in
                XCTAssertNotNil(response.signedTransaction)
            }
        } catch {
            XCTFail()
        }
    }
    
    func test_signTransaction_shouldSignTransactionCorrectly() {
        
        do {
            let fakeChainId = "aa"
            let signProvider = try EosioSwiftSoftkeySignatureProvider(privateKeys: [privateKeyString])
            let serializedTransaction = "some transaction".data(using: .utf8)!
   
            var signReq = createSignatureRequest(transactionString: "some transaction")
            signReq.publicKeys = [publicKeyString]
            signReq.chainId = "aa"
            signProvider.signTransaction(request: signReq) { (response) in
                let signature = response.signedTransaction!.signatures.first!
                print(signature)
                let fakeChainIdData = try! Data(hex: fakeChainId)
                let zeros = Data(repeating: 0, count: 32)
                let publicKey = try! self.recoverPublicKey(signature: Data(eosioSignature: signature), message: fakeChainIdData + serializedTransaction + zeros)
                print(publicKey.compressedPublicKey!.toEosioK1PublicKey)
                XCTAssertEqual(self.publicKeyString, publicKey.compressedPublicKey!.toEosioK1PublicKey)
            }
            
            
        } catch {
            print(error.eosioError.reason)
            XCTFail()
        }
    }
    
    func recoverPublicKey(signature:Data, message:Data) throws -> Data {
        let derSig = EcdsaSignature(r: signature[1...32], s: signature[33...64]).der
        let recid = Int(signature[0] - 31)
        
        let recoveredPubKey = try EccRecoverKey.recoverPublicKey(signatureDer: derSig, message: message.sha256, recid: recid, curve: .k1)
        return recoveredPubKey
    }
    
    func createSignatureRequest(transactionString:String) -> EosioTransactionSignatureRequest {
        let serializedTransaction = transactionString.data(using: .utf8)!
        var transactionSignReq = EosioTransactionSignatureRequest()
        transactionSignReq.serializedTransaction = serializedTransaction
        return transactionSignReq
    }

    

}
