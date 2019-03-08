//
//  EosioSwiftAbieosTests.swift
//  EosioSwiftAbieosTests
//
//  Created by Steve McCoole on 11/6/18.
//  Copyright © 2018-2019 block.one.
//

import Foundation
import XCTest
import EosioSwiftAbieos
import EosioSwift

class EosioSwiftAbieosTests: XCTestCase {

    var abieos: AbiEos? = nil
    
    override func setUp() {
        abieos = AbiEos()
    }

    override func tearDown() {
        abieos = nil
    }

    func testJsonToHexManifest() {
        let json = """
            {"account":"todd","appmeta":"https://transfer.toddbowden.com/app-metadata.json#67d86954bc3ff7928a55df717b31b732c8ec48e00b2efffd6d493acc8413b7bb","hash":"","domain":"transfer.toddbowden.com","hex":"","whitelist":[{"contract":"eosio.token","action":"transfer"}]}
        """
        let hex = "00000000009012CD177472616E736665722E746F6464626F7764656E2E636F6D7268747470733A2F2F7472616E736665722E746F6464626F7764656E2E636F6D2F6170702D6D657461646174612E6A736F6E23363764383639353462633366663739323861353564663731376233316237333263386563343865303062326566666664366434393361636338343133623762620100A6823403EA3055000000572D3CCDCD"
        do {
            let result = try abieos?.jsonToHex(contract: nil, name: "", type: "manifest", json: json, abi: "eosio.assert.abi.json")
            XCTAssertTrue(hex == result)
        } catch {
            print(error)
            XCTFail()
        }
    }

    func testHexToJsonTransaction() {
        let hex = "1686755CA99DE8E73E12000000000100A6823403EA3055000000572D3CCDCD0100AEAA4AC15CFD4500000000A8ED32323B00AEAA4AC15CFD4500000060D234CD3DA06806000000000004454F53000000001A746865206772617373686F70706572206C69657320686561767900"

        let json = """
        {"expiration":"2019-02-26T18:31:50.000","ref_block_num":40361,"ref_block_prefix":306112488,"max_net_usage_words":0,"max_cpu_usage_ms":0,"delay_sec":0,"context_free_actions":[],"actions":[{"account":"eosio.token","name":"transfer","authorization":[{"actor":"cryptkeeper","permission":"active"}],"data":"00AEAA4AC15CFD4500000060D234CD3DA06806000000000004454F53000000001A746865206772617373686F70706572206C696573206865617679"}],"transaction_extensions":[]}
        """

        do {
            let result = try abieos?.hexToJson(contract: nil, name: "", type: "transaction", hex: hex, abi: "transaction.abi.json")
            XCTAssertTrue(json == result)
        } catch {
            XCTFail()
        }
    }

    func testHexToJsonRequire() {
        let hex = "CBDD956F52ACD910C3C958136D72F8560D1846BC7CF3157F5FBFB72D3001DE4597F4A1FDBECDA6D59C96A43009FC5E5D7B8F639B1269C77CEC718460DCC19CB30100A6823403EA3055000000572D3CCDCD0143864D5AF0FE294D44D19C612036CBE8C098414C4A12A5A7BB0BFE7DB1556248"

        let json = """
        {"chain_params_hash":"CBDD956F52ACD910C3C958136D72F8560D1846BC7CF3157F5FBFB72D3001DE45","manifest_id":"97F4A1FDBECDA6D59C96A43009FC5E5D7B8F639B1269C77CEC718460DCC19CB3","actions":[{"contract":"eosio.token","action":"transfer"}],"abi_hashes":["43864D5AF0FE294D44D19C612036CBE8C098414C4A12A5A7BB0BFE7DB1556248"]}
        """

        do {
            let result = try abieos?.hexToJson(contract: "eosio.assert", name: "", type: "require", hex: hex, abi: "eosio.assert.abi.json")
            XCTAssertTrue(json == result)
        } catch {
            XCTFail()
        }
    }

