#
# Be sure to run `pod lib lint EosioSwiftC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EosioSwiftC'
  s.version          = '1.0'
  s.summary          = 'Binary <> JSON conversion using ABIs. Compatible with languages which can interface to C.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!


  s.homepage         = 'https://github.com/EOSIO/eosio-swift-c/tree/master'
  s.license      = {
    :type => 'Block One Proprietary',
    :text => <<-LICENSE
              Copyright (C) 2018 Block One.  All rights reserved.
    LICENSE
  }
  
  s.author           = { 'Steve McCoole' => 'steve.mccoole@objectpartners.com' }
  s.source           = { :git => 'https://github.com/EOSIO/eosio-swift-c.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.4'
  
  s.source_files =  'EosioSwiftC/**/*.{c,h,m,cpp,hpp}',
  		    'EosioSwiftC/**/*.swift'
   
  s.preserve_paths =  'Frameworks/boost.framework',
  					  'EosioSwiftC/Crypto/module.modulemap',
					  'EosioSwiftC/AbiEos/module.modulemap',
					  'EosioSwiftC/Recover/module.modulemap',
                      'EosioSwiftC/AbiEos/eosio.assert.abi.json',
					  'EosioSwiftC/AbiEos/transaction.abi.json',
					  'EosioSwiftC/AbiEos/abi.abi.json'
					  
					  
                      
  
  s.ios.resource_bundle = { 'EosioSwiftC' => 'EosioSwiftC/AbiEos/transaction.abi.json EosioSwiftC/AbiEos/abi.abi.json EosioSwiftC/AbiEos/eosio.assert.abi.json' }

  s.resources = 'EosioSwiftC/AbiEos/transaction.abi.json',
                'EosioSwiftC/AbiEos/abi.abi.json',
                'EosioSwiftC/AbiEos/eosio.assert.abi.json'
  
  s.public_header_files =  'EosioSwiftC/AbiEos/abieos.h',
                           'EosioSwiftC/Crypto/base58.h'
					   
  s.libraries = "c++"
  s.pod_target_xcconfig = {'SWIFT_INCLUDE_PATHS' => '$(PROJECT_DIR)/../../eosio-swift-c/EosioSwiftC/Crypto $(PROJECT_DIR)/../../eosio-swift-c/EosioSwiftC/AbiEos $(PROJECT_DIR)/../../eosio-swift-c/EosioSwiftC/Recover',
  						   'FRAMEWORK_SEARCH_PATHS' => '$(PROJECT_DIR)/../../eosio-swift-c/Frameworks/boost.framework', 
 						   'LIBRARY_SEARCH_PATHS' => '$(PROJECT_DIR)/../../eosio-swift-c/** $(SRCROOT)/**', 
 						   'HEADER_SEARCH_PATHS' => '$(SRCROOT)/** $(SRCROOT)/EosioSwiftC/** $(PROJECT_DIR)/../../eosio-swift-c/** $(PROJECT_DIR)/../../eosio-swift-c/EosioSwiftC/**', 
 						   'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++17', 
 						   'CLANG_CXX_LIBRARY' => 'libc++', 
 						   'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES', 
 						   'CLANG_ENABLE_MODULES' => 'YES',
						   'SWIFT_COMPILATION_MODE' => 'wholemodule',
						   'ENABLE_BITCODE' => 'YES'} 

  
  s.ios.vendored_frameworks = 'Frameworks/boost.framework'
  s.ios.dependency 'GRKOpenSSLFramework'
  s.ios.dependency 'EosioSwiftFoundation', '~> 1.0'
  
end
