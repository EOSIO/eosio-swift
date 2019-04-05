#
# Be sure to run `pod lib lint EosioSwiftAbieos.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EosioSwiftAbieos'
  s.version          = '0.0.1'
  s.summary          = 'Binary <> JSON conversion using ABIs. Compatible with languages which can interface to C.'
  s.homepage         = 'https://github.com/EOSIO/eosio-swift-abieos-serialization-provider'
  s.license          = { :type => 'MIT', :text => <<-LICENSE
                           Copyright (c) 2017-2019 block.one and its contributors.  All rights reserved.
                         LICENSE
                       }
  s.author           = { 'Todd Bowden' => 'todd.bowden@block.one',
                         'Serguei Vinnitskii' => 'serguei.vinnitskii@block.one',
                         'Farid Rahmani' => 'farid.rahmani@block.one',
                         'Brandon Fancher' => 'brandon.fancher@block.one',
                         'Steve McCoole' => 'steve.mccoole@objectpartners.com',
                         'Ben Martell' => 'ben.martell@objectpartners.com' }
  s.source           = { :git => 'https://github.com/EOSIO/eosio-swift-abieos-serialization-provider.git', :tag => "v" + s.version.to_s }

  s.swift_version         = '4.2'
  s.ios.deployment_target = '12.0'

  s.source_files =  'EosioSwiftAbieos/**/*.{c,h,m,cpp,hpp}',
  		              'EosioSwiftAbieos/**/*.swift'

  s.preserve_paths =  'EosioSwiftAbieos/Crypto/module.modulemap',
					            'EosioSwiftAbieos/AbiEos/module.modulemap',
					            'EosioSwiftAbieos/Recover/module.modulemap',
                      'EosioSwiftAbieos/AbiEos/eosio.assert.abi.json',
					            'EosioSwiftAbieos/AbiEos/transaction.abi.json',
					            'EosioSwiftAbieos/AbiEos/abi.abi.json'

  s.ios.resource_bundle = { 'EosioSwiftAbieos' => 'EosioSwiftAbieos/AbiEos/*.abi.json' }

  s.resources = 'EosioSwiftAbieos/AbiEos/transaction.abi.json',
                'EosioSwiftAbieos/AbiEos/abi.abi.json',
                'EosioSwiftAbieos/AbiEos/eosio.assert.abi.json'

  s.public_header_files =  'EosioSwiftAbieos/AbiEos/abieos.h'

  s.libraries = "c++"
  s.pod_target_xcconfig = {'SWIFT_INCLUDE_PATHS' => '$(PROJECT_DIR)/../../eosio-swift-abieos-serialization-provider/EosioSwiftAbieos/AbiEos',
 						   'LIBRARY_SEARCH_PATHS' => '$(PROJECT_DIR)/../../eosio-swift-abieos-serialization-provider/** $(SRCROOT)/**',
 						   'HEADER_SEARCH_PATHS' => '$(SRCROOT)/** $(SRCROOT)/EosioSwiftAbieos/** $(PROJECT_DIR)/../../eosio-swift-abieos-serialization-provider/** $(PROJECT_DIR)/../../eosio-swift-abieos-serialization-provider/EosioSwiftAbieos/**', 
 						   'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++17',
 						   'CLANG_CXX_LIBRARY' => 'libc++',
 						   'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
 						   'CLANG_ENABLE_MODULES' => 'YES',
						   'SWIFT_COMPILATION_MODE' => 'wholemodule',
						   'ENABLE_BITCODE' => 'YES'}


  s.ios.dependency 'EosioSwift', '~> 0.0.1'
end