    func testJsonToHexRequire() {
        let json = """
            {"manifest_id":"97f4a1fdbecda6d59c96a43009fc5e5d7b8f639b1269c77cec718460dcc19cb3","actions":[{"contract":"eosio.token","action":"transfer"}],"chain_params_hash":"cbdd956f52acd910c3c958136d72f8560d1846bc7cf3157f5fbfb72d3001de45","abi_hashes":["43864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248"]}
        """
        let hex = "CBDD956F52ACD910C3C958136D72F8560D1846BC7CF3157F5FBFB72D3001DE4597F4A1FDBECDA6D59C96A43009FC5E5D7B8F639B1269C77CEC718460DCC19CB30100A6823403EA3055000000572D3CCDCD0143864D5AF0FE294D44D19C612036CBE8C098414C4A12A5A7BB0BFE7DB1556248"
        do {
            let result = try abieos?.jsonToHex(contract: "eosio.assert", name: "", type: "require", json: json, abi: "eosio.assert.abi.json")
            XCTAssertTrue(hex == result)
        } catch {
            print(error)
            XCTFail()
        }
    }


    
    func testHexToJsonAbi() {
        let hex = "0e656f73696f3a3a6162692f312e30010c6163636f756e745f6e616d65046e616d6505087472616e7366657200040466726f6d0c6163636f756e745f6e616d6502746f0c6163636f756e745f6e616d65087175616e74697479056173736574046d656d6f06737472696e67066372656174650002066973737565720c6163636f756e745f6e616d650e6d6178696d756d5f737570706c79056173736574056973737565000302746f0c6163636f756e745f6e616d65087175616e74697479056173736574046d656d6f06737472696e67076163636f756e7400010762616c616e63650561737365740e63757272656e63795f7374617473000306737570706c790561737365740a6d61785f737570706c79056173736574066973737565720c6163636f756e745f6e616d6503000000572d3ccdcd087472616e73666572bc072d2d2d0a7469746c653a20546f6b656e205472616e736665720a73756d6d6172793a205472616e7366657220746f6b656e732066726f6d206f6e65206163636f756e7420746f20616e6f746865722e0a69636f6e3a2068747470733a2f2f63646e2e746573746e65742e6465762e62316f70732e6e65742f746f6b656e2d7472616e736665722e706e6723636535316566396639656563613334333465383535303765306564343965373666666631323635343232626465643032353566333139366561353963386230630a2d2d2d0a0a2323205472616e73666572205465726d73202620436f6e646974696f6e730a0a492c207b7b66726f6d7d7d2c20636572746966792074686520666f6c6c6f77696e6720746f206265207472756520746f207468652062657374206f66206d79206b6e6f776c656467653a0a0a312e204920636572746966792074686174207b7b7175616e746974797d7d206973206e6f74207468652070726f6365656473206f66206672617564756c656e74206f722076696f6c656e7420616374697669746965732e0a322e2049206365727469667920746861742c20746f207468652062657374206f66206d79206b6e6f776c656467652c207b7b746f7d7d206973206e6f7420737570706f7274696e6720696e6974696174696f6e206f662076696f6c656e636520616761696e7374206f74686572732e0a332e2049206861766520646973636c6f73656420616e7920636f6e747261637475616c207465726d73202620636f6e646974696f6e732077697468207265737065637420746f207b7b7175616e746974797d7d20746f207b7b746f7d7d2e0a0a4920756e6465727374616e6420746861742066756e6473207472616e736665727320617265206e6f742072657665727369626c6520616674657220746865207b7b247472616e73616374696f6e2e64656c61795f7365637d7d207365636f6e6473206f72206f746865722064656c617920617320636f6e66696775726564206279207b7b66726f6d7d7d2773207065726d697373696f6e732e0a0a4966207468697320616374696f6e206661696c7320746f20626520697272657665727369626c7920636f6e6669726d656420616674657220726563656976696e6720676f6f6473206f722073657276696365732066726f6d20277b7b746f7d7d272c204920616772656520746f206569746865722072657475726e2074686520676f6f6473206f72207365727669636573206f7220726573656e64207b7b7175616e746974797d7d20696e20612074696d656c79206d616e6e65722e0000000000a531760569737375650000000000a86cd445066372656174650002000000384f4d113203693634010863757272656e6379010675696e743634076163636f756e740000000000904dc603693634010863757272656e6379010675696e7436340e63757272656e63795f737461747300000000"
        let json = """
        {"version":"eosio::abi/1.0","types":[{"new_type_name":"account_name","type":"name"}],"structs":[{"name":"transfer","base":"","fields":[{"name":"from","type":"account_name"},{"name":"to","type":"account_name"},{"name":"quantity","type":"asset"},{"name":"memo","type":"string"}]},{"name":"create","base":"","fields":[{"name":"issuer","type":"account_name"},{"name":"maximum_supply","type":"asset"}]},{"name":"issue","base":"","fields":[{"name":"to","type":"account_name"},{"name":"quantity","type":"asset"},{"name":"memo","type":"string"}]},{"name":"account","base":"","fields":[{"name":"balance","type":"asset"}]},{"name":"currency_stats","base":"","fields":[{"name":"supply","type":"asset"},{"name":"max_supply","type":"asset"},{"name":"issuer","type":"account_name"}]}],"actions":[{"name":"transfer","type":"transfer","ricardian_contract":"---\ntitle: Token Transfer\nsummary: Transfer tokens from one account to another.\nicon: https://cdn.testnet.dev.b1ops.net/token-transfer.png#ce51ef9f9eeca3434e85507e0ed49e76fff1265422bded0255f3196ea59c8b0c\n---\n\n## Transfer Terms & Conditions\n\nI, {{from}}, certify the following to be true to the best of my knowledge:\n\n1. I certify that {{quantity}} is not the proceeds of fraudulent or violent activities.\n2. I certify that, to the best of my knowledge, {{to}} is not supporting initiation of violence against others.\n3. I have disclosed any contractual terms & conditions with respect to {{quantity}} to {{to}}.\n\nI understand that funds transfers are not reversible after the {{$transaction.delay_sec}} seconds or other delay as configured by {{from}}'s permissions.\n\nIf this action fails to be irreversibly confirmed after receiving goods or services from '{{to}}', I agree to either return the goods or services or resend {{quantity}} in a timely manner."},{"name":"issue","type":"issue","ricardian_contract":""},{"name":"create","type":"create","ricardian_contract":""}],"tables":[{"name":"accounts","index_type":"i64","key_names":["currency"],"key_types":["uint64"],"type":"account"},{"name":"stat","index_type":"i64","key_names":["currency"],"key_types":["uint64"],"type":"currency_stats"}],"ricardian_clauses":[],"error_messages":[],"abi_extensions":[],"variants":[]}
        """
        do {
            let result = try abieos?.hexToJson(contract: nil, name: "", type: "abi_def", hex: hex, abi: "abi.abi.json")
            XCTAssertTrue(json.replacingOccurrences(of: "\n", with: "\\n") == result)
        } catch {
            print(error)
            XCTFail()
        }
    }

