#
# Be sure to run `pod lib lint EosioSwiftEcc.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EosioSwiftEcc'
  s.version          = '1.0'
  s.summary          = 'Elliptical Curve Cryptography (ECC) functions for EOSIO. '

 

  s.homepage         = 'https://github.com/EOSIO/eosio-swift-ecc'
  s.license      = {
    :type => 'MIT',
    :text => <<-LICENSE
              Copyright (c) 2018-2019 block.one
    LICENSE
  }
  
  s.author           = { 'Farid Rahmani' => 'farid.rahmani@block.one' }
  s.source           = { :git => 'https://github.com/EOSIO/eosio-swift-ecc.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  
  s.source_files =  'EosioSwiftEcc/**/*.{c,h,m,cpp,hpp}',
  		    'EosioSwiftEcc/**/*.swift'
   
 
					  
					  

					   
  s.libraries = "c++"
  s.pod_target_xcconfig = { 'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++17', 
 						   'CLANG_CXX_LIBRARY' => 'libc++', 
 						   'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES', 
 						   'CLANG_ENABLE_MODULES' => 'YES',
						   'SWIFT_COMPILATION_MODE' => 'wholemodule',
						   'ENABLE_BITCODE' => 'YES'} 

  
  s.ios.dependency 'GRKOpenSSLFramework'
  s.ios.dependency 'EosioSwift', '~> 1.0'
  
end
