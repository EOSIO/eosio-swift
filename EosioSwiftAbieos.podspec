#
# Be sure to run `pod lib lint EosioSwiftAbieos.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EosioSwiftAbieos'
  s.version          = '1.0'
  s.summary          = 'Binary <> JSON conversion using ABIs. Compatible with languages which can interface to C.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!


  s.homepage         = 'https://github.com/EOSIO/eosio-swift-abieos-serialization-provider/tree/master'
  s.license      = {
    :type => 'MIT',
    :text => <<-LICENSE
              Copyright (c) 2018-2019 block.one
    LICENSE
  }
  
  s.author           = { 'Steve McCoole' => 'steve.mccoole@objectpartners.com' }
  s.source           = { :git => 'https://github.com/EOSIO/eosio-swift-abieos-serialization-provider', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  
  s.source_files =  'EosioSwiftAbieos/**/*.{c,h,m,cpp,hpp}',
  		    'EosioSwiftAbieos/**/*.swift'
   
  s.preserve_paths =  'EosioSwiftAbieos/Crypto/module.modulemap',
					  'EosioSwiftAbieos/AbiEos/module.modulemap',
					  'EosioSwiftAbieos/Recover/module.modulemap',
                      'EosioSwiftAbieos/AbiEos/eosio.assert.abi.json',
					  'EosioSwiftAbieos/AbiEos/transaction.abi.json',
					  'EosioSwiftAbieos/AbiEos/abi.abi.json'
					  
					  
                      
  
  s.ios.resource_bundle = { 'EosioSwiftAbieos' => 'EosioSwiftAbieos/AbiEos/transaction.abi.json EosioSwiftAbieos/AbiEos/abi.abi.json EosioSwiftAbieos/AbiEos/eosio.assert.abi.json' }

  s.resources = 'EosioSwiftAbieos/AbiEos/transaction.abi.json',
                'EosioSwiftAbieos/AbiEos/abi.abi.json',
                'EosioSwiftAbieos/AbiEos/eosio.assert.abi.json'
  
  s.public_header_files =  'EosioSwiftAbieos/AbiEos/abieos.h',
                           'EosioSwiftAbieos/Crypto/base58.h'
					   
  s.libraries = "c++"
  s.pod_target_xcconfig = {'SWIFT_INCLUDE_PATHS' => '$(PROJECT_DIR)/../../eosio-swift-abieos-serialization-provider/EosioSwiftAbieos/Crypto $(PROJECT_DIR)/../../eosio-swift-abieos-serialization-provider/EosioSwiftAbieos/AbiEos $(PROJECT_DIR)/../../eosio-swift-abieos-serialization-provider/EosioSwiftAbieos/Recover',
 						   'LIBRARY_SEARCH_PATHS' => '$(PROJECT_DIR)/../../eosio-swift-abieos-serialization-provider/** $(SRCROOT)/**', 
 						   'HEADER_SEARCH_PATHS' => '$(SRCROOT)/** $(SRCROOT)/EosioSwiftAbieos/** $(PROJECT_DIR)/../../eosio-swift-abieos-serialization-provider/** $(PROJECT_DIR)/../../eosio-swift-abieos-serialization-provider/EosioSwiftAbieos/**', 
 						   'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++17', 
 						   'CLANG_CXX_LIBRARY' => 'libc++', 
 						   'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES', 
 						   'CLANG_ENABLE_MODULES' => 'YES',
						   'SWIFT_COMPILATION_MODE' => 'wholemodule',
						   'ENABLE_BITCODE' => 'YES'} 

  
  s.ios.dependency 'GRKOpenSSLFramework'
  s.ios.dependency 'EosioSwift', '~> 1.0'
  
end