    func testJsonToHex_chain_params() {
        let json = """
        {"chain_id":"687fa513e18843ad3e820744f4ffcf93b1354036d80737db8dc444fe4b15ad17","chain_name":"b1 Testnet","icon":"4720078c233754482699678cbf8e75b0b671596f794904a5a788515517f04ee3"}
        """
        let hex = "687FA513E18843AD3E820744F4FFCF93B1354036D80737DB8DC444FE4B15AD170A623120546573746E65744720078C233754482699678CBF8E75B0B671596F794904A5A788515517F04EE3"
        do {
            let resut = try abieos?.jsonToHex(contract: nil, name: "", type: "chain_params", json: json, abi: "eosio.assert.abi.json")
            XCTAssertTrue(hex == resut)
        } catch {
            print(error)
            XCTFail()
        }
    }

    func testJsonToHexTransaction() {
        let json = """
        {
        "expiration" : "2019-02-26T18:31:50.000",
        "ref_block_num" : 40361,
        "ref_block_prefix" : 306112488,
        "max_net_usage_words" : 0,
        "max_cpu_usage_ms" : 0,
        "delay_sec" : 0,
        "context_free_actions" : [],
        "actions" : [
        {
        "account" : "eosio.assert",
        "name" : "require",
        "authorization" : [],
        "data" : "CBDD956F52ACD910C3C958136D72F8560D1846BC7CF3157F5FBFB72D3001DE4597F4A1FDBECDA6D59C96A43009FC5E5D7B8F639B1269C77CEC718460DCC19CB30100A6823403EA3055000000572D3CCDCD0143864D5AF0FE294D44D19C612036CBE8C098414C4A12A5A7BB0BFE7DB1556248"
        },
        {
        "account" : "eosio.token",
        "name" : "transfer",
        "authorization" : [
        {
        "actor" : "cryptkeeper",
        "permission" : "active"
        }
        ],
        "data" : "00AEAA4AC15CFD4500000060D234CD3DA06806000000000004454F53000000001A746865206772617373686F70706572206C696573206865617679"
        }
        ]
        ,
        "transaction_extensions" : []}
        """
        let hex = "1686755CA99DE8E73E12000000000290AFC2D800EA3055000000405DA7ADBA0072CBDD956F52ACD910C3C958136D72F8560D1846BC7CF3157F5FBFB72D3001DE4597F4A1FDBECDA6D59C96A43009FC5E5D7B8F639B1269C77CEC718460DCC19CB30100A6823403EA3055000000572D3CCDCD0143864D5AF0FE294D44D19C612036CBE8C098414C4A12A5A7BB0BFE7DB155624800A6823403EA3055000000572D3CCDCD0100AEAA4AC15CFD4500000000A8ED32323B00AEAA4AC15CFD4500000060D234CD3DA06806000000000004454F53000000001A746865206772617373686F70706572206C69657320686561767900"
        do {
            let resut = try abieos?.jsonToHex(contract: nil, name: "", type: "transaction", json: json, abi: "transaction.abi.json")
            XCTAssertTrue(hex == resut)
        } catch {
            print(error)
            XCTFail()
        }
    }
}
