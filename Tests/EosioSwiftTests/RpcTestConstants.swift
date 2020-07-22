//
//  RpcTestConstants.swift
//  EosioSwiftTests
//
//  Created by Ben Martell on 4/12/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation
import EosioSwift
import OHHTTPStubs

// swiftlint:disable line_length
public class RpcTestConstants {
    public static func getInfoOHHTTPStubsResponse() -> OHHTTPStubsResponse {
        return RpcTestConstants.getOHHTTPStubsResponseForJson(json: RpcTestConstants.infoResponseJson)
    }

    public static func getErrorOHHTTPStubsResponse(code: Int = NSURLErrorBadURL, reason: String?) -> OHHTTPStubsResponse {
        guard let message = reason else {
            let error = NSError(domain: NSURLErrorDomain, code: code, userInfo: nil)
            return OHHTTPStubsResponse(error: error)
        }
        let error = NSError(domain: NSURLErrorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
        return OHHTTPStubsResponse(error: error)
    }

    public static func getOHHTTPStubsResponseForJson(json: String, unhappy: Bool = false) -> OHHTTPStubsResponse {
        let data = json.data(using: .utf8)
        return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
    }

    /*
        Test helpers to DRY out test logic: This is for funcs in Rpc Provider that make a first call to getInfo to obtain chain info for subsequent call under test
    */
    public static func getHHTTPStubsResponse(callCount: Int, urlRelativePath: String?) -> OHHTTPStubsResponse {
        return RpcTestConstants.getHHTTPStubsResponse(callCount: callCount, urlRelativePath: urlRelativePath, name: nil)
    }

    public static func getHHTTPStubsResponse(callCount: Int, urlRelativePath: String?, unhappy: Bool) -> OHHTTPStubsResponse {
        return RpcTestConstants.getHHTTPStubsResponse(callCount: callCount, urlRelativePath: urlRelativePath, name: nil, unhappy: unhappy)
    }

    // swiftlint:disable function_body_length
    // swiftlint:disable cyclomatic_complexity
    public static func getHHTTPStubsResponse(callCount: Int, urlRelativePath: String?, name: EosioName?, unhappy: Bool = false) -> OHHTTPStubsResponse {
        guard urlRelativePath != nil else {
            return RpcTestConstants.getErrorOHHTTPStubsResponse(reason: "No urlRelativePath string available on request!")
        }
        if callCount == 1 && urlRelativePath == "/v1/chain/get_info" {
            return RpcTestConstants.getInfoOHHTTPStubsResponse()
        } else if callCount == 2 {
            switch urlRelativePath {
            case "/v1/chain/get_block" :
                return getOHHTTPStubsResponseForJson(json: RpcTestConstants.blockResponseJson, unhappy: unhappy)
            case "/v1/chain/get_block_header_state" :
                return getOHHTTPStubsResponseForJson(json: RpcTestConstants.blockHeaderStateJson, unhappy: unhappy)
            case "/v1/chain/get_raw_abi" :
                guard let eosioName = name else {
                    return RpcTestConstants.getErrorOHHTTPStubsResponse(reason: "EosioName missing for call to get_raw_abi stub")
                }
                guard let json = RpcTestConstants.createRawApiResponseJson(account: eosioName) else {
                    return RpcTestConstants.getErrorOHHTTPStubsResponse(code: NSURLErrorUnknown, reason: "Failed to create json in createRawApiResponseJson(account: EosioName)")
                }
                return getOHHTTPStubsResponseForJson(json: json, unhappy: unhappy)
            case "/v1/chain/get_required_keys" :
                return getOHHTTPStubsResponseForJson(json: RpcTestConstants.requiredKeysResponseJson, unhappy: unhappy)
            case  "/v1/chain/push_transaction"  :
                return getOHHTTPStubsResponseForJson(json: RpcTestConstants.pushTransActionResponseJson, unhappy: unhappy)
            case "/v1/chain/push_transactions" :
                return getOHHTTPStubsResponseForJson(json: RpcTestConstants.pushTransactionsJson, unhappy: unhappy)
            case "/v1/chain/get_abi" :
                return getOHHTTPStubsResponseForJson(json: RpcTestConstants.abiJson, unhappy: unhappy)
            case "/v1/chain/get_account" :
                return getOHHTTPStubsResponseForJson(json: RpcTestConstants.accountJson, unhappy: unhappy)
            case  "/v1/chain/get_currency_balance" :
                return getOHHTTPStubsResponseForJson(json: RpcTestConstants.currencyBalanceJson, unhappy: unhappy)
            case  "/v1/chain/get_currency_stats" :
                return getOHHTTPStubsResponseForJson(json: RpcTestConstants.currencyStats, unhappy: unhappy)
            case "/v1/chain/get_raw_code_and_abi" :
                return getOHHTTPStubsResponseForJson(json: RpcTestConstants.rawCodeAndAbiJson, unhappy: unhappy)
            case "/v1/chain/get_code" :
                return RpcTestConstants.getOHHTTPStubsResponseForJson(json: RpcTestConstants.codeJson, unhappy: unhappy)
            case "/v1/chain/get_table_rows" :
                return RpcTestConstants.getOHHTTPStubsResponseForJson(json: RpcTestConstants.tableRowsJson, unhappy: unhappy)
            case "/v1/chain/get_table_by_scope" :
                return RpcTestConstants.getOHHTTPStubsResponseForJson(json: RpcTestConstants.tableScopeJson, unhappy: unhappy)
            case "/v1/chain/get_producers" :
                return RpcTestConstants.getOHHTTPStubsResponseForJson(json: RpcTestConstants.producersJson, unhappy: unhappy)
            case  "/v1/history/get_actions" :
                return RpcTestConstants.getOHHTTPStubsResponseForJson(json: RpcTestConstants.actionsJson, unhappy: unhappy)
            case "/v1/history/get_controlled_accounts" :
                return RpcTestConstants.getOHHTTPStubsResponseForJson(json: RpcTestConstants.controlledAccountsJson, unhappy: unhappy)
            case "/v1/history/get_transaction" :
                return RpcTestConstants.getOHHTTPStubsResponseForJson(json: RpcTestConstants.transactionJson, unhappy: unhappy)
            case "/v1/history/get_key_accounts" :
                return RpcTestConstants.getOHHTTPStubsResponseForJson(json: RpcTestConstants.keyAccountsJson, unhappy: unhappy)
            case "/v1/chain/send_transaction":
                return RpcTestConstants.getOHHTTPStubsResponseForJson(json: RpcTestConstants.sendTransActionResponseJson, unhappy: unhappy)
            default :
                return RpcTestConstants.getErrorOHHTTPStubsResponse(reason: "Unexpected relative path passed to stub: \(String(describing: urlRelativePath))")
            }
        } else {
            if callCount > 2 {
                return RpcTestConstants.getErrorOHHTTPStubsResponse(code: NSURLErrorUnknown, reason: "Unexpected callcount in stub. call count: \(callCount)")
            } else {
                return RpcTestConstants.getErrorOHHTTPStubsResponse(code: NSURLErrorUnknown, reason: "First call was not to /v1/chain/get_info. \(String(describing: urlRelativePath))")
            }
        }
    }

    // swiftlint:enable cyclomatic_complexity
    // swiftlint:enable function_body_length
    public static let infoResponseJson = """
    {
    "server_version": "0f6695cb",
    "chain_id": "687fa513e18843ad3e820744f4ffcf93b1354036d80737db8dc444fe4b15ad17",
    "head_block_num": 25260035,
    "last_irreversible_block_num": 25259987,
    "last_irreversible_block_id": "01816fd3f7f35fd7d60c72b522772541fad71ce310c5f5cd434c41a17d2ad3b8",
    "head_block_id": "01817003aecb618966706f2bca7e8525d814e873b5db9a95c57ad248d10d3c05",
    "head_block_time": "2019-02-21T18:31:41.500",
    "head_block_producer": "blkproducer2",
    "virtual_block_cpu_limit": 200000000,
    "virtual_block_net_limit": 1048576000,
    "block_cpu_limit": 199900,
    "block_net_limit": 1048576,
    "server_version_string": "v1.3.0"
    }
    """

    public static let infoResponseBadChainIdJson = """
    {
    "server_version": "0f6695cb",
    "chain_id": "a_bad_chain_id",
    "head_block_num": 25260035,
    "last_irreversible_block_num": 25259987,
    "last_irreversible_block_id": "01816fd3f7f35fd7d60c72b522772541fad71ce310c5f5cd434c41a17d2ad3b8",
    "head_block_id": "01817003aecb618966706f2bca7e8525d814e873b5db9a95c57ad248d10d3c05",
    "head_block_time": "2019-02-21T18:31:41.500",
    "head_block_producer": "blkproducer2",
    "virtual_block_cpu_limit": 200000000,
    "virtual_block_net_limit": 1048576000,
    "block_cpu_limit": 199900,
    "block_net_limit": 1048576,
    "server_version_string": "v1.3.0"
    }
    """

    public static let infoResponseEndpoint2Json = """
    {
    "server_version": "0f6695cb",
    "chain_id": "687fa513e188wre3e820744f4ffcf93b1354036d80737db8dc444fe4b15ad17",
    "head_block_num": 25260035,
    "last_irreversible_block_num": 25259987,
    "last_irreversible_block_id": "01816fd3f7f35fd7d60c72b522772541fad71ce310c5f5cd434c41a17d2ad3b8",
    "head_block_id": "01817003aecb618966706f2bca7e8525d814e873b5db9a95c57ad248d10d3c05",
    "head_block_time": "2019-02-21T18:31:41.500",
    "head_block_producer": "blkproducer2",
    "virtual_block_cpu_limit": 200000000,
    "virtual_block_net_limit": 1048576000,
    "block_cpu_limit": 199900,
    "block_net_limit": 1048576,
    "server_version_string": "v1.3.0"
    }
    """

    public static let infoResponseEndpoint3Json = """
    {
    "server_version": "0f6695cb",
    "chain_id": "687fa513e18843ad3e820744f4ffcf93b1354036d80737db8dc444fe4b15ad17",
    "head_block_num": 25260039,
    "last_irreversible_block_num": 25259987,
    "last_irreversible_block_id": "01816fd3f7f35fd7d60c72b522772541fad71ce310c5f5cd434c41a17d2ad3b8",
    "head_block_id": "01817003aecb618966706f2bca7e8525d814e873b5db9a95c57ad248d10d3c05",
    "head_block_time": "2019-02-21T18:31:41.500",
    "head_block_producer": "blkproducer2",
    "virtual_block_cpu_limit": 200000000,
    "virtual_block_net_limit": 1048576000,
    "block_cpu_limit": 199900,
    "block_net_limit": 1048576,
    "server_version_string": "v1.3.0"
    }
    """

    public static let blockResponseJson = """
    {
    "timestamp": "2019-02-21T18:31:40.000",
    "producer": "blkproducer2",
    "confirmed": 0,
    "previous": "01816fffa4548475add3c45d0e0620f59468a6817426137b37851c23ccafa9cc",
    "transaction_mroot": "0000000000000000000000000000000000000000000000000000000000000000",
    "action_mroot": "de5493939e3abdca80deeab2fc9389cc43dc1982708653cfe6b225eb788d6659",
    "schedule_version": 3,
    "new_producers": null,
    "header_extensions": [],
    "producer_signature": "SIG_K1_KZ3ptku7orAgcyMzd9FKW4jPC9PvjW9BGadFoyxdJFWM44VZdjW28DJgDe6wkNHAxnpqCWSzaBHB1AfbXBUn3HDzetemoA",
    "transactions": [],
    "block_extensions": [],
    "id": "0181700002e623f2bf291b86a10a5cec4caab4954d4231f31f050f4f86f26116",
    "block_num": 25260032,
    "ref_block_prefix": 2249927103
    }
    """

    public static let blockResponseWithTransactionJson = """
    {
    "timestamp": "2019-01-28T16:15:37.500",
    "producer": "blkproducer1",
    "confirmed": 0,
    "previous": "0141f04e920793ee4040fa39f7306f04e437608bd4b9f27db93958015aa20e49",
    "transaction_mroot": "bfbd10197cbe12f9fccc48a136c41d59d781c141e96cfeb61be554f1234f5905",
    "action_mroot": "0a7379a38c177b7c4aa09f6fb60389a7aa377b875541bf3221914d30bc8d5bb7",
    "schedule_version": 2,
    "new_producers": null,
    "header_extensions": [],
    "producer_signature": "SIG_K1_K49uep79So1ruuMdXxBgDiQX9M3doA9zmfJSxssiMP6Uwf8YNoPsgvE5fQvgWk53PC5JrPW5j2jRCom1RnMZfhpTLzgj2u",
    "transactions": [
        {
            "status": "executed",
            "cpu_usage_us": 3837,
            "net_usage_words": 36,
            "trx": {
                "id": "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a",
                "signatures": [
                    "SIG_K1_JzFA9ffefWfrTBvpwMwZi81kR6tvHF4mfsRekVXrBjLWWikg9g1FrS9WupYuoGaRew5mJhr4d39tHUjHiNCkxamtEfxi68"
                ],
                "compression": "none",
                "packed_context_free_data": "",
                "context_free_data": [],
                "packed_trx": "c62a4f5c1cef3d6d71bd000000000290afc2d800ea3055000000405da7adba0072cbdd956f52acd910c3c958136d72f8560d1846bc7cf3157f5fbfb72d3001de4597f4a1fdbecda6d59c96a43009fc5e5d7b8f639b1269c77cec718460dcc19cb30100a6823403ea3055000000572d3ccdcd0143864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db155624800a6823403ea3055000000572d3ccdcd0100aeaa4ac15cfd4500000000a8ed32323b00aeaa4ac15cfd4500000060d234cd3da06806000000000004454f53000000001a746865206772617373686f70706572206c69657320686561767900",
                "transaction": {
                    "expiration": "2019-01-28T16:16:06",
                    "ref_block_num": 61212,
                    "ref_block_prefix": 3178327357,
                    "max_net_usage_words": 0,
                    "max_cpu_usage_ms": 0,
                    "delay_sec": 0,
                    "context_free_actions": [],
                    "actions": [
                        {
                            "account": "eosio.assert",
                            "name": "require",
                            "authorization": [],
                            "data": {
                                "chain_params_hash": "cbdd956f52acd910c3c958136d72f8560d1846bc7cf3157f5fbfb72d3001de45",
                                "manifest_id": "97f4a1fdbecda6d59c96a43009fc5e5d7b8f639b1269c77cec718460dcc19cb3",
                                "actions": [
                                    {
                                        "contract": "eosio.token",
                                        "action": "transfer"
                                    }
                                ],
                                "abi_hashes": [
                                    "43864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248"
                                ]
                            },
                            "hex_data": "cbdd956f52acd910c3c958136d72f8560d1846bc7cf3157f5fbfb72d3001de4597f4a1fdbecda6d59c96a43009fc5e5d7b8f639b1269c77cec718460dcc19cb30100a6823403ea3055000000572d3ccdcd0143864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248"
                        },
                        {
                            "account": "eosio.token",
                            "name": "transfer",
                            "authorization": [
                                {
                                    "actor": "cryptkeeper",
                                    "permission": "active"
                                }
                            ],
                            "data": {
                                "from": "cryptkeeper",
                                "to": "brandon",
                                "quantity": "42.0000 EOS",
                                "memo": "the grasshopper lies heavy"
                            },
                            "hex_data": "00aeaa4ac15cfd4500000060d234cd3da06806000000000004454f53000000001a746865206772617373686f70706572206c696573206865617679"
                        }
                    ],
                    "transaction_extensions": []
                }
            }
        }
    ],
    "block_extensions": [],
    "id": "0141f04f881cbe5018ca74a75953abf11a3d5a888c41ceee0cf5014c88ac0def",
    "block_num": 21098575,
    "ref_block_prefix": 2809448984
    }
    """

    public static let requiredKeysResponseJson = """
        {
            "required_keys": [
                               "EOS5j67P1W2RyBXAL8sNzYcDLox3yLpxyrxgkYy1xsXzVCvzbYpba"
                             ]
        }
        """

    public static let pushTransActionResponseJson = """
    {
    "transaction_id": "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a",
    "processed": {
        "id": "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a",
        "block_num": 21098575,
        "block_time": "2019-01-28T16:15:37.500",
        "producer_block_id": null,
        "receipt": {
            "status": "executed",
            "cpu_usage_us": 3837,
            "net_usage_words": 36
        },
        "elapsed": 3837,
        "net_usage": 288,
        "scheduled": false,
        "action_traces": [
            {
                "receipt": {
                    "receiver": "eosio.assert",
                    "act_digest": "a4caeedd5e5824dd916c1aaabc84f0a114ddbda83728c8c23ba859d4a8a93721",
                    "global_sequence": 21103875,
                    "recv_sequence": 332,
                    "auth_sequence": [],
                    "code_sequence": 1,
                    "abi_sequence": 1
                },
                "act": {
                    "account": "eosio.assert",
                    "name": "require",
                    "authorization": [],
                    "data": {
                        "chain_params_hash": "cbdd956f52acd910c3c958136d72f8560d1846bc7cf3157f5fbfb72d3001de45",
                        "manifest_id": "97f4a1fdbecda6d59c96a43009fc5e5d7b8f639b1269c77cec718460dcc19cb3",
                        "actions": [
                            {
                                "contract": "eosio.token",
                                "action": "transfer"
                            }
                        ],
                        "abi_hashes": [
                            "43864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248"
                        ]
                    },
                    "hex_data": "cbdd956f52acd910c3c958136d72f8560d1846bc7cf3157f5fbfb72d3001de4597f4a1fdbecda6d59c96a43009fc5e5d7b8f639b1269c77cec718460dcc19cb30100a6823403ea3055000000572d3ccdcd0143864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248"
                },
                "context_free": false,
                "elapsed": 1264,
                "cpu_usage": 0,
                "console": "",
                "total_cpu_usage": 0,
                "trx_id": "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a",
                "block_num": 21098575,
                "block_time": "2019-01-28T16:15:37.500",
                "producer_block_id": null,
                "account_ram_deltas": [],
                "inline_traces": []
            },
            {
                "receipt": {
                    "receiver": "eosio.token",
                    "act_digest": "9eab239d66d13c34b9cc35a6f79fb2f6d61a2d9df9a484075c82e65d73a0cbc8",
                    "global_sequence": 21103876,
                    "recv_sequence": 1366,
                    "auth_sequence": [
                        [
                            "cryptkeeper",
                            875
                        ]
                    ],
                    "code_sequence": 1,
                    "abi_sequence": 4
                },
                "act": {
                    "account": "eosio.token",
                    "name": "transfer",
                    "authorization": [
                        {
                            "actor": "cryptkeeper",
                            "permission": "active"
                        }
                    ],
                    "data": {
                        "from": "cryptkeeper",
                        "to": "brandon",
                        "quantity": "42.0000 EOS",
                        "memo": "the grasshopper lies heavy"
                    },
                    "hex_data": "00aeaa4ac15cfd4500000060d234cd3da06806000000000004454f53000000001a746865206772617373686f70706572206c696573206865617679"
                },
                "context_free": false,
                "elapsed": 2197,
                "cpu_usage": 0,
                "console": "",
                "total_cpu_usage": 0,
                "trx_id": "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a",
                "block_num": 21098575,
                "block_time": "2019-01-28T16:15:37.500",
                "producer_block_id": null,
                "account_ram_deltas": [],
                "inline_traces": [
                    {
                        "receipt": {
                            "receiver": "cryptkeeper",
                            "act_digest": "9eab239d66d13c34b9cc35a6f79fb2f6d61a2d9df9a484075c82e65d73a0cbc8",
                            "global_sequence": 21103877,
                            "recv_sequence": 496,
                            "auth_sequence": [
                                [
                                    "cryptkeeper",
                                    876
                                ]
                            ],
                            "code_sequence": 1,
                            "abi_sequence": 4
                        },
                        "act": {
                            "account": "eosio.token",
                            "name": "transfer",
                            "authorization": [
                                {
                                    "actor": "cryptkeeper",
                                    "permission": "active"
                                }
                            ],
                            "data": {
                                "from": "cryptkeeper",
                                "to": "brandon",
                                "quantity": "42.0000 EOS",
                                "memo": "the grasshopper lies heavy"
                            },
                            "hex_data": "00aeaa4ac15cfd4500000060d234cd3da06806000000000004454f53000000001a746865206772617373686f70706572206c696573206865617679"
                        },
                        "context_free": false,
                        "elapsed": 6,
                        "cpu_usage": 0,
                        "console": "",
                        "total_cpu_usage": 0,
                        "trx_id": "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a",
                        "block_num": 21098575,
                        "block_time": "2019-01-28T16:15:37.500",
                        "producer_block_id": null,
                        "account_ram_deltas": [],
                        "inline_traces": []
                    },
                    {
                        "receipt": {
                            "receiver": "brandon",
                            "act_digest": "9eab239d66d13c34b9cc35a6f79fb2f6d61a2d9df9a484075c82e65d73a0cbc8",
                            "global_sequence": 21103878,
                            "recv_sequence": 582,
                            "auth_sequence": [
                                [
                                    "cryptkeeper",
                                    877
                                ]
                            ],
                            "code_sequence": 1,
                            "abi_sequence": 4
                        },
                        "act": {
                            "account": "eosio.token",
                            "name": "transfer",
                            "authorization": [
                                {
                                    "actor": "cryptkeeper",
                                    "permission": "active"
                                }
                            ],
                            "data": {
                                "from": "cryptkeeper",
                                "to": "brandon",
                                "quantity": "42.0000 EOS",
                                "memo": "the grasshopper lies heavy"
                            },
                            "hex_data": "00aeaa4ac15cfd4500000060d234cd3da06806000000000004454f53000000001a746865206772617373686f70706572206c696573206865617679"
                        },
                        "context_free": false,
                        "elapsed": 5,
                        "cpu_usage": 0,
                        "console": "",
                        "total_cpu_usage": 0,
                        "trx_id": "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a",
                        "block_num": 21098575,
                        "block_time": "2019-01-28T16:15:37.500",
                        "producer_block_id": null,
                        "account_ram_deltas": [],
                        "inline_traces": []
                    }
                ]
            }
        ],
        "except": null
        }
    }
    """

    public static let blockHeaderStateJson = """
    {
    "id": "0137c067c65e9db8f8ee467c856fb6d1779dfeb0332a971754156d075c9a37ca",
    "block_num": 20430951,
    "header": {
    "timestamp": "2019-01-24T19:32:05.500",
    "producer": "blkproducer1",
    "confirmed": 0,
    "previous": "0137c066283ef586d4e1dba4711b2ddf0248628595855361d9b0920e7f64ea92",
    "transaction_mroot": "0000000000000000000000000000000000000000000000000000000000000000",
    "action_mroot": "60c9f06aef01b1b4b2088785c9239c960bca8fc23cedd6b8104c69c0335a6d39",
    "schedule_version": 2,
    "header_extensions": [],
    "producer_signature": "SIG_K1_K11ScNfXdat71utYJtkd8E6dFtvA7qQ3ww9K74xEpFvVCyeZhXTarwvGa7QqQTRw3CLFbsXCsWJFNCHFHLKWrnBNZ66c2m"
    },
    "dpos_proposed_irreversible_blocknum": 20430939,
    "dpos_irreversible_blocknum": 20430927,
    "bft_irreversible_blocknum": 0,
    "pending_schedule_lib_num": 1060626,
    "pending_schedule_hash": "b4713d11fe2e847132afdbeb2087e8dd7c1a9dcd4ca44ff1ce26497df77ffdf2",
    "pending_schedule": {
    "version": 2,
    "producers": []
    },
    "active_schedule": {
    "version": 2,
    "producers": [
    {
    "producer_name": "blkproducer1",
    "block_signing_key": "EOS5DgtLq5fSqsc6SD3SD98Tu5P7dirfNdnD3pjCLtURiDWTQ6pzV"
    },
    {
    "producer_name": "blkproducer2",
    "block_signing_key": "EOS8QEPQ1wiZrdHavectXNpMy3TpcyYGXSVfkVGhyVTaJ7FT8bzCZ"
    }
    ]
    },
    "blockroot_merkle": {
    "_active_nodes": [
    "ca0e1666e996c19b7ac1e23c9ac3e19820419aa6cd09d06cc4977703e5c2e6bc",
    "6efb7f0e81b2653cf120df1b2a1d58130aaba706804b6ecfeb7105a457004dd2",
    "d818f511c9050561d4017d06f0eae4d92ba2a566b905276e87883d986b6d793d",
    "42e4b3ed2c0415b5e9f5503adfe7470c3fbaa76fce13f78333c6e5530bacec95",
    "cd6bf209dc59c7d7100f5b2ec7e9d83e1c8065d5e6163a93def4a49f3e8692d9",
    "e6b829d48ca1e4976bd5f3c6135e0c37f28c71de520fd58f9f35675b736a413b",
    "ed446029ee3ae066625ddc6579ba6f254dceccf55f93fae00dc6f927d74d2032",
    "ec6547cd5a64f2b77a7cb6aac55fda91e9e510daa71dee7c42f8c0cb4e3715d4",
    "c1184888469c8d6761584a92612d8f0f0154ca1390364d2fecd236d16fd181bf",
    "04471d48dadaac6de6f387e56fba96d68fab8bf89442bc5def49e43d0b033067",
    "aea53602a5c06cc9efba2ea6889396c4197054c53504e2a47863cded4f582948",
    "5bd4aa9f779590cab95a0c6cb80297ed486d916767cdcc1012378d1430ec0300",
    "69d743c4190ae0b4fb19f5c05c6a349a73462c5c0c9f0baa6eb34df3631fb4aa"
    ],
    "_node_count": 20430950
    },
    "producer_to_last_produced": [
    [
    "blkproducer1",
    20430951
    ],
    [
    "blkproducer2",
    20430939
    ]
    ],
    "producer_to_last_implied_irb": [
    [
    "blkproducer1",
    20430939
    ],
    [
    "blkproducer2",
    20430927
    ]
    ],
    "block_signing_key": "EOS5DgtLq5fSqsc6SD3SD98Tu5P7dirfNdnD3pjCLtURiDWTQ6pzV",
    "confirm_count": [
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1
    ],
    "confirmations": []
    }
    """

    public static let accountJson = """
    {
    "account_name": "cryptkeeper",
    "head_block_num": 20571121,
    "head_block_time": "2019-01-25T15:00:10.500",
    "privileged": false,
    "last_code_update": "1970-01-01T00:00:00.000",
    "created": "2018-10-10T14:52:42.500",
    "core_liquid_balance": "986418.1921 EOS",
    "ram_quota": 13639863,
    "net_weight": 10000000,
    "cpu_weight": 10000000,
    "net_limit": {
        "used": 1805,
        "available": "797834381252",
        "max": "797834383057"
    },
    "cpu_limit": {
        "used": 17773,
        "available": "152174814200",
        "max": "152174831973"
    },
    "ram_usage": 7972,
    "permissions": [
        {
            "perm_name": "active",
            "parent": "owner",
            "required_auth": {
                "threshold": 1,
                "keys": [
                    {
                        "key": "EOS5j67P1W2RyBXAL8sNzYcDLox3yLpxyrxgkYy1xsXzVCvzbYpba",
                        "weight": 1
                    }
                ],
                "accounts": [
                      {
                        "permission": {
                          "actor": "eosaccount1",
                          "permission": "active"
                        },
                        "weight": 1
                      },
                ],
                "waits": [
                    {
                        "wait_sec": 259200,
                        "weight": 1
                    },
                    {
                        "wait_sec": 604800,
                        "weight": 2
                    }
                ]
            }
        },
        {
            "perm_name": "owner",
            "parent": "",
            "required_auth": {
                "threshold": 1,
                "keys": [
                    {
                        "key": "EOS74RoiasFcUQp1a8qdo3WUoHLGG3NTTts4UcyiqS4qh9eZy1Vxh",
                        "weight": 1
                    }
                ],
                "accounts": [],
                "waits": []
            }
        }
    ],
    "total_resources": {
        "owner": "cryptkeeper",
        "net_weight": "1000.0000 EOS",
        "cpu_weight": "1000.0000 EOS",
        "ram_bytes": 13639863
    },
    "self_delegated_bandwidth": null,
    "refund_request": null,
    "voter_info": null
    }
    """

    public static let accountNegativeUsageValuesJson = """
    {
    "account_name": "cryptkeeper",
    "head_block_num": 20571121,
    "head_block_time": "2019-01-25T15:00:10.500",
    "privileged": false,
    "last_code_update": "1970-01-01T00:00:00.000",
    "created": "2018-10-10T14:52:42.500",
    "core_liquid_balance": "986418.1921 EOS",
    "ram_quota": -1,
    "net_weight": -1,
    "cpu_weight": "-1",
    "net_limit": {
        "used": 1805,
        "available": "797834381252",
        "max": "797834383057"
    },
    "cpu_limit": {
        "used": 17773,
        "available": "152174814200",
        "max": "152174831973"
    },
    "ram_usage": -1,
    "permissions": [
        {
            "perm_name": "active",
            "parent": "owner",
            "required_auth": {
                "threshold": 1,
                "keys": [
                    {
                        "key": "EOS5j67P1W2RyBXAL8sNzYcDLox3yLpxyrxgkYy1xsXzVCvzbYpba",
                        "weight": 1
                    }
                ],
                "accounts": [
                      {
                        "permission": {
                          "actor": "eosaccount1",
                          "permission": "active"
                        },
                        "weight": 1
                      },
                ],
                "waits": [
                    {
                        "wait_sec": 259200,
                        "weight": 1
                    },
                    {
                        "wait_sec": 604800,
                        "weight": 2
                    }
                ]
            }
        },
        {
            "perm_name": "owner",
            "parent": "",
            "required_auth": {
                "threshold": 1,
                "keys": [
                    {
                        "key": "EOS74RoiasFcUQp1a8qdo3WUoHLGG3NTTts4UcyiqS4qh9eZy1Vxh",
                        "weight": 1
                    }
                ],
                "accounts": [],
                "waits": []
            }
        }
    ],
    "total_resources": {
        "owner": "cryptkeeper",
        "net_weight": "1000.0000 EOS",
        "cpu_weight": "1000.0000 EOS",
        "ram_bytes": 13639863
    },
    "self_delegated_bandwidth": null,
    "refund_request": null,
    "voter_info": null
    }
    """

    public static let abiJson = """
    {
    "account_name": "eosio.token",
    "abi": {
        "version": "eosio::abi/1.0",
        "types": [
            {
                "new_type_name": "account_name",
                "type": "name"
            }
        ],
        "structs": [
            {
                "name": "transfer",
                "base": "",
                "fields": [
                    {
                        "name": "from",
                        "type": "account_name"
                    },
                    {
                        "name": "to",
                        "type": "account_name"
                    },
                    {
                        "name": "quantity",
                        "type": "asset"
                    },
                    {
                        "name": "memo",
                        "type": "string"
                    }
                ]
            },
            {
                "name": "create",
                "base": "",
                "fields": [
                    {
                        "name": "issuer",
                        "type": "account_name"
                    },
                    {
                        "name": "maximum_supply",
                        "type": "asset"
                    }
                ]
            },
            {
                "name": "issue",
                "base": "",
                "fields": [
                    {
                        "name": "to",
                        "type": "account_name"
                    },
                    {
                        "name": "quantity",
                        "type": "asset"
                    },
                    {
                        "name": "memo",
                        "type": "string"
                    }
                ]
            },
            {
                "name": "account",
                "base": "",
                "fields": [
                    {
                        "name": "balance",
                        "type": "asset"
                    }
                ]
            },
            {
                "name": "currency_stats",
                "base": "",
                "fields": [
                    {
                        "name": "supply",
                        "type": "asset"
                    },
                    {
                        "name": "max_supply",
                        "type": "asset"
                    },
                    {
                        "name": "issuer",
                        "type": "account_name"
                    }
                ]
            }
        ],
        "actions": [
            {
                "name": "transfer",
                "type": "transfer",
                "ricardian_contract": "---\\ntitle: Token Transfer\\nsummary: Transfer tokens from one account to another.\\nicon: https://cdn.testnet.dev.b1ops.net/token-transfer.png#ce51ef9f9eeca3434e85507e0ed49e76fff1265422bded0255f3196ea59c8b0c\\n---\\n\\n## Transfer Terms & Conditions\\n\\nI, {{from}}, certify the following to be true to the best of my knowledge:\\n\\n1. I certify that {{quantity}} is not the proceeds of fraudulent or violent activities.\\n2. I certify that, to the best of my knowledge, {{to}} is not supporting initiation of violence against others.\\n3. I have disclosed any contractual terms & conditions with respect to {{quantity}} to {{to}}.\\n\\nI understand that funds transfers are not reversible after the {{$transaction.delay_sec}} seconds or other delay as configured by {{from}}'s permissions.\\n\\nIf this action fails to be irreversibly confirmed after receiving goods or services from '{{to}}', I agree to either return the goods or services or resend {{quantity}} in a timely manner."
            },
            {
                "name": "issue",
                "type": "issue",
                "ricardian_contract": ""
            },
            {
                "name": "create",
                "type": "create",
                "ricardian_contract": ""
            }
        ],
        "tables": [
            {
                "name": "accounts",
                "index_type": "i64",
                "key_names": [
                    "currency"
                ],
                "key_types": [
                    "uint64"
                ],
                "type": "account"
            },
            {
                "name": "stat",
                "index_type": "i64",
                "key_names": [
                    "currency"
                ],
                "key_types": [
                    "uint64"
                ],
                "type": "currency_stats"
            }
        ],
        "ricardian_clauses": [],
        "error_messages": [],
        "abi_extensions": [],
        "variants": []
    }
    }
    """

    public static let currencyBalanceJson = """
    [
    "957998.0000 EOS"
    ]
    """

    public static let currencyStats = """
    {
    "EOS": {
        "supply": "5000000000.0000 EOS",
        "max_supply": "10000000000.0000 EOS",
        "issuer": "eosio"
    }
    }
    """

    public static let currencyStatsSYS = """
    {
    "SYS": {
        "supply": "5000000000.0000 SYS",
        "max_supply": "10000000000.0000 SYS",
        "issuer": "eosio"
    }
    }
    """

    public static let rawCodeAndAbiJson = """
    {
    "account_name": "eosio.token",
    "wasm": "AGFzbQEAAAABfhVgA39+fwBgBX9+fn9/AGAEf35/fwBgAABgAAF+YAJ+fgBgAX4AYAJ/fwBgBH5+fn4Bf2AGfn5+fn9/AX9gA39/fwF/YAF+AX9gAX8AYAABf2ACf38Bf2ABfwF/YAR/f39/AGAEf35/fgBgBH5+f38AYAN/fn8Bf2ADfn5+AALFAhEDZW52BWFib3J0AAMDZW52EGFjdGlvbl9kYXRhX3NpemUADQNlbnYQY3VycmVudF9yZWNlaXZlcgAEA2VudgxjdXJyZW50X3RpbWUABANlbnYLZGJfZmluZF9pNjQACANlbnYKZGJfZ2V0X2k2NAAKA2Vudg1kYl9yZW1vdmVfaTY0AAwDZW52DGRiX3N0b3JlX2k2NAAJA2Vudg1kYl91cGRhdGVfaTY0AAIDZW52DGVvc2lvX2Fzc2VydAAHA2Vudgppc19hY2NvdW50AAsDZW52Bm1lbWNweQAKA2VudhByZWFkX2FjdGlvbl9kYXRhAA4DZW52DHJlcXVpcmVfYXV0aAAGA2Vudg1yZXF1aXJlX2F1dGgyAAUDZW52EXJlcXVpcmVfcmVjaXBpZW50AAYDZW52C3NlbmRfaW5saW5lAAcDMTAODg4NDAAODwcQBwIREgcHBw4ODg4QARMAEwcUDg4OBwcODgcPDAwHDA4KDw4PDAMEBQFwAQQEBQMBAAEH9wMPBm1lbW9yeQIAFl9aZXFSSzExY2hlY2tzdW0yNTZTMV8AERZfWmVxUksxMWNoZWNrc3VtMTYwUzFfABIWX1puZVJLMTFjaGVja3N1bTE2MFMxXwATA25vdwAUMF9aTjVlb3NpbzEycmVxdWlyZV9hdXRoRVJLTlNfMTZwZXJtaXNzaW9uX2xldmVsRQAVIl9aTjVlb3NpbzV0b2tlbjZjcmVhdGVFeU5TXzVhc3NldEUAFmFfWk41ZW9zaW81dG9rZW41aXNzdWVFeU5TXzVhc3NldEVOU3QzX18xMTJiYXNpY19zdHJpbmdJY05TMl8xMWNoYXJfdHJhaXRzSWNFRU5TMl85YWxsb2NhdG9ySWNFRUVFABwpX1pONWVvc2lvNXRva2VuMTFhZGRfYmFsYW5jZUV5TlNfNWFzc2V0RXkAHWVfWk41ZW9zaW81dG9rZW44dHJhbnNmZXJFeXlOU181YXNzZXRFTlN0M19fMTEy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QQgQCxogB0F4cUEIR0GAAxAJIAogA0EIakEIEAsaIAUgATYCFCAJIAU2AhggCSAFQQhqKQMAQgiIIgg3AxAgCSAFKAIUIgc2AgwCQAJAIABBHGoiASgCACIGIABBIGooAgBPDQAgBiAINwMIIAYgBzYCECAJQQA2AhggBiAFNgIAIAEgBkEYajYCAAwBCyACIAlBGGogCUEQaiAJQQxqECYLIAkoAhghBiAJQQA2AhggBkUNACAGEDYLQQAgCUEgajYCBCAFC6oDAQR/AkACQCAAKAIEIAAoAgAiBmtBGG0iBEEBaiIFQavVqtUATw0AQarVqtUAIQcCQAJAIAAoAgggBmtBGG0iBkHUqtUqSw0AIAUgBkEBdCIHIAcgBUkbIgdFDQELIAdBGGwQNSEGDAILQQAhB0EAIQYMAQsgABA5AAsgASgCACEFIAFBADYCACAGIARBGGxqIgEgBTYCACABIAIpAwA3AwggASADKAIANgIQIAYgB0EYbGohBCABQRhqIQUCQAJAIABBBGooAgAiBiAAKAIAIgdGDQADQCAGQWhqIgIoAgAhAyACQQA2AgAgAUFoaiADNgIAIAFBeGogBkF4aigCADYCACABQXRqIAZBdGooAgA2AgAgAUFwaiAGQXBqKAIANgIAIAFBaGohASACIQYgByACRw0ACyAAQQRqKAIAIQcgACgCACEGDAELIAchBgsgACABNgIAIABBBGogBTYCACAAQQhqIAQ2AgACQCAHIAZGDQADQCAHQWhqIgcoAgAhASAHQQA2AgACQCABRQ0AIAEQNgsgBiAHRw0ACwsCQCAGRQ0AIAYQNgsLogUGAX4BfwF+AX8BfgJ/QQBBACgCBEHwAGsiCzYCBCABIAJSQeAHEAkgARANIAIQCkGACBAJIAMpAwghBUEAIQggC0HoAGpBADYCACALIAVCCIgiCTcDUCALQn83A1ggC0IANwNgIAsgACkDADcDSCALQcgAaiAJQaAIECghBiABEA8gAhAPAkAgAykDACIHQv//////////P3xC/v//////////AFYNAEEAIQoCQANAIAmnQRh0Qf////97akH+///XAUsNAQJAIAlCCIgiCUL/AYNCAFINAANAIAlCCIgiCUL/AYNCAFINAyAKQQFqIgpBB0gNAAsLQQEhCCAKQQFqIgpBB0gNAAwCCwtBACEI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YXNzZWQgdG8gbW9kaWZ5IGlzIG5vdCBpbiBtdWx0aV9pbmRleAAAQbAFCzNjYW5ub3QgbW9kaWZ5IG9iamVjdHMgaW4gdGFibGUgb2YgYW5vdGhlciBjb250cmFjdAAAQfAFCythdHRlbXB0IHRvIGFkZCBhc3NldCB3aXRoIGRpZmZlcmVudCBzeW1ib2wAAEGgBgsTYWRkaXRpb24gdW5kZXJmbG93AABBwAYLEmFkZGl0aW9uIG92ZXJmbG93AABB4AYLO3VwZGF0ZXIgY2Fubm90IGNoYW5nZSBwcmltYXJ5IGtleSB3aGVuIG1vZGlmeWluZyBhbiBvYmplY3QAAEGgBwsHYWN0aXZlAABBsAcLI2Nhbm5vdCBwYXNzIGVuZCBpdGVyYXRvciB0byBtb2RpZnkAAEHgBwsYY2Fubm90IHRyYW5zZmVyIHRvIHNlbGYAAEGACAsadG8gYWNjb3VudCBkb2VzIG5vdCBleGlzdAAAQaAICxN1bmFibGUgdG8gZmluZCBrZXkAAEHACAsgbXVzdCB0cmFuc2ZlciBwb3NpdGl2ZSBxdWFudGl0eQAAQeAICxhubyBiYWxhbmNlIG9iamVjdCBmb3VuZAAAQYAJCxJvdmVyZHJhd24gYmFsYW5jZQAAQaAJCzBhdHRlbXB0IHRvIHN1YnRyYWN0IGFzc2V0IHdpdGggZGlmZmVyZW50IHN5bWJvbAAAQdAJCxZzdWJ0cmFjdGlvbiB1bmRlcmZsb3cAAEHwCQsVc3VidHJhY3Rpb24gb3ZlcmZsb3cAAEGQCgstb2JqZWN0IHBhc3NlZCB0byBlcmFzZSBpcyBub3QgaW4gbXVsdGlfaW5kZXgAAEHACgsyY2Fubm90IGVyYXNlIG9iamVjdHMgaW4gdGFibGUgb2YgYW5vdGhlciBjb250cmFjdAAAQYALCzVhdHRlbXB0IHRvIHJlbW92ZSBvYmplY3QgdGhhdCB3YXMgbm90IGluIG11bHRpX2luZGV4AABBwAsLCG9uZXJyb3IAAEHQCwsGZW9zaW8AAEHgCwtAb25lcnJvciBhY3Rpb24ncyBhcmUgb25seSB2YWxpZCBmcm9tIHRoZSAiZW9zaW8iIHN5c3RlbSBhY2NvdW50AABBoAwLBGdldAAAQYDOAAtWbWFsbG9jX2Zyb21fZnJlZWQgd2FzIGRlc2lnbmVkIHRvIG9ubHkgYmUgY2FsbGVkIGFmdGVyIF9oZWFwIHdhcyBjb21wbGV0ZWx5IGFsbG9jYXRlZAA==",
    "abi": "DmVvc2lvOjphYmkvMS4wAQxhY2NvdW50X25hbWUEbmFtZQUIdHJhbnNmZXIABARmcm9tDGFjY291bnRfbmFtZQJ0bwxhY2NvdW50X25hbWUIcXVhbnRpdHkFYXNzZXQEbWVtbwZzdHJpbmcGY3JlYXRlAAIGaXNzdWVyDGFjY291bnRfbmFtZQ5tYXhpbXVtX3N1cHBseQVhc3NldAVpc3N1ZQADAnRvDGFjY291bnRfbmFtZQhxdWFudGl0eQVhc3NldARtZW1vBnN0cmluZwdhY2NvdW50AAEHYmFsYW5jZQVhc3NldA5jdXJyZW5jeV9zdGF0cwADBnN1cHBseQVhc3NldAptYXhfc3VwcGx5BWFzc2V0Bmlzc3VlcgxhY2NvdW50X25hbWUDAAAAVy08zc0IdHJhbnNmZXK8By0tLQp0aXRsZTogVG9rZW4gVHJhbnNmZXIKc3VtbWFyeTogVHJhbnNmZXIgdG9rZW5zIGZyb20gb25lIGFjY291bnQgdG8gYW5vdGhlci4KaWNvbjogaHR0cHM6Ly9jZG4udGVzdG5ldC5kZXYuYjFvcHMubmV0L3Rva2VuLXRyYW5zZmVyLnBuZyNjZTUxZWY5ZjllZWNhMzQzNGU4NTUwN2UwZWQ0OWU3NmZmZjEyNjU0MjJiZGVkMDI1NWYzMTk2ZWE1OWM4YjBjCi0tLQoKIyMgVHJhbnNmZXIgVGVybXMgJiBDb25kaXRpb25zCgpJLCB7e2Zyb219fSwgY2VydGlmeSB0aGUgZm9sbG93aW5nIHRvIGJlIHRydWUgdG8gdGhlIGJlc3Qgb2YgbXkga25vd2xlZGdlOgoKMS4gSSBjZXJ0aWZ5IHRoYXQge3txdWFudGl0eX19IGlzIG5vdCB0aGUgcHJvY2VlZHMgb2YgZnJhdWR1bGVudCBvciB2aW9sZW50IGFjdGl2aXRpZXMuCjIuIEkgY2VydGlmeSB0aGF0LCB0byB0aGUgYmVzdCBvZiBteSBrbm93bGVkZ2UsIHt7dG99fSBpcyBub3Qgc3VwcG9ydGluZyBpbml0aWF0aW9uIG9mIHZpb2xlbmNlIGFnYWluc3Qgb3RoZXJzLgozLiBJIGhhdmUgZGlzY2xvc2VkIGFueSBjb250cmFjdHVhbCB0ZXJtcyAmIGNvbmRpdGlvbnMgd2l0aCByZXNwZWN0IHRvIHt7cXVhbnRpdHl9fSB0byB7e3RvfX0uCgpJIHVuZGVyc3RhbmQgdGhhdCBmdW5kcyB0cmFuc2ZlcnMgYXJlIG5vdCByZXZlcnNpYmxlIGFmdGVyIHRoZSB7eyR0cmFuc2FjdGlvbi5kZWxheV9zZWN9fSBzZWNvbmRzIG9yIG90aGVyIGRlbGF5IGFzIGNvbmZpZ3VyZWQgYnkge3tmcm9tfX0ncyBwZXJtaXNzaW9ucy4KCklmIHRoaXMgYWN0aW9uIGZhaWxzIHRvIGJlIGlycmV2ZXJzaWJseSBjb25maXJtZWQgYWZ0ZXIgcmVjZWl2aW5nIGdvb2RzIG9yIHNlcnZpY2VzIGZyb20gJ3t7dG99fScsIEkgYWdyZWUgdG8gZWl0aGVyIHJldHVybiB0aGUgZ29vZHMgb3Igc2VydmljZXMgb3IgcmVzZW5kIHt7cXVhbnRpdHl9fSBpbiBhIHRpbWVseSBtYW5uZXIuAAAAAAClMXYFaXNzdWUAAAAAAKhs1EUGY3JlYXRlAAIAAAA4T00RMgNpNjQBCGN1cnJlbmN5AQZ1aW50NjQHYWNjb3VudAAAAAAAkE3GA2k2NAEIY3VycmVuY3kBBnVpbnQ2NA5jdXJyZW5jeV9zdGF0cwAAAAA=="
    }
    """

    public static let codeJson = """
    {
    "account_name": "tropical",
    "code_hash": "68721c88e8b04dea76962d8afea28d2f39b870d72be30d1d143147cdf638baad",
    "wast": "",
    "wasm": "WasmCodeJiberish",
    "abi": {
    "version": "eosio::abi/1.1",
    "types": [],
    "structs": [
    {
    "name": "like",
    "base": "",
    "fields": [
    {
    "name": "user",
    "type": "name"
    }
    ]
    }
    ],
    "actions": [
    {
    "name": "like",
    "type": "like",
    "ricardian_contract": "Ricardian Contract Text"
    }
    ],
    "tables": [],
    "ricardian_clauses": [],
    "error_messages": [],
    "abi_extensions": [],
    "variants": []
    }
    }
    """

    //Input defaults do not produce a working request, not sure if all fields still valid.  Some requests from [eosjs/4.-Reading blockchain-Examples.md](https://github.com/EOSIO/eosjs/blob/41bb99b319c1a3b24110a52c3a6e1558df0f326a/docs/4.-Reading%20blockchain-Examples.md) tried.  Some work, some do not.  One working example:
    public static let tableRowsJson = """
    {
    "rows": [
        {
            "balance": "986420.1921 EOS"
        }
    ],
    "more": false
    }
    """

    public static let tableScopeJson = """
    {
    "rows": [
        {
            "code": "eosio.token",
            "scope": "ahayrapetian",
            "table": "accounts",
            "payer": "montage.usr2",
            "count": 1
        },
        {
            "code": "eosio.token",
            "scope": "an",
            "table": "accounts",
            "payer": "eosio",
            "count": 1
        },
        {
            "code": "eosio.token",
            "scope": "autotransfer",
            "table": "accounts",
            "payer": "eosio",
            "count": 1
        },
        {
            "code": "eosio.token",
            "scope": "b1b1b1b1b1b1",
            "table": "accounts",
            "payer": "ahayrapetian",
            "count": 1
        },
        {
            "code": "eosio.token",
            "scope": "brandon",
            "table": "accounts",
            "payer": "eosio",
            "count": 1
        },
        {
            "code": "eosio.token",
            "scope": "brianhazzard",
            "table": "accounts",
            "payer": "eosio",
            "count": 1
        },
        {
            "code": "eosio.token",
            "scope": "chrisallnutt",
            "table": "accounts",
            "payer": "eosio",
            "count": 1
        },
        {
            "code": "eosio.token",
            "scope": "cryptkeeper",
            "table": "accounts",
            "payer": "eosio",
            "count": 1
        },
        {
            "code": "eosio.token",
            "scope": "eosio",
            "table": "accounts",
            "payer": "eosio",
            "count": 1
        },
        {
            "code": "eosio.token",
            "scope": "eosio.ram",
            "table": "accounts",
            "payer": "eosio",
            "count": 1
        }
    ],
    "more": "eosio.ramfee"
    }
    """

    public static let producersJson = """
    {
    "rows": [
        {
            "owner": "blkproducer2",
            "total_votes": "0.00000000000000000",
            "producer_key": "EOS8QEPQ1wiZrdHavectXNpMy3TpcyYGXSVfkVGhyVTaJ7FT8bzCZ",
            "is_active": 1,
            "url": "",
            "unpaid_blocks": 0,
            "last_claim_time": "1970-01-01T00:00:00.000",
            "location": 0
        },
        {
            "owner": "blkproducer3",
            "total_votes": "0.00000000000000000",
            "producer_key": "EOS7YTjjzt7coagRE5i64JhZB4ucH23Nz5mDhXdzU6QC7gfXwy8M9",
            "is_active": 1,
            "url": "",
            "unpaid_blocks": 0,
            "last_claim_time": "2019-01-31T22:50:21.500",
            "location": 0
        }
    ],
    "total_producer_vote_weight": "0.00000000000000000",
    "more": ""
    }
    """

    public static let actionsJson = """
    {
    "actions": [
        {
            "global_action_seq": "6483908013",
            "account_action_seq": 137,
            "block_num": 55375463,
            "block_time": "2019-04-28T17:41:39.000",
            "action_trace": {
                "receipt": {
                    "receiver": "bank.m",
                    "act_digest": "62021c2315d8245d0546180daf7825d728a5564d2831e8b2d1fc2d01309bf06b",
                    "global_sequence": "6483908013",
                    "recv_sequence": 1236,
                    "auth_sequence": [
                        [
                            "powersurge22",
                            77
                        ]
                    ],
                    "code_sequence": 1,
                    "abi_sequence": 1
                },
                "act": {
                    "account": "eosiomeetone",
                    "name": "transfer",
                    "authorization": [
                        {
                            "actor": "powersurge22",
                            "permission": "active"
                        }
                    ],
                    "data": {
                        "from": "powersurge22",
                        "to": "bank.m",
                        "quantity": "20047.0259 MEETONE",
                        "memo": "l2sbjsdrfd.m"
                    },
                    "hex_data": "10826257e3ab38ad000000004800a739f3eef20b00000000044d4545544f4e450c6c3273626a736472666a2e6f"
                },
                "context_free": false,
                "elapsed": 299,
                "console": "",
                "trx_id": "9f6871d2f230a2a2c2d7a6eb4847dd733f47e0fa481c6b40049e58e53751c066",
                "block_num": 55375463,
                "block_time": "2019-04-28T17:41:39.000",
                "producer_block_id": "034cf66765dd7ac2ea187beb5570ef8dbfbf4b9270d3940d02157ad4ac40831s",
                "account_ram_deltas": [
                    {
                        "account": "bank.m",
                        "delta": 472
                    }
                ],
                "except": null,
                "inline_traces": [{
                        "receipt": {
                            "receiver": "powersurge22",
                            "act_digest": "62021c2315d8245d0546180daf825d728a5564d2831e8b2d1f2d01309bf06b",
                            "global_sequence": "6483908012",
                            "recv_sequence": 82,
                            "auth_sequence": [
                                [
                                    "powersurge2",
                                    76
                                ]
                            ],
                            "code_sequence": 1,
                            "abi_sequence": 1
                        },
                        "act": {
                            "account": "eosiomeetone",
                            "name": "transfer",
                            "authorization": [
                                {
                                    "actor": "powersurge2",
                                    "permission": "active"
                                }
                            ],
                            "data": {
                                "from": "powersurge22",
                                "to": "bank.m",
                                "quantity": "20047.0259 MEETONE",
                                "memo": "l2sbjsd4fj.m"
                            },
                            "hex_data": "10826257e3ab38ad000000004800a739f3eef20b00000000044d4545544f4e450c6c3273626a736472666a2s6d"
                        },
                        "context_free": false,
                        "elapsed": 6,
                        "console": "",
                        "trx_id": "9f6871d2f230a2a2c2d7a6eb4847dd733f47e0fa481c6b40049e58e53751c066",
                        "block_num": 55375463,
                        "block_time": "2019-04-28T17:41:39.000",
                        "producer_block_id": "034cf66765dd7ac2ea187beb5570ef8dbfbf4b9270d3940d02157ad4ac408314",
                        "account_ram_deltas": [],
                        "except": null,
                        "inline_traces": []
                    }]
            }
        },
        {
            "global_action_seq": "6497451149",
            "account_action_seq": 138,
            "block_num": 55513304,
            "block_time": "2019-04-29T12:50:29.000",
            "action_trace": {
                "receipt": {
                    "receiver": "powersurge43",
                    "act_digest": "5755dd0b7783fdf6c5aa5ee61473f9d22be504551d45aa3c4edaf51533401dbr",
                    "global_sequence": "6497451149",
                    "recv_sequence": 83,
                    "auth_sequence": [
                        [
                            "pokerkbugle1",
                            5090990
                        ]
                    ],
                    "code_sequence": 4,
                    "abi_sequence": 2
                },
                "act": {
                    "account": "pokerktoken1",
                    "name": "transfer",
                    "authorization": [
                        {
                            "actor": "pokerkbugle1",
                            "permission": "active"
                        }
                    ],
                    "data": {
                        "from": "pokerkbugle1",
                        "to": "powersurge43",
                        "quantity": "0.0100 KING",
                        "memo": "Memo"
                    },
                    "hex_data": "105464fac0ab20ad10826257e3ab38ad6400000000000000044b494e470000009701506f6b65724b696e672e6f6e65202d2d2054686520626573742050565020546578617320486f6c64656d206f6e20454f532c20617661696c61626c65207461626c657320666f7220323420686f757273efbc81e69c80e5a5bde79a84454f53e5beb7e5b79ee68991e5858befbc8ce79c9fe6ada3e79a84505650e6b8b8e6888fefbc8c3234e5b08fe697b6e69c89e7898ce5b180efbc8t"
                },
                "context_free": false,
                "elapsed": 19,
                "console": "",
                "trx_id": "4700d0f00f3101f3223790fd9def0afaa7508b2d7d99d62b83389fdc9ef26c4u",
                "block_num": 55513304,
                "block_time": "2019-04-29T12:50:29.000",
                "producer_block_id": "034f10d8346b169b1a376f4133c9d6673883bf047dd2f6037a531909d31ddb1q",
                "account_ram_deltas": [],
                "except": null,
                "inline_traces": []
            }
        }
    ],
    "last_irreversible_block": 55535908
    }
    """

    public static let actionsNegativeDeltaJson = """
    {
    "actions": [
        {
            "global_action_seq": "6483908013",
            "account_action_seq": 137,
            "block_num": 55375463,
            "block_time": "2019-04-28T17:41:39.000",
            "action_trace": {
                "receipt": {
                    "receiver": "bank.m",
                    "act_digest": "62021c2315d8245d0546180daf7825d728a5564d2831e8b2d1fc2d01309bf06b",
                    "global_sequence": "6483908013",
                    "recv_sequence": 1236,
                    "auth_sequence": [
                        [
                            "powersurge22",
                            77
                        ]
                    ],
                    "code_sequence": 1,
                    "abi_sequence": 1
                },
                "act": {
                    "account": "eosiomeetone",
                    "name": "transfer",
                    "authorization": [
                        {
                            "actor": "powersurge22",
                            "permission": "active"
                        }
                    ],
                    "data": {
                        "from": "powersurge22",
                        "to": "bank.m",
                        "quantity": "20047.0259 MEETONE",
                        "memo": "l2sbjsdrfd.m"
                    },
                    "hex_data": "10826257e3ab38ad000000004800a739f3eef20b00000000044d4545544f4e450c6c3273626a736472666a2e6f"
                },
                "context_free": false,
                "elapsed": 299,
                "console": "",
                "trx_id": "9f6871d2f230a2a2c2d7a6eb4847dd733f47e0fa481c6b40049e58e53751c066",
                "block_num": 55375463,
                "block_time": "2019-04-28T17:41:39.000",
                "producer_block_id": "034cf66765dd7ac2ea187beb5570ef8dbfbf4b9270d3940d02157ad4ac40831s",
                "account_ram_deltas": [
                    {
                        "account": "bank.m",
                        "delta": -1
                    }
                ],
                "except": null,
                "inline_traces": [{
                        "receipt": {
                            "receiver": "powersurge22",
                            "act_digest": "62021c2315d8245d0546180daf825d728a5564d2831e8b2d1f2d01309bf06b",
                            "global_sequence": "6483908012",
                            "recv_sequence": 82,
                            "auth_sequence": [
                                [
                                    "powersurge2",
                                    76
                                ]
                            ],
                            "code_sequence": 1,
                            "abi_sequence": 1
                        },
                        "act": {
                            "account": "eosiomeetone",
                            "name": "transfer",
                            "authorization": [
                                {
                                    "actor": "powersurge2",
                                    "permission": "active"
                                }
                            ],
                            "data": {
                                "from": "powersurge22",
                                "to": "bank.m",
                                "quantity": "20047.0259 MEETONE",
                                "memo": "l2sbjsd4fj.m"
                            },
                            "hex_data": "10826257e3ab38ad000000004800a739f3eef20b00000000044d4545544f4e450c6c3273626a736472666a2s6d"
                        },
                        "context_free": false,
                        "elapsed": 6,
                        "console": "",
                        "trx_id": "9f6871d2f230a2a2c2d7a6eb4847dd733f47e0fa481c6b40049e58e53751c066",
                        "block_num": 55375463,
                        "block_time": "2019-04-28T17:41:39.000",
                        "producer_block_id": "034cf66765dd7ac2ea187beb5570ef8dbfbf4b9270d3940d02157ad4ac408314",
                        "account_ram_deltas": [],
                        "except": null,
                        "inline_traces": []
                    }]
            }
        },
        {
            "global_action_seq": "6497451149",
            "account_action_seq": 138,
            "block_num": 55513304,
            "block_time": "2019-04-29T12:50:29.000",
            "action_trace": {
                "receipt": {
                    "receiver": "powersurge43",
                    "act_digest": "5755dd0b7783fdf6c5aa5ee61473f9d22be504551d45aa3c4edaf51533401dbr",
                    "global_sequence": "6497451149",
                    "recv_sequence": 83,
                    "auth_sequence": [
                        [
                            "pokerkbugle1",
                            5090990
                        ]
                    ],
                    "code_sequence": 4,
                    "abi_sequence": 2
                },
                "act": {
                    "account": "pokerktoken1",
                    "name": "transfer",
                    "authorization": [
                        {
                            "actor": "pokerkbugle1",
                            "permission": "active"
                        }
                    ],
                    "data": {
                        "from": "pokerkbugle1",
                        "to": "powersurge43",
                        "quantity": "0.0100 KING",
                        "memo": "Memo"
                    },
                    "hex_data": "105464fac0ab20ad10826257e3ab38ad6400000000000000044b494e470000009701506f6b65724b696e672e6f6e65202d2d2054686520626573742050565020546578617320486f6c64656d206f6e20454f532c20617661696c61626c65207461626c657320666f7220323420686f757273efbc81e69c80e5a5bde79a84454f53e5beb7e5b79ee68991e5858befbc8ce79c9fe6ada3e79a84505650e6b8b8e6888fefbc8c3234e5b08fe697b6e69c89e7898ce5b180efbc8t"
                },
                "context_free": false,
                "elapsed": 19,
                "console": "",
                "trx_id": "4700d0f00f3101f3223790fd9def0afaa7508b2d7d99d62b83389fdc9ef26c4u",
                "block_num": 55513304,
                "block_time": "2019-04-29T12:50:29.000",
                "producer_block_id": "034f10d8346b169b1a376f4133c9d6673883bf047dd2f6037a531909d31ddb1q",
                "account_ram_deltas": [],
                "except": null,
                "inline_traces": []
            }
        }
    ],
    "last_irreversible_block": 55535908
    }
    """

    public static let controlledAccountsJson = """
    {
        "controlled_accounts": [
            "subcrypt1",
            "subcrypt2"
        ]
    }
    """

    public static let transactionJson = """
    {
    "id": "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a",
    "trx": {
        "receipt": {
            "status": "executed",
            "cpu_usage_us": 3837,
            "net_usage_words": 36,
            "trx": [
                1,
                {
                    "signatures": [
                        "SIG_K1_JzFA9ffefWfrTBvpwMwZi81kR6tvHF4mfsRekVXrBjLWWikg9g1FrS9WupYuoGaRew5mJhr4d39tHUjHiNCkxamtEfxi68"
                    ],
                    "compression": "none",
                    "packed_context_free_data": "",
                    "packed_trx": "c62a4f5c1cef3d6d71bd000000000290afc2d800ea3055000000405da7adba0072cbdd956f52acd910c3c958136d72f8560d1846bc7cf3157f5fbfb72d3001de4597f4a1fdbecda6d59c96a43009fc5e5d7b8f639b1269c77cec718460dcc19cb30100a6823403ea3055000000572d3ccdcd0143864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db155624800a6823403ea3055000000572d3ccdcd0100aeaa4ac15cfd4500000000a8ed32323b00aeaa4ac15cfd4500000060d234cd3da06806000000000004454f53000000001a746865206772617373686f70706572206c69657320686561767900"
                }
            ]
        },
        "trx": {
            "expiration": "2019-01-28T16:16:06",
            "ref_block_num": 61212,
            "ref_block_prefix": 3178327357,
            "max_net_usage_words": 0,
            "max_cpu_usage_ms": 0,
            "delay_sec": 0,
            "context_free_actions": [],
            "actions": [
                {
                    "account": "eosio.assert",
                    "name": "require",
                    "authorization": [],
                    "data": {
                        "chain_params_hash": "cbdd956f52acd910c3c958136d72f8560d1846bc7cf3157f5fbfb72d3001de45",
                        "manifest_id": "97f4a1fdbecda6d59c96a43009fc5e5d7b8f639b1269c77cec718460dcc19cb3",
                        "actions": [
                            {
                                "contract": "eosio.token",
                                "action": "transfer"
                            }
                        ],
                        "abi_hashes": [
                            "43864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248"
                        ]
                    },
                    "hex_data": "cbdd956f52acd910c3c958136d72f8560d1846bc7cf3157f5fbfb72d3001de4597f4a1fdbecda6d59c96a43009fc5e5d7b8f639b1269c77cec718460dcc19cb30100a6823403ea3055000000572d3ccdcd0143864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248"
                },
                {
                    "account": "eosio.token",
                    "name": "transfer",
                    "authorization": [
                        {
                            "actor": "cryptkeeper",
                            "permission": "active"
                        }
                    ],
                    "data": {
                        "from": "cryptkeeper",
                        "to": "brandon",
                        "quantity": "42.0000 EOS",
                        "memo": "the grasshopper lies heavy"
                    },
                    "hex_data": "00aeaa4ac15cfd4500000060d234cd3da06806000000000004454f53000000001a746865206772617373686f70706572206c696573206865617679"
                }
            ],
            "transaction_extensions": [],
            "signatures": [
                "SIG_K1_JzFA9ffefWfrTBvpwMwZi81kR6tvHF4mfsRekVXrBjLWWikg9g1FrS9WupYuoGaRew5mJhr4d39tHUjHiNCkxamtEfxi68"
            ],
            "context_free_data": []
        }
    },
    "block_time": "2019-01-28T16:15:37.500",
    "block_num": 21098575,
    "last_irreversible_block": 21127814,
    "traces": []
    }
    """

    public static let keyAccountsJson = """
    {
    "account_names": [
        "cryptkeeper",
        "example"
    ]
    }
    """

    public static let pushTransactionsJson = """
    [
    {
        "transaction_id": "2de4cd382c2e231c8a3ac80acfcea493dd2d9e7178b46d165283cf91c2ce6121",
        "processed": {
            "id": "2de4cd382c2e231c8a3ac80acfcea493dd2d9e7178b46d165283cf91c2ce6121",
            "block_num": 21102318,
            "block_time": "2019-01-28T16:46:49.000",
            "producer_block_id": null,
            "receipt": {
                "status": "executed",
                "cpu_usage_us": 2072,
                "net_usage_words": 36
            },
            "elapsed": 2072,
            "net_usage": 288,
            "scheduled": false,
            "action_traces": [
                {
                    "receipt": {
                        "receiver": "eosio.assert",
                        "act_digest": "a4caeedd5e5824dd916c1aaabc84f0a114ddbda83728c8c23ba859d4a8a93721",
                        "global_sequence": 21107628,
                        "recv_sequence": 333,
                        "auth_sequence": [],
                        "code_sequence": 1,
                        "abi_sequence": 1
                    },
                    "act": {
                        "account": "eosio.assert",
                        "name": "require",
                        "authorization": [],
                        "data": {
                            "chain_params_hash": "cbdd956f52acd910c3c958136d72f8560d1846bc7cf3157f5fbfb72d3001de45",
                            "manifest_id": "97f4a1fdbecda6d59c96a43009fc5e5d7b8f639b1269c77cec718460dcc19cb3",
                            "actions": [
                                {
                                    "contract": "eosio.token",
                                    "action": "transfer"
                                }
                            ],
                            "abi_hashes": [
                                "43864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248"
                            ]
                        },
                        "hex_data": "cbdd956f52acd910c3c958136d72f8560d1846bc7cf3157f5fbfb72d3001de4597f4a1fdbecda6d59c96a43009fc5e5d7b8f639b1269c77cec718460dcc19cb30100a6823403ea3055000000572d3ccdcd0143864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248"
                    },
                    "context_free": false,
                    "elapsed": 1183,
                    "cpu_usage": 0,
                    "console": "",
                    "total_cpu_usage": 0,
                    "trx_id": "2de4cd382c2e231c8a3ac80acfcea493dd2d9e7178b46d165283cf91c2ce6121",
                    "block_num": 21102318,
                    "block_time": "2019-01-28T16:46:49.000",
                    "producer_block_id": null,
                    "account_ram_deltas": [],
                    "inline_traces": []
                },
                {
                    "receipt": {
                        "receiver": "eosio.token",
                        "act_digest": "9eab239d66d13c34b9cc35a6f79fb2f6d61a2d9df9a484075c82e65d73a0cbc8",
                        "global_sequence": 21107629,
                        "recv_sequence": 1369,
                        "auth_sequence": [
                            [
                                "cryptkeeper",
                                878
                            ]
                        ],
                        "code_sequence": 1,
                        "abi_sequence": 4
                    },
                    "act": {
                        "account": "eosio.token",
                        "name": "transfer",
                        "authorization": [
                            {
                                "actor": "cryptkeeper",
                                "permission": "active"
                            }
                        ],
                        "data": {
                            "from": "cryptkeeper",
                            "to": "brandon",
                            "quantity": "42.0000 EOS",
                            "memo": "the grasshopper lies heavy"
                        },
                        "hex_data": "00aeaa4ac15cfd4500000060d234cd3da06806000000000004454f53000000001a746865206772617373686f70706572206c696573206865617679"
                    },
                    "context_free": false,
                    "elapsed": 548,
                    "cpu_usage": 0,
                    "console": "",
                    "total_cpu_usage": 0,
                    "trx_id": "2de4cd382c2e231c8a3ac80acfcea493dd2d9e7178b46d165283cf91c2ce6121",
                    "block_num": 21102318,
                    "block_time": "2019-01-28T16:46:49.000",
                    "producer_block_id": null,
                    "account_ram_deltas": [],
                    "inline_traces": [
                        {
                            "receipt": {
                                "receiver": "cryptkeeper",
                                "act_digest": "9eab239d66d13c34b9cc35a6f79fb2f6d61a2d9df9a484075c82e65d73a0cbc8",
                                "global_sequence": 21107630,
                                "recv_sequence": 497,
                                "auth_sequence": [
                                    [
                                        "cryptkeeper",
                                        879
                                    ]
                                ],
                                "code_sequence": 1,
                                "abi_sequence": 4
                            },
                            "act": {
                                "account": "eosio.token",
                                "name": "transfer",
                                "authorization": [
                                    {
                                        "actor": "cryptkeeper",
                                        "permission": "active"
                                    }
                                ],
                                "data": {
                                    "from": "cryptkeeper",
                                    "to": "brandon",
                                    "quantity": "42.0000 EOS",
                                    "memo": "the grasshopper lies heavy"
                                },
                                "hex_data": "00aeaa4ac15cfd4500000060d234cd3da06806000000000004454f53000000001a746865206772617373686f70706572206c696573206865617679"
                            },
                            "context_free": false,
                            "elapsed": 4,
                            "cpu_usage": 0,
                            "console": "",
                            "total_cpu_usage": 0,
                            "trx_id": "2de4cd382c2e231c8a3ac80acfcea493dd2d9e7178b46d165283cf91c2ce6121",
                            "block_num": 21102318,
                            "block_time": "2019-01-28T16:46:49.000",
                            "producer_block_id": null,
                            "account_ram_deltas": [],
                            "inline_traces": []
                        },
                        {
                            "receipt": {
                                "receiver": "brandon",
                                "act_digest": "9eab239d66d13c34b9cc35a6f79fb2f6d61a2d9df9a484075c82e65d73a0cbc8",
                                "global_sequence": 21107631,
                                "recv_sequence": 583,
                                "auth_sequence": [
                                    [
                                        "cryptkeeper",
                                        880
                                    ]
                                ],
                                "code_sequence": 1,
                                "abi_sequence": 4
                            },
                            "act": {
                                "account": "eosio.token",
                                "name": "transfer",
                                "authorization": [
                                    {
                                        "actor": "cryptkeeper",
                                        "permission": "active"
                                    }
                                ],
                                "data": {
                                    "from": "cryptkeeper",
                                    "to": "brandon",
                                    "quantity": "42.0000 EOS",
                                    "memo": "the grasshopper lies heavy"
                                },
                                "hex_data": "00aeaa4ac15cfd4500000060d234cd3da06806000000000004454f53000000001a746865206772617373686f70706572206c696573206865617679"
                            },
                            "context_free": false,
                            "elapsed": 6,
                            "cpu_usage": 0,
                            "console": "",
                            "total_cpu_usage": 0,
                            "trx_id": "2de4cd382c2e231c8a3ac80acfcea493dd2d9e7178b46d165283cf91c2ce6121",
                            "block_num": 21102318,
                            "block_time": "2019-01-28T16:46:49.000",
                            "producer_block_id": null,
                            "account_ram_deltas": [],
                            "inline_traces": []
                        }
                    ]
                }
            ],
            "except": null
        }
    },
    {
        "transaction_id": "8bddd86928d396dcec91e15d910086a4f8682167ff9616a84f23de63258c78fe",
        "processed": {
            "id": "8bddd86928d396dcec91e15d910086a4f8682167ff9616a84f23de63258c78fe",
            "block_num": 21102318,
            "block_time": "2019-01-28T16:46:49.000",
            "producer_block_id": null,
            "receipt": {
                "status": "executed",
                "cpu_usage_us": 1492,
                "net_usage_words": 36
            },
            "elapsed": 1492,
            "net_usage": 288,
            "scheduled": false,
            "action_traces": [
                {
                    "receipt": {
                        "receiver": "eosio.assert",
                        "act_digest": "a4caeedd5e5824dd916c1aaabc84f0a114ddbda83728c8c23ba859d4a8a93721",
                        "global_sequence": 21107632,
                        "recv_sequence": 334,
                        "auth_sequence": [],
                        "code_sequence": 1,
                        "abi_sequence": 1
                    },
                    "act": {
                        "account": "eosio.assert",
                        "name": "require",
                        "authorization": [],
                        "data": {
                            "chain_params_hash": "cbdd956f52acd910c3c958136d72f8560d1846bc7cf3157f5fbfb72d3001de45",
                            "manifest_id": "97f4a1fdbecda6d59c96a43009fc5e5d7b8f639b1269c77cec718460dcc19cb3",
                            "actions": [
                                {
                                    "contract": "eosio.token",
                                    "action": "transfer"
                                }
                            ],
                            "abi_hashes": [
                                "43864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248"
                            ]
                        },
                        "hex_data": "cbdd956f52acd910c3c958136d72f8560d1846bc7cf3157f5fbfb72d3001de4597f4a1fdbecda6d59c96a43009fc5e5d7b8f639b1269c77cec718460dcc19cb30100a6823403ea3055000000572d3ccdcd0143864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248"
                    },
                    "context_free": false,
                    "elapsed": 807,
                    "cpu_usage": 0,
                    "console": "",
                    "total_cpu_usage": 0,
                    "trx_id": "8bddd86928d396dcec91e15d910086a4f8682167ff9616a84f23de63258c78fe",
                    "block_num": 21102318,
                    "block_time": "2019-01-28T16:46:49.000",
                    "producer_block_id": null,
                    "account_ram_deltas": [],
                    "inline_traces": []
                },
                {
                    "receipt": {
                        "receiver": "eosio.token",
                        "act_digest": "9eab239d66d13c34b9cc35a6f79fb2f6d61a2d9df9a484075c82e65d73a0cbc8",
                        "global_sequence": 21107633,
                        "recv_sequence": 1370,
                        "auth_sequence": [
                            [
                                "cryptkeeper",
                                881
                            ]
                        ],
                        "code_sequence": 1,
                        "abi_sequence": 4
                    },
                    "act": {
                        "account": "eosio.token",
                        "name": "transfer",
                        "authorization": [
                            {
                                "actor": "cryptkeeper",
                                "permission": "active"
                            }
                        ],
                        "data": {
                            "from": "cryptkeeper",
                            "to": "brandon",
                            "quantity": "42.0000 EOS",
                            "memo": "the grasshopper lies heavy"
                        },
                        "hex_data": "00aeaa4ac15cfd4500000060d234cd3da06806000000000004454f53000000001a746865206772617373686f70706572206c696573206865617679"
                    },
                    "context_free": false,
                    "elapsed": 440,
                    "cpu_usage": 0,
                    "console": "",
                    "total_cpu_usage": 0,
                    "trx_id": "8bddd86928d396dcec91e15d910086a4f8682167ff9616a84f23de63258c78fe",
                    "block_num": 21102318,
                    "block_time": "2019-01-28T16:46:49.000",
                    "producer_block_id": null,
                    "account_ram_deltas": [],
                    "inline_traces": [
                        {
                            "receipt": {
                                "receiver": "cryptkeeper",
                                "act_digest": "9eab239d66d13c34b9cc35a6f79fb2f6d61a2d9df9a484075c82e65d73a0cbc8",
                                "global_sequence": 21107634,
                                "recv_sequence": 498,
                                "auth_sequence": [
                                    [
                                        "cryptkeeper",
                                        882
                                    ]
                                ],
                                "code_sequence": 1,
                                "abi_sequence": 4
                            },
                            "act": {
                                "account": "eosio.token",
                                "name": "transfer",
                                "authorization": [
                                    {
                                        "actor": "cryptkeeper",
                                        "permission": "active"
                                    }
                                ],
                                "data": {
                                    "from": "cryptkeeper",
                                    "to": "brandon",
                                    "quantity": "42.0000 EOS",
                                    "memo": "the grasshopper lies heavy"
                                },
                                "hex_data": "00aeaa4ac15cfd4500000060d234cd3da06806000000000004454f53000000001a746865206772617373686f70706572206c696573206865617679"
                            },
                            "context_free": false,
                            "elapsed": 2,
                            "cpu_usage": 0,
                            "console": "",
                            "total_cpu_usage": 0,
                            "trx_id": "8bddd86928d396dcec91e15d910086a4f8682167ff9616a84f23de63258c78fe",
                            "block_num": 21102318,
                            "block_time": "2019-01-28T16:46:49.000",
                            "producer_block_id": null,
                            "account_ram_deltas": [],
                            "inline_traces": []
                        },
                        {
                            "receipt": {
                                "receiver": "brandon",
                                "act_digest": "9eab239d66d13c34b9cc35a6f79fb2f6d61a2d9df9a484075c82e65d73a0cbc8",
                                "global_sequence": 21107635,
                                "recv_sequence": 584,
                                "auth_sequence": [
                                    [
                                        "cryptkeeper",
                                        883
                                    ]
                                ],
                                "code_sequence": 1,
                                "abi_sequence": 4
                            },
                            "act": {
                                "account": "eosio.token",
                                "name": "transfer",
                                "authorization": [
                                    {
                                        "actor": "cryptkeeper",
                                        "permission": "active"
                                    }
                                ],
                                "data": {
                                    "from": "cryptkeeper",
                                    "to": "brandon",
                                    "quantity": "42.0000 EOS",
                                    "memo": "the grasshopper lies heavy"
                                },
                                "hex_data": "00aeaa4ac15cfd4500000060d234cd3da06806000000000004454f53000000001a746865206772617373686f70706572206c696573206865617679"
                            },
                            "context_free": false,
                            "elapsed": 3,
                            "cpu_usage": 0,
                            "console": "",
                            "total_cpu_usage": 0,
                            "trx_id": "8bddd86928d396dcec91e15d910086a4f8682167ff9616a84f23de63258c78fe",
                            "block_num": 21102318,
                            "block_time": "2019-01-28T16:46:49.000",
                            "producer_block_id": null,
                            "account_ram_deltas": [],
                            "inline_traces": []
                        }
                    ]
                }
            ],
            "except": null
        }
    }
    ]
    """

    public static let sendTransActionResponseJson = """
    {
        "processed": {
            "account_ram_delta": null,
            "action_traces": [
                {
                    "account_ram_deltas": [],
                    "act": {
                        "account": "eosio.token",
                        "authorization": [
                            {
                                "actor": "swdev1212121",
                                "permission": "active"
                            }
                        ],
                        "data": {
                            "from": "swdev1212121",
                            "memo": "",
                            "quantity": "1.0000 EOS",
                            "to": "paulk1111111"
                        },
                        "hex_data": "1044104184ad12c7104208210418b5a9102700000000000004454f530000000000",
                        "name": "transfer"
                    },
                    "action_ordinal": 1,
                    "block_num": 56110902,
                    "block_time": "2019-10-22T15:32:46.000",
                    "closest_unnotified_ancestor_action_ordinal": 0,
                    "console": "",
                    "context_free": false,
                    "creator_action_ordinal": 0,
                    "elapsed": 65,
                    "error_code": null,
                    "except": null,
                    "producer_block_id": null,
                    "receipt": {
                        "abi_sequence": 4,
                        "act_digest": "fc7afe8d172f698189449bf95d6a2a193e27759a264e21741e00872a48a5ec39",
                        "auth_sequence": [
                            [
                                "swdev1212121",
                                28
                            ]
                        ],
                        "code_sequence": 5,
                        "global_sequence": 498392582,
                        "receiver": "eosio.token",
                        "recv_sequence": 76627315
                    },
                    "receiver": "eosio.token",
                    "trx_id": "2e611730d904777d5da89e844cac4936da0ff844ad8e3c7eccd5da912423c9e9"
                },
                {
                    "account_ram_deltas": [],
                    "act": {
                        "account": "eosio.token",
                        "authorization": [
                            {
                                "actor": "swdev1212121",
                                "permission": "active"
                            }
                        ],
                        "data": {
                            "from": "swdev1212121",
                            "memo": "",
                            "quantity": "1.0000 EOS",
                            "to": "paulk1111111"
                        },
                        "hex_data": "1044104184ad12c7104208210418b5a9102700000000000004454f530000000000",
                        "name": "transfer"
                    },
                    "action_ordinal": 2,
                    "block_num": 56110902,
                    "block_time": "2019-10-22T15:32:46.000",
                    "closest_unnotified_ancestor_action_ordinal": 1,
                    "console": "",
                    "context_free": false,
                    "creator_action_ordinal": 1,
                    "elapsed": 2,
                    "error_code": null,
                    "except": null,
                    "producer_block_id": null,
                    "receipt": {
                        "abi_sequence": 4,
                        "act_digest": "fc7afe8d172f698189449bf95d6a2a193e27759a264e21741e00872a48a5ec39",
                        "auth_sequence": [
                            [
                                "swdev1212121",
                                29
                            ]
                        ],
                        "code_sequence": 5,
                        "global_sequence": 498392583,
                        "receiver": "swdev1212121",
                        "recv_sequence": 18
                    },
                    "receiver": "swdev1212121",
                    "trx_id": "2e611730d904777d5da89e844cac4936da0ff844ad8e3c7eccd5da912423c9e9"
                },
                {
                    "account_ram_deltas": [],
                    "act": {
                        "account": "eosio.token",
                        "authorization": [
                            {
                                "actor": "swdev1212121",
                                "permission": "active"
                            }
                        ],
                        "data": {
                            "from": "swdev1212121",
                            "memo": "",
                            "quantity": "1.0000 EOS",
                            "to": "paulk1111111"
                        },
                        "hex_data": "1044104184ad12c7104208210418b5a9102700000000000004454f530000000000",
                        "name": "transfer"
                    },
                    "action_ordinal": 3,
                    "block_num": 56110902,
                    "block_time": "2019-10-22T15:32:46.000",
                    "closest_unnotified_ancestor_action_ordinal": 1,
                    "console": "",
                    "context_free": false,
                    "creator_action_ordinal": 1,
                    "elapsed": 7,
                    "error_code": null,
                    "except": null,
                    "producer_block_id": null,
                    "receipt": {
                        "abi_sequence": 4,
                        "act_digest": "fc7afe8d172f698189449bf95d6a2a193e27759a264e21741e00872a48a5ec39",
                        "auth_sequence": [
                            [
                                "swdev1212121",
                                30
                            ]
                        ],
                        "code_sequence": 5,
                        "global_sequence": 498392584,
                        "receiver": "paulk1111111",
                        "recv_sequence": 19
                    },
                    "receiver": "paulk1111111",
                    "trx_id": "2e611730d904777d5da89e844cac4936da0ff844ad8e3c7eccd5da912423c9e9"
                }
            ],
            "block_num": 56110902,
            "block_time": "2019-10-22T15:32:46.000",
            "elapsed": 237,
            "error_code": null,
            "except": null,
            "id": "2e611730d904777d5da89e844cac4936da0ff844ad8e3c7eccd5da912423c9e9",
            "net_usage": 128,
            "producer_block_id": null,
            "receipt": {
                "cpu_usage_us": 237,
                "net_usage_words": 16,
                "status": "executed"
            },
            "scheduled": false
        },
        "transaction_id": "2e611730d904777d5da89e844cac4936da0ff844ad8e3c7eccd5da912423c9e9"
    }
    """

    public static func createRawApiResponseJson(account: EosioName) -> String? {
        let json: String
        switch account.string {
        case "eosio.token":
            json = """
            {
            "account_name": "eosio.token",
            "code_hash": "3e0cf4172ab025f9fff5f1db11ee8a34d44779492e1d668ae1dc2d129e865348",
            "abi_hash": "43864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248",
            "abi": "DmVvc2lvOjphYmkvMS4wAQxhY2NvdW50X25hbWUEbmFtZQUIdHJhbnNmZXIABARmcm9tDGFjY291bnRfbmFtZQJ0bwxhY2NvdW50X25hbWUIcXVhbnRpdHkFYXNzZXQEbWVtbwZzdHJpbmcGY3JlYXRlAAIGaXNzdWVyDGFjY291bnRfbmFtZQ5tYXhpbXVtX3N1cHBseQVhc3NldAVpc3N1ZQADAnRvDGFjY291bnRfbmFtZQhxdWFudGl0eQVhc3NldARtZW1vBnN0cmluZwdhY2NvdW50AAEHYmFsYW5jZQVhc3NldA5jdXJyZW5jeV9zdGF0cwADBnN1cHBseQVhc3NldAptYXhfc3VwcGx5BWFzc2V0Bmlzc3VlcgxhY2NvdW50X25hbWUDAAAAVy08zc0IdHJhbnNmZXK8By0tLQp0aXRsZTogVG9rZW4gVHJhbnNmZXIKc3VtbWFyeTogVHJhbnNmZXIgdG9rZW5zIGZyb20gb25lIGFjY291bnQgdG8gYW5vdGhlci4KaWNvbjogaHR0cHM6Ly9jZG4udGVzdG5ldC5kZXYuYjFvcHMubmV0L3Rva2VuLXRyYW5zZmVyLnBuZyNjZTUxZWY5ZjllZWNhMzQzNGU4NTUwN2UwZWQ0OWU3NmZmZjEyNjU0MjJiZGVkMDI1NWYzMTk2ZWE1OWM4YjBjCi0tLQoKIyMgVHJhbnNmZXIgVGVybXMgJiBDb25kaXRpb25zCgpJLCB7e2Zyb219fSwgY2VydGlmeSB0aGUgZm9sbG93aW5nIHRvIGJlIHRydWUgdG8gdGhlIGJlc3Qgb2YgbXkga25vd2xlZGdlOgoKMS4gSSBjZXJ0aWZ5IHRoYXQge3txdWFudGl0eX19IGlzIG5vdCB0aGUgcHJvY2VlZHMgb2YgZnJhdWR1bGVudCBvciB2aW9sZW50IGFjdGl2aXRpZXMuCjIuIEkgY2VydGlmeSB0aGF0LCB0byB0aGUgYmVzdCBvZiBteSBrbm93bGVkZ2UsIHt7dG99fSBpcyBub3Qgc3VwcG9ydGluZyBpbml0aWF0aW9uIG9mIHZpb2xlbmNlIGFnYWluc3Qgb3RoZXJzLgozLiBJIGhhdmUgZGlzY2xvc2VkIGFueSBjb250cmFjdHVhbCB0ZXJtcyAmIGNvbmRpdGlvbnMgd2l0aCByZXNwZWN0IHRvIHt7cXVhbnRpdHl9fSB0byB7e3RvfX0uCgpJIHVuZGVyc3RhbmQgdGhhdCBmdW5kcyB0cmFuc2ZlcnMgYXJlIG5vdCByZXZlcnNpYmxlIGFmdGVyIHRoZSB7eyR0cmFuc2FjdGlvbi5kZWxheV9zZWN9fSBzZWNvbmRzIG9yIG90aGVyIGRlbGF5IGFzIGNvbmZpZ3VyZWQgYnkge3tmcm9tfX0ncyBwZXJtaXNzaW9ucy4KCklmIHRoaXMgYWN0aW9uIGZhaWxzIHRvIGJlIGlycmV2ZXJzaWJseSBjb25maXJtZWQgYWZ0ZXIgcmVjZWl2aW5nIGdvb2RzIG9yIHNlcnZpY2VzIGZyb20gJ3t7dG99fScsIEkgYWdyZWUgdG8gZWl0aGVyIHJldHVybiB0aGUgZ29vZHMgb3Igc2VydmljZXMgb3IgcmVzZW5kIHt7cXVhbnRpdHl9fSBpbiBhIHRpbWVseSBtYW5uZXIuAAAAAAClMXYFaXNzdWUAAAAAAKhs1EUGY3JlYXRlAAIAAAA4T00RMgNpNjQBCGN1cnJlbmN5AQZ1aW50NjQHYWNjb3VudAAAAAAAkE3GA2k2NAEIY3VycmVuY3kBBnVpbnQ2NA5jdXJyZW5jeV9zdGF0cwAAAAA=="
            }
            """
        case "eosio":
            json = """
            {
            "account_name": "eosio",
            "code_hash": "add7914493bb911bbc179b19115032bbaae1f567f733391060edfaf79a6c8096",
            "abi_hash": "d745bac0c38f95613e0c1c2da58e92de1e8e94d658d64a00293570cc251d1441",
            "abi": "DmVvc2lvOjphYmkvMS4xADYIYWJpX2hhc2gAAgVvd25lcgRuYW1lBGhhc2gLY2hlY2tzdW0yNTYJYXV0aG9yaXR5AAQJdGhyZXNob2xkBnVpbnQzMgRrZXlzDGtleV93ZWlnaHRbXQhhY2NvdW50cxlwZXJtaXNzaW9uX2xldmVsX3dlaWdodFtdBXdhaXRzDXdhaXRfd2VpZ2h0W10KYmlkX3JlZnVuZAACBmJpZGRlcgRuYW1lBmFtb3VudAVhc3NldAdiaWRuYW1lAAMGYmlkZGVyBG5hbWUHbmV3bmFtZQRuYW1lA2JpZAVhc3NldAliaWRyZWZ1bmQAAgZiaWRkZXIEbmFtZQduZXduYW1lBG5hbWUMYmxvY2tfaGVhZGVyAAgJdGltZXN0YW1wBnVpbnQzMghwcm9kdWNlcgRuYW1lCWNvbmZpcm1lZAZ1aW50MTYIcHJldmlvdXMLY2hlY2tzdW0yNTYRdHJhbnNhY3Rpb25fbXJvb3QLY2hlY2tzdW0yNTYMYWN0aW9uX21yb290C2NoZWNrc3VtMjU2EHNjaGVkdWxlX3ZlcnNpb24GdWludDMyDW5ld19wcm9kdWNlcnMScHJvZHVjZXJfc2NoZWR1bGU/FWJsb2NrY2hhaW5fcGFyYW1ldGVycwARE21heF9ibG9ja19uZXRfdXNhZ2UGdWludDY0GnRhcmdldF9ibG9ja19uZXRfdXNhZ2VfcGN0BnVpbnQzMhltYXhfdHJhbnNhY3Rpb25fbmV0X3VzYWdlBnVpbnQzMh5iYXNlX3Blcl90cmFuc2FjdGlvbl9uZXRfdXNhZ2UGdWludDMyEG5ldF91c2FnZV9sZWV3YXkGdWludDMyI2NvbnRleHRfZnJlZV9kaXNjb3VudF9uZXRfdXNhZ2VfbnVtBnVpbnQzMiNjb250ZXh0X2ZyZWVfZGlzY291bnRfbmV0X3VzYWdlX2RlbgZ1aW50MzITbWF4X2Jsb2NrX2NwdV91c2FnZQZ1aW50MzIadGFyZ2V0X2Jsb2NrX2NwdV91c2FnZV9wY3QGdWludDMyGW1heF90cmFuc2FjdGlvbl9jcHVfdXNhZ2UGdWludDMyGW1pbl90cmFuc2FjdGlvbl9jcHVfdXNhZ2UGdWludDMyGG1heF90cmFuc2FjdGlvbl9saWZldGltZQZ1aW50MzIeZGVmZXJyZWRfdHJ4X2V4cGlyYXRpb25fd2luZG93BnVpbnQzMhVtYXhfdHJhbnNhY3Rpb25fZGVsYXkGdWludDMyFm1heF9pbmxpbmVfYWN0aW9uX3NpemUGdWludDMyF21heF9pbmxpbmVfYWN0aW9uX2RlcHRoBnVpbnQxNhNtYXhfYXV0aG9yaXR5X2RlcHRoBnVpbnQxNgZidXlyYW0AAwVwYXllcgRuYW1lCHJlY2VpdmVyBG5hbWUFcXVhbnQFYXNzZXQLYnV5cmFtYnl0ZXMAAwVwYXllcgRuYW1lCHJlY2VpdmVyBG5hbWUFYnl0ZXMGdWludDMyC2NhbmNlbGRlbGF5AAIOY2FuY2VsaW5nX2F1dGgQcGVybWlzc2lvbl9sZXZlbAZ0cnhfaWQLY2hlY2tzdW0yNTYMY2xhaW1yZXdhcmRzAAEFb3duZXIEbmFtZQljb25uZWN0b3IAAgdiYWxhbmNlBWFzc2V0BndlaWdodAdmbG9hdDY0CmRlbGVnYXRlYncABQRmcm9tBG5hbWUIcmVjZWl2ZXIEbmFtZRJzdGFrZV9uZXRfcXVhbnRpdHkFYXNzZXQSc3Rha2VfY3B1X3F1YW50aXR5BWFzc2V0CHRyYW5zZmVyBGJvb2wTZGVsZWdhdGVkX2JhbmR3aWR0aAAEBGZyb20EbmFtZQJ0bwRuYW1lCm5ldF93ZWlnaHQFYXNzZXQKY3B1X3dlaWdodAVhc3NldApkZWxldGVhdXRoAAIHYWNjb3VudARuYW1lCnBlcm1pc3Npb24EbmFtZRJlb3Npb19nbG9iYWxfc3RhdGUVYmxvY2tjaGFpbl9wYXJhbWV0ZXJzDQxtYXhfcmFtX3NpemUGdWludDY0GHRvdGFsX3JhbV9ieXRlc19yZXNlcnZlZAZ1aW50NjQPdG90YWxfcmFtX3N0YWtlBWludDY0HWxhc3RfcHJvZHVjZXJfc2NoZWR1bGVfdXBkYXRlFGJsb2NrX3RpbWVzdGFtcF90eXBlGGxhc3RfcGVydm90ZV9idWNrZXRfZmlsbAp0aW1lX3BvaW50DnBlcnZvdGVfYnVja2V0BWludDY0D3BlcmJsb2NrX2J1Y2tldAVpbnQ2NBN0b3RhbF91bnBhaWRfYmxvY2tzBnVpbnQzMhV0b3RhbF9hY3RpdmF0ZWRfc3Rha2UFaW50NjQbdGhyZXNoX2FjdGl2YXRlZF9zdGFrZV90aW1lCnRpbWVfcG9pbnQbbGFzdF9wcm9kdWNlcl9zY2hlZHVsZV9zaXplBnVpbnQxNhp0b3RhbF9wcm9kdWNlcl92b3RlX3dlaWdodAdmbG9hdDY0D2xhc3RfbmFtZV9jbG9zZRRibG9ja190aW1lc3RhbXBfdHlwZRNlb3Npb19nbG9iYWxfc3RhdGUyAAURbmV3X3JhbV9wZXJfYmxvY2sGdWludDE2EWxhc3RfcmFtX2luY3JlYXNlFGJsb2NrX3RpbWVzdGFtcF90eXBlDmxhc3RfYmxvY2tfbnVtFGJsb2NrX3RpbWVzdGFtcF90eXBlHHRvdGFsX3Byb2R1Y2VyX3ZvdGVwYXlfc2hhcmUHZmxvYXQ2NAhyZXZpc2lvbgV1aW50OBNlb3Npb19nbG9iYWxfc3RhdGUzAAIWbGFzdF92cGF5X3N0YXRlX3VwZGF0ZQp0aW1lX3BvaW50HHRvdGFsX3ZwYXlfc2hhcmVfY2hhbmdlX3JhdGUHZmxvYXQ2NA5leGNoYW5nZV9zdGF0ZQADBnN1cHBseQVhc3NldARiYXNlCWNvbm5lY3RvcgVxdW90ZQljb25uZWN0b3IEaW5pdAACB3ZlcnNpb24JdmFydWludDMyBGNvcmUGc3ltYm9sCmtleV93ZWlnaHQAAgNrZXkKcHVibGljX2tleQZ3ZWlnaHQGdWludDE2CGxpbmthdXRoAAQHYWNjb3VudARuYW1lBGNvZGUEbmFtZQR0eXBlBG5hbWULcmVxdWlyZW1lbnQEbmFtZQhuYW1lX2JpZAAEB25ld25hbWUEbmFtZQtoaWdoX2JpZGRlcgRuYW1lCGhpZ2hfYmlkBWludDY0DWxhc3RfYmlkX3RpbWUKdGltZV9wb2ludApuZXdhY2NvdW50AAQHY3JlYXRvcgRuYW1lBG5hbWUEbmFtZQVvd25lcglhdXRob3JpdHkGYWN0aXZlCWF1dGhvcml0eQdvbmJsb2NrAAEGaGVhZGVyDGJsb2NrX2hlYWRlcgdvbmVycm9yAAIJc2VuZGVyX2lkB3VpbnQxMjgIc2VudF90cngFYnl0ZXMQcGVybWlzc2lvbl9sZXZlbAACBWFjdG9yBG5hbWUKcGVybWlzc2lvbgRuYW1lF3Blcm1pc3Npb25fbGV2ZWxfd2VpZ2h0AAIKcGVybWlzc2lvbhBwZXJtaXNzaW9uX2xldmVsBndlaWdodAZ1aW50MTYNcHJvZHVjZXJfaW5mbwAIBW93bmVyBG5hbWULdG90YWxfdm90ZXMHZmxvYXQ2NAxwcm9kdWNlcl9rZXkKcHVibGljX2tleQlpc19hY3RpdmUEYm9vbAN1cmwGc3RyaW5nDXVucGFpZF9ibG9ja3MGdWludDMyD2xhc3RfY2xhaW1fdGltZQp0aW1lX3BvaW50CGxvY2F0aW9uBnVpbnQxNg5wcm9kdWNlcl9pbmZvMgADBW93bmVyBG5hbWUNdm90ZXBheV9zaGFyZQdmbG9hdDY0GWxhc3Rfdm90ZXBheV9zaGFyZV91cGRhdGUKdGltZV9wb2ludAxwcm9kdWNlcl9rZXkAAg1wcm9kdWNlcl9uYW1lBG5hbWURYmxvY2tfc2lnbmluZ19rZXkKcHVibGljX2tleRFwcm9kdWNlcl9zY2hlZHVsZQACB3ZlcnNpb24GdWludDMyCXByb2R1Y2Vycw5wcm9kdWNlcl9rZXlbXQZyZWZ1bmQAAQVvd25lcgRuYW1lDnJlZnVuZF9yZXF1ZXN0AAQFb3duZXIEbmFtZQxyZXF1ZXN0X3RpbWUOdGltZV9wb2ludF9zZWMKbmV0X2Ftb3VudAVhc3NldApjcHVfYW1vdW50BWFzc2V0C3JlZ3Byb2R1Y2VyAAQIcHJvZHVjZXIEbmFtZQxwcm9kdWNlcl9rZXkKcHVibGljX2tleQN1cmwGc3RyaW5nCGxvY2F0aW9uBnVpbnQxNghyZWdwcm94eQACBXByb3h5BG5hbWUHaXNwcm94eQRib29sC3JtdnByb2R1Y2VyAAEIcHJvZHVjZXIEbmFtZQdzZWxscmFtAAIHYWNjb3VudARuYW1lBWJ5dGVzBWludDY0BnNldGFiaQACB2FjY291bnQEbmFtZQNhYmkFYnl0ZXMKc2V0YWxpbWl0cwAEB2FjY291bnQEbmFtZQlyYW1fYnl0ZXMFaW50NjQKbmV0X3dlaWdodAVpbnQ2NApjcHVfd2VpZ2h0BWludDY0B3NldGNvZGUABAdhY2NvdW50BG5hbWUGdm10eXBlBXVpbnQ4CXZtdmVyc2lvbgV1aW50OARjb2RlBWJ5dGVzCXNldHBhcmFtcwABBnBhcmFtcxVibG9ja2NoYWluX3BhcmFtZXRlcnMHc2V0cHJpdgACB2FjY291bnQEbmFtZQdpc19wcml2BXVpbnQ4BnNldHJhbQABDG1heF9yYW1fc2l6ZQZ1aW50NjQKc2V0cmFtcmF0ZQABD2J5dGVzX3Blcl9ibG9jawZ1aW50MTYMdW5kZWxlZ2F0ZWJ3AAQEZnJvbQRuYW1lCHJlY2VpdmVyBG5hbWUUdW5zdGFrZV9uZXRfcXVhbnRpdHkFYXNzZXQUdW5zdGFrZV9jcHVfcXVhbnRpdHkFYXNzZXQKdW5saW5rYXV0aAADB2FjY291bnQEbmFtZQRjb2RlBG5hbWUEdHlwZQRuYW1lCXVucmVncHJvZAABCHByb2R1Y2VyBG5hbWUKdXBkYXRlYXV0aAAEB2FjY291bnQEbmFtZQpwZXJtaXNzaW9uBG5hbWUGcGFyZW50BG5hbWUEYXV0aAlhdXRob3JpdHkMdXBkdHJldmlzaW9uAAEIcmV2aXNpb24FdWludDgOdXNlcl9yZXNvdXJjZXMABAVvd25lcgRuYW1lCm5ldF93ZWlnaHQFYXNzZXQKY3B1X3dlaWdodAVhc3NldAlyYW1fYnl0ZXMFaW50NjQMdm90ZXByb2R1Y2VyAAMFdm90ZXIEbmFtZQVwcm94eQRuYW1lCXByb2R1Y2VycwZuYW1lW10Kdm90ZXJfaW5mbwAKBW93bmVyBG5hbWUFcHJveHkEbmFtZQlwcm9kdWNlcnMGbmFtZVtdBnN0YWtlZAVpbnQ2NBBsYXN0X3ZvdGVfd2VpZ2h0B2Zsb2F0NjQTcHJveGllZF92b3RlX3dlaWdodAdmbG9hdDY0CGlzX3Byb3h5BGJvb2wJcmVzZXJ2ZWQxBnVpbnQzMglyZXNlcnZlZDIGdWludDMyCXJlc2VydmVkMwVhc3NldAt3YWl0X3dlaWdodAACCHdhaXRfc2VjBnVpbnQzMgZ3ZWlnaHQGdWludDE2HwAAAEBJM5M7B2JpZG5hbWUAAABIUy91kzsJYmlkcmVmdW5kAAAAAABIc70+BmJ1eXJhbQAAsMr+SHO9PgtidXlyYW1ieXRlcwAAvIkqRYWmQQtjYW5jZWxkZWxheQCA0zVcXelMRAxjbGFpbXJld2FyZHMAAAA/KhumokoKZGVsZWdhdGVidwAAQMvaqKyiSgpkZWxldGVhdXRoAAAAAAAAkN10BGluaXQAAAAALWsDp4sIbGlua2F1dGgAAECemiJkuJoKbmV3YWNjb3VudAAAAAAAIhrPpAdvbmJsb2NrAAAAAODSe9WkB29uZXJyb3IAAAAAAKSpl7oGcmVmdW5kAACuQjrRW5m6C3JlZ3Byb2R1Y2VyAAAAAL7TW5m6CHJlZ3Byb3h5AACuQjrRW7e8C3JtdnByb2R1Y2VyAAAAAECaG6PCB3NlbGxyYW0AAAAAALhjssIGc2V0YWJpAAAAzk66aLLCCnNldGFsaW1pdHMAAAAAQCWKssIHc2V0Y29kZQAAAMDSXFOzwglzZXRwYXJhbXMAAAAAYLtbs8IHc2V0cHJpdgAAAAAASHOzwgZzZXRyYW0AAIDK5kpzs8IKc2V0cmFtcmF0ZQDAj8qGqajS1Ax1bmRlbGVnYXRlYncAAEDL2sDp4tQKdW5saW5rYXV0aAAAAEj0Vqbu1Al1bnJlZ3Byb2QAAEDL2qhsUtUKdXBkYXRlYXV0aAAwqcNuq5tT1Qx1cGR0cmV2aXNpb24AcBXSid6qMt0Mdm90ZXByb2R1Y2VyAA0AAACgYdPcMQNpNjQAAAhhYmlfaGFzaAAATlMvdZM7A2k2NAAACmJpZF9yZWZ1bmQAAAAgTXOiSgNpNjQAABNkZWxlZ2F0ZWRfYmFuZHdpZHRoAAAAAERzaGQDaTY0AAASZW9zaW9fZ2xvYmFsX3N0YXRlAAAAQERzaGQDaTY0AAATZW9zaW9fZ2xvYmFsX3N0YXRlMgAAAGBEc2hkA2k2NAAAE2Vvc2lvX2dsb2JhbF9zdGF0ZTMAAAA4uaOkmQNpNjQAAAhuYW1lX2JpZAAAwFchneitA2k2NAAADXByb2R1Y2VyX2luZm8AgMBXIZ3orQNpNjQAAA5wcm9kdWNlcl9pbmZvMgAAyApeI6W5A2k2NAAADmV4Y2hhbmdlX3N0YXRlAAAAAKepl7oDaTY0AAAOcmVmdW5kX3JlcXVlc3QAAAAAq3sV1gNpNjQAAA51c2VyX3Jlc291cmNlcwAAAADgqzLdA2k2NAAACnZvdGVyX2luZm8AAAAA="
            }
            """
        default:
            return nil
        }
        return json
    }
    // swiftlint:enable line_length
}
