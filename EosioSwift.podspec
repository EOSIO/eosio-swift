#
# Be sure to run `pod lib lint EosioSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EosioSwift'
  s.version          = '1.0.0'
  s.summary          = 'EOSIO SDK for Swift - API for integrating with EOSIO-based blockchains.'
  s.homepage         = 'https://github.com/EOSIO/eosio-swift'
  s.license          = { :type => 'MIT', :text => <<-LICENSE
                           Copyright (c) 2017-2019 block.one and its contributors.  All rights reserved.
                         LICENSE
                       }
  s.author           = { 'Todd Bowden' => 'todd.bowden@block.one',
                         'Serguei Vinnitskii' => 'serguei.vinnitskii@block.one',
                         'Farid Rahmani' => 'farid.rahmani@block.one',
                         'Brandon Fancher' => 'brandon.fancher@block.one',
                         'Mark Johnson' => 'mark.johnson@block.one',
                         'Paul Kim' => 'paul.kim@block.one',
                         'Steve McCoole' => 'steve.mccoole@objectpartners.com',
                         'Ben Martell' => 'ben.martell@objectpartners.com' }

  s.source           = { :git => 'https://github.com/EOSIO/eosio-swift.git', :tag => "v" + s.version.to_s }

  s.swift_version         = '5.0'
  s.ios.deployment_target = '12.0'

  s.subspec 'Core' do |ss|
    ss.source_files = 'Sources/EosioSwift/**/*.swift'

    ss.pod_target_xcconfig = { 
	  'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
	  'CLANG_ENABLE_MODULES' => 'YES',
	  'SWIFT_COMPILATION_MODE' => 'wholemodule',
	  'ENABLE_BITCODE' => 'YES' 
	}

    ss.ios.dependency 'BigInt', '~> 5.0'
    ss.ios.dependency 'PromiseKit', '~> 6.8'
  end
  
  s.subspec 'AbieosSerializationProvider' do |ss|
    ss.public_header_files = 'Sources/Abieos/include/abieos.h'

    ss.source_files = 'Sources/Abieos/**/*.{c,h,m,cpp,hpp}',
                      'Sources/EosioSwiftAbieosSerializationProvider/**/*.swift'

    ss.preserve_paths = 'Sources/EosioSwiftAbieosSerializationProvider/eosio.assert.abi.json',
                        'Sources/EosioSwiftAbieosSerializationProvider/transaction.abi.json',
                        'Sources/EosioSwiftAbieosSerializationProvider/abi.abi.json'

    ss.ios.resource_bundle = { 'EosioSwift' => 'Sources/EosioSwiftAbieosSerializationProvider/*.abi.json' }

    ss.resources = 'Sources/EosioSwiftAbieosSerializationProvider/transaction.abi.json',
                   'Sources/EosioSwiftAbieosSerializationProvider/abi.abi.json',
                   'Sources/EosioSwiftAbieosSerializationProvider/eosio.assert.abi.json'

    ss.libraries = "c++"
    ss.pod_target_xcconfig = { 
      'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++17',
      'CLANG_CXX_LIBRARY' => 'libc++',
      'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
      'CLANG_ENABLE_MODULES' => 'YES',
      'SWIFT_COMPILATION_MODE' => 'wholemodule',
      'ENABLE_BITCODE' => 'YES'
    }

    ss.ios.dependency 'EosioSwift/Core'
  end
  
  s.subspec 'Ecc' do |ss|
    ss.source_files = 'Sources/libtom/**/*.{c,h}',
                      'Sources/EosioSwiftEcc/**/*.swift'

    ss.public_header_files = 'Sources/libtom/libtomcrypt/headers/*.h'

    ss.pod_target_xcconfig = {
       'GCC_C_LANGUAGE_STANDARD' => 'c99',
       'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
       'CLANG_ENABLE_MODULES' => 'YES',
       'OTHER_SWIFT_FLAGS' => '$(inherited) -DMP_NO_DEV_URANDOM -DLTM_DESC -DLTC_SOURCE -DLTC_NO_TEST',
       'OTHER_CFLAGS' => '$(inherited) -DMP_NO_DEV_URANDOM -DLTM_DESC -DLTC_SOURCE -DLTC_NO_TEST',
       'SWIFT_COMPILATION_MODE' => 'wholemodule',
       'ENABLE_BITCODE' => 'YES'
    }

    ss.ios.dependency 'EosioSwift/Core'
  end
  
  s.subspec 'SoftkeySignatureProvider' do |ss|
    ss.source_files =  'Sources/EosioSwiftSoftkeySignatureProvider/**/*.swift'

    ss.pod_target_xcconfig = {
       'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
       'CLANG_ENABLE_MODULES' => 'YES',
       'SWIFT_COMPILATION_MODE' => 'wholemodule',
       'ENABLE_BITCODE' => 'YES'
    }

    ss.ios.dependency 'EosioSwift/Ecc'
    ss.ios.dependency 'EosioSwift/Core'
  end
  
end
