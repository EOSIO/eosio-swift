#! /bin/sh
echo "Updating documentation for EosioSwift..."
jazzy --module EosioSwift --swift-build-tool spm --build-tool-arguments -Xswiftc,-swift-version,-Xswiftc,5 --clean --theme fullwidth --github_url https://github.com/EOSIO/eosio-swift --github-file-prefix https://github.com/EOSIO/eosio-swift/tree/master --hide-documentation-coverage --undocumented-text "" --copyright "Copyright (c) 2017-2020 block.one and its contributors. All rights reserved." --readme README.md --output docs/EosioSwift

echo "Updating documentation for EosioSwiftAbieosSerializationProvider..."
jazzy --module EosioSwiftAbieosSerializationProvider --swift-build-tool spm --build-tool-arguments -Xswiftc,-swift-version,-Xswiftc,5 --clean --theme fullwidth --github_url https://github.com/EOSIO/eosio-swift --github-file-prefix https://github.com/EOSIO/eosio-swift/tree/master --hide-documentation-coverage --undocumented-text "" --copyright "Copyright (c) 2017-2020 block.one and its contributors. All rights reserved." --readme README_AbieosSerializationProvider.md --output docs/EosioSwiftAbieosSerializationProvider

echo "Updating documentation for EosioSwiftEcc..."
jazzy --module EosioSwiftEcc --swift-build-tool spm --build-tool-arguments -Xswiftc,-swift-version,-Xswiftc,5 --clean --theme fullwidth --github_url https://github.com/EOSIO/eosio-swift --github-file-prefix https://github.com/EOSIO/eosio-swift/tree/master --hide-documentation-coverage --undocumented-text "" --copyright "Copyright (c) 2017-2020 block.one and its contributors. All rights reserved." --readme README_Ecc.md --output docs/EosioSwiftEcc

echo "Updating documentation for EosioSwiftSoftkeySignatureProvider..."
jazzy --module EosioSwiftSoftkeySignatureProvider --swift-build-tool spm --build-tool-arguments -Xswiftc,-swift-version,-Xswiftc,5 --clean --theme fullwidth --github_url https://github.com/EOSIO/eosio-swift --github-file-prefix https://github.com/EOSIO/eosio-swift/tree/master --hide-documentation-coverage --undocumented-text "" --copyright "Copyright (c) 2017-2020 block.one and its contributors. All rights reserved." --readme README_SoftkeySignatureProvider.md --output docs/EosioSwiftSoftkeySignatureProvider
