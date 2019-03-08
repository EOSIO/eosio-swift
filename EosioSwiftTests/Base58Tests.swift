//
//  Base58Tests.swift
//  From https://github.com/cloutiertyler/Base58String
//  MIT License at: https://github.com/cloutiertyler/Base58String/blob/master/LICENSE.md
//
//

import XCTest



class Base58Tests: XCTestCase {
    let testStrings = [
        ("", ""),
        (" ", "Z"),
        ("-", "n"),
        ("0", "q"),
        ("1", "r"),
        ("-1", "4SU"),
        ("11", "4k8"),
        ("abc", "ZiCa"),
        ("1234598760", "3mJr7AoUXx2Wqd"),
        ("abcdefghijklmnopqrstuvwxyz", "3yxU3u1igY8WkgtjK92fbJQCd4BZiiT1v25f"),
        ("00000000000000000000000000000000000000000000000000000000000000", "3sN2THZeE9Eh9eYrwkvZqNstbHGvrxSAM7gXUXvyFQP8XvQLUqNCS27icwUeDT7ckHm4FUHM2mTVh1vbLmk7y")
    ]
    
    let invalidTestStrings = [
        ("0", ""),
        ("O", ""),
        ("I", ""),
        ("l", ""),
        ("3mJr0", ""),
        ("O3yxU", ""),
        ("3sNI", ""),
        ("4kl8", ""),
        ("0OIl", ""),
        ("!@#$%^&*()-_=+~`", "")
    ]
    
    let hexTestStrings = [
        ("61", "2g"),
        ("626262", "a3gV"),
        ("636363", "aPEr"),
        ("73696d706c792061206c6f6e6720737472696e67", "2cFupjhnEsSn59qHXstmK2ffpLv2"),
        ("00eb15231dfceb60925886b67d065299925915aeb172c06647", "1NS17iag9jJgTHD1VXjvLCEnZuQ3rJDE9L"),
        ("516b6fcd0f", "ABnLTmg"),
        ("bf4f89001e670274dd", "3SEo3LWLoPntC"),
        ("572e4794", "3EFU7m"),
        ("ecac89cad93923c02321", "EJDM8drfXA6uyA"),
        ("10c8511e", "Rt5zm"),
        ("00000000000000000000", "1111111111"),
    ]
    
    func testEncodeBase58Strings() {
        for (decoded, encoded) in testStrings {
            
            let bytes = [UInt8](decoded.utf8)
            let result = String(base58Encoding: Data(bytes))
            
            XCTAssertEqual(result, encoded, "Expected encoded string: \(encoded) received: \(result)")
        }
    }
    
    func testDecodeBase58Strings() {
        for (decoded, encoded) in testStrings {
            
            let bytes = Data(base58Decoding: encoded)!
            let result = String(bytes: bytes, encoding: String.Encoding.utf8)!
            
            XCTAssertEqual(result, decoded, "Expected decoded string: \(decoded) received: \(result) bytes: \(Array(bytes))")
        }
    }
    
    func testDecodeInvalidBase58Strings() {
        for (encoded, _) in invalidTestStrings {
            
            let result = Data(base58Decoding: encoded)
            XCTAssertEqual(result, nil, "Invalid string \(encoded) was expected to fail. Instead received \(Array(result!))")
        }
    }
    
    func testPerformanceDecodeShort() {
        let encoded = "1NS17iag9jJgTHD1VXjvLCEnZuQ3rJDE9L"
        self.measure() {
            // Put the code you want to measure the time of here.
            let _ = Data(base58Decoding: encoded)
        }
    }
    
    func testPerformanceEncodeShort() {
        let bytes = Data("1NS17iag9jJgTHD1VXjvLCEnZuQ3rJDE9L".utf8)
        self.measure() {
            // Put the code you want to measure the time of here.
            let _ = String(base58Encoding: bytes)
        }
    }
    
