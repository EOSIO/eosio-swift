//
//  RpcTestConstants.swift
//  EosioSwiftTests
//
//  Created by Ben Martell on 4/12/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import EosioSwift

// swiftlint:disable line_length
public class RpcTestConstants {
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
    public static let requiredKeysResponseJson = """
        {
            "required_keys": [
                               "EOS5j67P1W2RyBXAL8sNzYcDLox3yLpxyrxgkYy1xsXzVCvzbYpba"
                             ]
        }
        """
    public static let pushTransActionResponseJson = """
        {
           "transaction_id": "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a"
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
                "accounts": [],
                "waits": []
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
    //No return structure shown on the documentation page.  "Try It" does not work.  Only the account name is returned, not the ABI so unsure if using it incorrectly or if the end point doesn't do what thought it did? Actual return from call is:
    public static let abiJson = """
    {
    "account_name": "cryptkeeper"
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
    // Online documenation does not provide a return structure and "Try It" button does not work.  Return does not include the **wasm** or **abi** for some reason.  Actual return:
    public static let rawCodeAndAbiJson = """
    {
    "account_name": "cryptkeeper",
    "wasm": "",
    "abi": ""
    }
    """
    // Documenation shows a response structure, but actually calling the API returns a deprecation notice and a JSON error structure:
    public static let codeJson = """
    {
    "code": 500,
    "message": "Internal Service Error",
    "error": {
    "code": 3100008,
    "name": "unsupported_feature",
    "what": "Feature is currently unsupported",
    "details": [
    {
    "message": "Returning WAST from get_code is no longer supported",
    "file": "chain_plugin.cpp",
    "line_number": 1538,
    "method": "get_code"
    }
    ]
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
        }
    ],
    "total_producer_vote_weight": "0.00000000000000000",
    "more": ""
    }
    """
    public static let actionsJson = """
    {
        "actions": [],
        "last_irreversible_block": 21104823
    }
    """
    public static let controlledAccountsJson = """
    {
    "controlled_accounts": []
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
