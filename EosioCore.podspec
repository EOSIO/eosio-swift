#
# Be sure to run `pod lib lint EosioCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EosioCore'
  s.version          = '1.0'
  s.summary          = 'Binary <> JSON conversion using ABIs. Compatible with languages which can interface to C.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!


  s.homepage         = 'https://github.com/EOSIO/eosio-core-framework/tree/master'
  s.license      = {
    :type => 'Block One Proprietary',
    :text => <<-LICENSE
              Copyright (C) 2018 Block One.  All rights reserved.
    LICENSE
  }
  
  s.author           = { 'Steve McCoole' => 'steve.mccoole@objectpartners.com' }
  s.source           = { :git => 'https://github.com/EOSIO/eosio-core-framework.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.4'
  
  s.source_files =  'EosioCore/**/*.{c,h,m,cpp,hpp}',
  		    'EosioCore/**/*.swift'
   
  s.preserve_paths =  'Frameworks/boost.framework',
  					  'EosioCore/Crypto/module.modulemap',
					  'EosioCore/AbiEos/module.modulemap',
					  'EosioCore/Recover/module.modulemap',
                      'EosioCore/AbiEos/eosio.assert.abi.json',
					  'EosioCore/AbiEos/transaction.abi.json',
					  'EosioCore/AbiEos/abi.abi.json'
					  
					  
                      
  
  s.ios.resource_bundle = { 'EosioCore' => 'EosioCore/AbiEos/transaction.abi.json EosioCore/AbiEos/abi.abi.json EosioCore/AbiEos/eosio.assert.abi.json' }

  s.resources = 'EosioCore/AbiEos/transaction.abi.json',
                'EosioCore/AbiEos/abi.abi.json',
                'EosioCore/AbiEos/eosio.assert.abi.json'
  
  s.public_header_files =  'EosioCore/AbiEos/abieos.h',
                           'EosioCore/Crypto/base58.h'
					   
  s.libraries = "c++"
  s.pod_target_xcconfig = {'SWIFT_INCLUDE_PATHS' => '$(PROJECT_DIR)/../../eosio-core-framework/EosioCore/Crypto $(PROJECT_DIR)/../../eosio-core-framework/EosioCore/AbiEos $(PROJECT_DIR)/../../eosio-core-framework/EosioCore/Recover',
  						   'FRAMEWORK_SEARCH_PATHS' => '$(PROJECT_DIR)/../../eosio-core-framework/Frameworks/boost.framework', 
 						   'LIBRARY_SEARCH_PATHS' => '$(PROJECT_DIR)/../../eosio-core-framework/** $(SRCROOT)/**', 
 						   'HEADER_SEARCH_PATHS' => '$(SRCROOT)/** $(SRCROOT)/EosioCore/** $(PROJECT_DIR)/../../eosio-core-framework/** $(PROJECT_DIR)/../../eosio-core-framework/EosioCore/**', 
 						   'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++17', 
 						   'CLANG_CXX_LIBRARY' => 'libc++', 
 						   'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES', 
 						   'CLANG_ENABLE_MODULES' => 'YES',
						   'SWIFT_COMPILATION_MODE' => 'wholemodule',
						   'ENABLE_BITCODE' => 'NO'} 

  
  s.ios.vendored_frameworks = 'Frameworks/boost.framework'
  s.ios.dependency 'GRKOpenSSLFramework'
  
end