    func testPerformanceDecodeOneKilo() {
        let encoded = "3GimCffBLAHhXMCeNxX2nST6dBem9pbUi3KVKykW73LmewcFtMk9oh9eNPdNR2eSzNqp7Z3E21vrWUkGHzJ7w2yqDUDJ4LKo1w5D6aafZ4SUoNQyrSVxyVG3pwgoZkKXMZVixRyiPZVUpekrsTvZuUoW7mB6BQgDTXbDuMMSRoNR7yiUTKpgwTD61DLmhNZopNxfFjn4avpYPgzsTB94iWueq1yU3EoruWCUMvp6fc1CEbDrZY3pkx9oUbUaSMC37rruBKSSGHh1ZE3XK3kQXBCFraMmUQf8dagofMEg5aTnDiLAZjLyWJMdnQwW1FqKKztP8KAQS2JX8GCCfc68KB4VGf2CfEGXtaapnsNWFrHuWi7Wo5vqyuHd21zGm1u5rsiR6tKNCsFC4nzf3WUNxJNoZrDSdF9KERqhTWWmmcM4qdKRCtBWKTrs1DJD2oiK6BK9BgwoW2dfQdKuxojFyFvmxqPKDDAEZPPpJ51wHoFzBFMM1tUBBkN15cT2GpNwKzDcjHPKJAQ6FNRgppfQytzqpq76sSeZaWAB8hhULMJCQGU57ZUjvP7xYAQwtACBnYrjdxA91XwXFbq5AsQJwAmLw6euKVWNyv11BuHrejVmnNViWg5kuZBrtgL6NtzRWHtdxngHDMtuyky3brqGXaGQhUyXrkSpeknkkHL6NLThHH5NPnfFMVPwn2xf5UM5R51X2nTBzADSVcpi4cT7i44dT7o3yRKWtKfUzZiuNyTcSSrfH8KVdLap5ZKLmdPuXM65M2Z5wJVh3Uc4iv6iZKk44RKikM7zs1hqC4sBxRwLZjxhKvvMXDjDcYFkzyUkues4y7fjdCnVTxc4vTYUqcbY2k2WMssyj9SDseVc7dVrEvWCLQtYy79mJFoz1Hmsfk5ynE28ipznzQ3yTBugLHA6j6qW3S74eY4pJ6iynFEuXT4RqqkLGFcMh3goqS7CkphUMzP4wuJyGnzqa5tCno4U3dJ2jUL7Povg8voRqYAfiHyXC8zuhn225EdmRcSnu2pAuutQVV9hN3bkjfzAFUhUWKki8SwXtFSjy6NJyrYUiaze4p7ApsjHQBCgg2zAoBaGCwVN8991Jny31B5vPyYHy1oRSE4xTVZ7tTw9FyQ7w9p1NSEF4sziCxZHh5rFWZKAajc5c7KaMNDvHPNV6S62MTFGTyuKPQNbv9yHRGN4eH6SnZGW6snvEVdYCspWZ1U3Nbxo6vCmBK95UyYpcxHgg1CCGdU4s3edju2NDQkMifyPkJdkabzzHVDhJJbChAJc1ACQfNW74VXXwrBZmeZyA2R28MBctDyXuSuffiwueys2LVowLu9wiTHUox7KQjtHK2c9howk9czzx2mpnYzkVYH42CYsWa5514EM4CJEXPJSSbXSgJJ"
        
        self.measure() {
            // Put the code you want to measure the time of here.
            let _ = Data(base58Decoding: encoded)
        }
    }
    
