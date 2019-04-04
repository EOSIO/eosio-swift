#
# Be sure to run `pod lib lint EosioSwiftSoftkeySignatureProvider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EosioSwiftSoftkeySignatureProvider'
  s.version          = '0.0.1'
  s.summary          = 'Experimental Software Key Signature Provider for Eosio SDK for Swift.'
  s.homepage         = 'https://github.com/EOSIO/eosio-swift-softkey-signature-provider'
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
  s.source           = { :git => 'https://github.com/EOSIO/eosio-swift-softkey-signature-provider.git', :tag => "v" + s.version.to_s }

  s.swift_version         = '4.2'
  s.ios.deployment_target = '12.0'

  s.source_files =  'EosioSwiftSoftkeySignatureProvider/**/*.{c,h,m,cpp,hpp}',
                    'EosioSwiftSoftkeySignatureProvider/**/*.swift'

  s.libraries = "c++"
  s.pod_target_xcconfig = { 'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++17',
                            'CLANG_CXX_LIBRARY' => 'libc++',
                            'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                            'CLANG_ENABLE_MODULES' => 'YES',
                            'SWIFT_COMPILATION_MODE' => 'wholemodule',
                            'ENABLE_BITCODE' => 'YES' }

  s.ios.dependency 'EosioSwiftEcc', '~> 0.0.1'
  s.ios.dependency 'EosioSwift', '~> 0.0.1'
end
