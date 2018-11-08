#
# Be sure to run `pod lib lint EosioAbieos.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EosioAbieos'
  s.version          = '1.0'
  s.summary          = 'Binary <> JSON conversion using ABIs. Compatible with languages which can interface to C.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!


  s.homepage         = 'https://github.com/EOSIO/eosio-abieos-framework/tree/master'
  s.license      = {
    :type => 'Block One Proprietary',
    :text => <<-LICENSE
              Copyright (C) 2018 Block One.  All rights reserved.
    LICENSE
  }
  
  s.author           = { 'Steve McCoole' => 'steve.mccoole@objectpartners.com' }
  s.source           = { :git => 'https://github.com/EOSIO/eosio-abieos-framework.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.4'
  
  s.source_files =  'EosioAbieos/**/*.{c,h,m,cpp,hpp}',
  		    'EosioAbieos/**/*.swift'
   
  s.preserve_paths =  'Frameworks/boost.framework',
  					  'EosioAbieos/Crypto/module.modulemap',
					  'EosioAbieos/AbiEos/module.modulemap',
					  'EosioAbieos/Recover/module.modulemap',
                      'EosioAbieos/AbiEos/eosio.assert.abi.json',
					  'EosioAbieos/AbiEos/transaction.abi.json',
					  'EosioAbieos/AbiEos/abi.abi.json'
					  
					  
                      
  
  s.ios.resource_bundle = { 'EosioAbieos' => 'EosioAbieos/AbiEos/transaction.abi.json EosioAbieos/AbiEos/abi.abi.json EosioAbieos/AbiEos/eosio.assert.abi.json' }

  s.resources = 'EosioAbieos/AbiEos/transaction.abi.json',
                'EosioAbieos/AbiEos/abi.abi.json',
                'EosioAbieos/AbiEos/eosio.assert.abi.json'
  
  s.public_header_files =  'EosioAbieos/AbiEos/abieos.h',
                           'EosioAbieos/Crypto/base58.h'
					   
  s.libraries = "c++"
  s.pod_target_xcconfig = {'SWIFT_INCLUDE_PATHS' => '$(PROJECT_DIR)/../../eosio-abieos-framework/EosioAbieos/Crypto $(PROJECT_DIR)/../../eosio-abieos-framework/EosioAbieos/AbiEos $(PROJECT_DIR)/../../eosio-abieos-framework/EosioAbieos/Recover',
  						   'FRAMEWORK_SEARCH_PATHS' => '$(PROJECT_DIR)/../../eosio-abieos-framework/Frameworks/boost.framework', 
 						   'LIBRARY_SEARCH_PATHS' => '$(PROJECT_DIR)/../../eosio-abieos-framework/** $(SRCROOT)/**', 
 						   'HEADER_SEARCH_PATHS' => '$(SRCROOT)/** $(SRCROOT)/EosioAbieos/** $(PROJECT_DIR)/../../eosio-abieos-framework/** $(PROJECT_DIR)/../../eosio-abieos-framework/EosioAbieos/**', 
 						   'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++17', 
 						   'CLANG_CXX_LIBRARY' => 'libc++', 
 						   'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES', 
 						   'CLANG_ENABLE_MODULES' => 'YES',
						   'SWIFT_COMPILATION_MODE' => 'wholemodule',
						   'ENABLE_BITCODE' => 'NO'} 

  
  s.ios.vendored_frameworks = 'Frameworks/boost.framework'
  s.ios.dependency 'GRKOpenSSLFramework'
  
end