    func testPerformanceEncodeOneKilo() {
        let bytes = Data("\u{1f}\u{8b}\u{08}\u{00}\u{00}\u{09}\u{6e}\u{88}\u{00}\u{ff}\u{00}\u{00}\u{04}\u{ff}\u{fb}\u{63}\u{c9}\u{7e}\u{5f}\u{97}\u{68}\u{e5}\u{10}\u{08}\u{e5}\u{a5}\u{9a}\u{7c}\u{24}\u{75}\u{35}\u{be}\u{af}\u{37}\u{0b}\u{c3}\u{f4}\u{18}\u{62}\u{4a}\u{b7}\u{18}\u{d0}\u{10}\u{0b}\u{6b}\u{62}\u{e1}\u{36}\u{0f}\u{62}\u{a6}\u{eb}\u{78}\u{a5}\u{f3}\u{33}\u{52}\u{bc}\u{df}\u{04}\u{cb}\u{37}\u{cf}\u{3d}\u{97}\u{5c}\u{b8}\u{75}\u{09}\u{1f}\u{18}\u{9f}\u{fc}\u{a9}\u{da}\u{1e}\u{59}\u{77}\u{09}\u{9c}\u{5d}\u{b6}\u{f2}\u{9e}\u{45}\u{b7}\u{5e}\u{5d}\u{11}\u{f1}\u{20}\u{14}\u{85}\u{f8}\u{54}\u{87}\u{8c}\u{1e}\u{2c}\u{2e}\u{15}\u{57}\u{89}\u{e7}\u{5d}\u{49}\u{b6}\u{ae}\u{24}\u{3a}\u{20}\u{50}\u{0e}\u{a7}\u{5b}\u{10}\u{bf}\u{0a}\u{b4}\u{01}\u{42}\u{ed}\u{ce}\u{2d}\u{45}\u{21}\u{b6}\u{e8}\u{64}\u{73}\u{4e}\u{7e}\u{0a}\u{36}\u{1d}\u{57}\u{0a}\u{5e}\u{1c}\u{21}\u{c2}\u{b8}\u{e7}\u{89}\u{82}\u{e4}\u{04}\u{7e}\u{50}\u{ff}\u{da}\u{4f}\u{fe}\u{11}\u{95}\u{fb}\u{35}\u{f9}\u{6d}\u{32}\u{ce}\u{ef}\u{8f}\u{3d}\u{1b}\u{db}\u{38}\u{fa}\u{cd}\u{26}\u{36}\u{12}\u{93}\u{a0}\u{96}\u{ea}\u{42}\u{be}\u{d6}\u{85}\u{86}\u{c1}\u{c1}\u{e2}\u{55}\u{41}\u{d1}\u{7f}\u{8d}\u{0e}\u{00}\u{81}\u{58}\u{b4}\u{10}\u{bb}\u{64}\u{92}\u{05}\u{07}\u{a9}\u{d5}\u{d9}\u{40}\u{28}\u{8b}\u{9b}\u{4c}\u{8d}\u{8e}\u{4e}\u{69}\u{f9}\u{c9}\u{35}\u{ea}\u{da}\u{2f}\u{61}\u{87}\u{35}\u{2d}\u{6b}\u{25}\u{32}\u{f0}\u{7e}\u{89}\u{1a}\u{cb}\u{c0}\u{ea}\u{66}\u{88}\u{99}\u{39}\u{e0}\u{3b}\u{24}\u{3b}\u{05}\u{74}\u{d3}\u{72}\u{f6}\u{48}\u{15}\u{dc}\u{02}\u{0a}\u{bf}\u{c8}\u{49}\u{42}\u{10}\u{22}\u{eb}\u{e9}\u{44}\u{71}\u{55}\u{af}\u{67}\u{67}\u{e6}\u{2a}\u{40}\u{31}\u{81}\u{b9}\u{6f}\u{65}\u{86}\u{0f}\u{0f}\u{9d}\u{58}\u{4c}\u{51}\u{c1}\u{2e}\u{4e}\u{60}\u{7e}\u{e8}\u{93}\u{39}\u{90}\u{da}\u{e5}\u{be}\u{ec}\u{e4}\u{dd}\u{bc}\u{1d}\u{ba}\u{40}\u{a6}\u{85}\u{d9}\u{b2}\u{ec}\u{b4}\u{26}\u{74}\u{ee}\u{c1}\u{ec}\u{e3}\u{40}\u{b9}\u{49}\u{a3}\u{e1}\u{26}\u{76}\u{8a}\u{eb}\u{95}\u{c8}\u{72}\u{b0}\u{85}\u{36}\u{19}\u{3f}\u{55}\u{06}\u{7b}\u{cd}\u{3e}\u{d0}\u{df}\u{7e}\u{8d}\u{2a}\u{ea}\u{a6}\u{24}\u{c6}\u{f6}\u{fb}\u{da}\u{e0}\u{45}\u{cf}\u{32}\u{0e}\u{bc}\u{f4}\u{41}\u{7d}\u{71}\u{3d}\u{86}\u{f9}\u{b4}\u{af}\u{07}\u{a0}\u{d1}\u{34}\u{8a}\u{02}\u{28}\u{56}\u{d4}\u{cc}\u{36}\u{44}\u{98}\u{44}\u{cb}\u{9d}\u{c5}\u{fc}\u{45}\u{2d}\u{c4}\u{5c}\u{fe}\u{ce}\u{aa}\u{44}\u{da}\u{66}\u{52}\u{2d}\u{32}\u{6e}\u{13}\u{32}\u{ac}\u{af}\u{13}\u{72}\u{87}\u{79}\u{d2}\u{92}\u{54}\u{9f}\u{c7}\u{b9}\u{f3}\u{21}\u{ae}\u{dd}\u{69}\u{44}\u{e9}\u{46}\u{94}\u{1c}\u{62}\u{84}\u{03}\u{e0}\u{bf}\u{66}\u{fb}\u{e0}\u{79}\u{f9}\u{57}\u{9e}\u{22}\u{9e}\u{23}\u{2d}\u{2a}\u{73}\u{eb}\u{74}\u{38}\u{f0}\u{ea}\u{5d}\u{b3}\u{8f}\u{87}\u{26}\u{3e}\u{3c}\u{54}\u{11}\u{b7}\u{98}\u{bd}\u{7f}\u{78}\u{64}\u{a3}\u{f1}\u{8f}\u{a9}\u{5e}\u{4f}\u{18}\u{3f}\u{a7}\u{1f}\u{3a}\u{29}\u{27}\u{27}\u{b7}\u{49}\u{40}\u{16}\u{18}\u{1f}\u{d3}\u{ed}\u{86}\u{61}\u{bd}\u{c3}\u{4e}\u{4a}\u{53}\u{37}\u{78}\u{5c}\u{00}\u{d3}\u{50}\u{45}\u{1c}\u{55}\u{c0}\u{9b}\u{d7}\u{62}\u{29}\u{88}\u{2e}\u{a4}\u{0d}\u{6a}\u{15}\u{6c}\u{33}\u{3c}\u{e7}\u{31}\u{fa}\u{c1}\u{af}\u{df}\u{7a}\u{3e}\u{37}\u{3e}\u{e5}\u{bc}\u{fd}\u{fb}\u{9b}\u{72}\u{10}\u{35}\u{90}\u{25}\u{6e}\u{87}\u{0d}\u{74}\u{1c}\u{fd}\u{e3}\u{0b}\u{ee}\u{f5}\u{92}\u{28}\u{8d}\u{22}\u{8a}\u{49}\u{7b}\u{cd}\u{bb}\u{d8}\u{24}\u{6b}\u{5e}\u{58}\u{40}\u{ec}\u{1b}\u{6c}\u{ed}\u{8e}\u{cb}\u{56}\u{62}\u{a6}\u{b4}\u{42}\u{3d}\u{7d}\u{a2}\u{ef}\u{27}\u{27}\u{46}\u{50}\u{bc}\u{5e}\u{37}\u{9b}\u{27}\u{72}\u{f0}\u{ea}\u{a7}\u{e7}\u{4d}\u{f4}\u{ae}\u{7e}\u{95}\u{8f}\u{91}\u{2e}\u{58}\u{c4}\u{6a}\u{06}\u{da}\u{7a}\u{06}\u{5c}\u{8d}\u{fe}\u{ef}\u{f5}\u{b3}\u{0f}\u{b4}\u{0a}\u{20}\u{53}\u{d8}\u{35}\u{80}\u{02}\u{ca}\u{97}\u{81}\u{b6}\u{1c}\u{4b}\u{8f}\u{b7}\u{ee}\u{d0}\u{c3}\u{88}\u{6c}\u{76}\u{3e}\u{b0}\u{28}\u{ce}\u{a1}\u{9f}\u{76}\u{5f}\u{aa}\u{c3}\u{53}\u{44}\u{09}\u{70}\u{a3}\u{95}\u{d9}\u{8c}\u{54}\u{ba}\u{8a}\u{9a}\u{6b}\u{ce}\u{c3}\u{07}\u{df}\u{13}\u{6d}\u{ea}\u{0f}\u{51}\u{9c}\u{e2}\u{81}\u{87}\u{f6}\u{82}\u{7a}\u{70}\u{d8}\u{fa}\u{e2}\u{a8}\u{32}\u{c1}\u{5e}\u{53}\u{c2}\u{85}\u{e9}\u{61}\u{8a}\u{17}\u{82}\u{12}\u{ab}\u{92}\u{79}\u{2b}\u{ed}\u{07}\u{ca}\u{1e}\u{93}\u{23}\u{9c}\u{4b}\u{d2}\u{89}\u{86}\u{ac}\u{55}\u{f9}\u{50}\u{23}\u{8f}\u{9e}\u{d3}\u{ab}\u{22}\u{57}\u{91}\u{5a}\u{0b}\u{48}\u{d7}\u{a2}\u{b8}\u{06}\u{bb}\u{74}\u{ae}\u{e9}\u{ca}\u{06}\u{41}\u{8d}\u{6a}\u{00}\u{42}\u{c4}\u{40}\u{a9}\u{fe}\u{ae}\u{88}\u{42}\u{c2}\u{83}\u{e0}\u{8a}\u{d8}\u{5c}\u{bb}\u{5a}\u{b5}\u{9c}\u{1d}\u{a5}\u{be}\u{67}\u{50}\u{b1}\u{4e}\u{ec}\u{96}\u{65}\u{aa}\u{87}\u{5b}\u{b0}\u{76}\u{88}\u{e3}\u{1b}\u{cb}\u{38}\u{21}\u{02}\u{8e}\u{c9}\u{e7}\u{f5}\u{c7}\u{e1}\u{1d}\u{e8}\u{eb}\u{54}\u{0e}\u{0b}\u{ea}\u{d1}\u{2e}\u{ad}\u{bb}\u{ec}\u{22}\u{21}\u{b3}\u{64}\u{36}\u{29}\u{34}\u{5e}\u{3a}\u{22}\u{e8}\u{03}\u{4b}\u{86}\u{b1}\u{67}\u{7d}\u{4f}\u{48}\u{6d}\u{fb}\u{4b}\u{de}\u{e6}\u{4c}\u{b0}\u{af}\u{40}\u{66}\u{ab}\u{e9}\u{1a}\u{4e}\u{ae}\u{1a}\u{7e}\u{05}\u{c5}\u{67}\u{2a}\u{95}\u{6d}\u{c2}\u{61}\u{35}\u{20}\u{fe}\u{33}\u{c3}\u{2c}\u{7f}\u{9b}\u{be}\u{9f}\u{9a}\u{d5}\u{f0}\u{63}\u{28}\u{a1}\u{94}\u{b1}\u{5c}\u{c1}\u{18}\u{6b}\u{5b}\u{33}\u{b4}\u{4d}\u{cf}\u{be}\u{f7}\u{b2}\u{94}\u{58}\u{aa}\u{cf}\u{ad}\u{c8}\u{75}\u{93}\u{1a}\u{08}\u{f4}\u{d2}\u{d9}\u{f6}\u{95}\u{03}\u{3b}\u{f3}\u{4e}\u{fb}\u{15}\u{e4}\u{28}\u{ed}\u{d5}\u{79}\u{d9}\u{bf}\u{b7}\u{8f}\u{b2}\u{70}\u{16}\u{4c}\u{2d}\u{65}\u{f6}\u{ec}\u{33}\u{1e}\u{af}\u{ea}\u{46}\u{69}\u{c6}\u{9a}\u{6b}\u{dd}\u{f3}\u{57}\u{e0}\u{1d}\u{28}\u{cd}\u{f8}\u{83}\u{3d}\u{94}\u{4c}\u{2f}\u{6e}\u{fd}\u{51}\u{3d}\u{a8}\u{ff}\u{cb}\u{33}\u{ad}\u{32}\u{42}\u{0e}\u{d3}\u{00}\u{0a}\u{e5}\u{71}\u{76}\u{3b}\u{83}\u{c9}\u{2a}\u{67}\u{50}\u{c3}\u{a5}\u{eb}\u{4d}\u{8d}\u{67}\u{d6}\u{d9}\u{1b}\u{9a}\u{5a}\u{be}\u{dd}\u{c5}\u{15}\u{00}\u{cf}\u{97}\u{0f}\u{47}\u{44}\u{34}\u{1d}\u{4e}\u{b6}\u{6f}\u{91}\u{31}\u{f3}\u{45}\u{0f}\u{59}\u{48}\u{10}\u{23}\u{53}\u{40}\u{49}\u{83}\u{e6}\u{c8}\u{df}\u{51}\u{6c}\u{a8}\u{9f}\u{3a}\u{43}\u{3d}\u{b9}\u{d4}\u{ea}\u{30}\u{4d}\u{e0}\u{d2}\u{b8}\u{44}\u{f3}\u{91}\u{20}\u{79}\u{db}\u{7b}\u{e6}\u{50}\u{f9}\u{0f}\u{fb}\u{4c}\u{ac}\u{79}\u{93}\u{f6}\u{f8}\u{96}\u{0d}\u{55}\u{7c}\u{41}\u{9b}\u{1a}\u{86}\u{ad}\u{4b}\u{d1}\u{f9}\u{5d}\u{ed}\u{3a}\u{4f}\u{c9}\u{64}\u{72}\u{d4}\u{22}\u{53}\u{59}\u{2f}\u{01}\u{00}\u{00}\u{ff}\u{ff}\u{c6}\u{fd}\u{a0}\u{37}\u{00}\u{04}\u{00}\u{00}".utf8)
        self.measure() {
            // Put the code you want to measure the time of here.
            let _ = String(base58Encoding: bytes)
        }
    }
    
    static var allTests = [
        ("testEncodeBase58Strings", testEncodeBase58Strings),
        ("testDecodeBase58Strings", testDecodeBase58Strings),
        ("testDecodeInvalidBase58Strings", testDecodeInvalidBase58Strings),
        ("testPerformanceDecodeShort", testPerformanceDecodeShort),
        ("testPerformanceEncodeShort", testPerformanceEncodeShort),
        ("testPerformanceDecodeOneKilo", testPerformanceDecodeOneKilo),
        ("testPerformanceEncodeOneKilo", testPerformanceEncodeOneKilo),
        ]
}
