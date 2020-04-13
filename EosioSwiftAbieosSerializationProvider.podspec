#
# Be sure to run `pod lib lint EosioSwiftAbieosSerializationProvider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EosioSwiftAbieosSerializationProvider'
  s.version          = '0.4.0'
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
                         'Mark Johnson' => 'mark.johnson@block.one',
                         'Paul Kim' => 'paul.kim@block.one',
                         'Steve McCoole' => 'steve.mccoole@objectpartners.com',
                         'Ben Martell' => 'ben.martell@objectpartners.com' }
  s.source           = { :git => 'https://github.com/EOSIO/eosio-swift-abieos-serialization-provider.git', :tag => "v" + s.version.to_s }

  s.swift_version         = '5.0'
  s.ios.deployment_target = '12.0'

  s.public_header_files = 'EosioSwiftAbieosSerializationProvider/EosioSwiftAbieosSerializationProvider.h',
                          'EosioSwiftAbieosSerializationProvider/abieos.h'

  s.source_files = 'EosioSwiftAbieosSerializationProvider/**/*.{c,h,m,cpp,hpp}',
                   'EosioSwiftAbieosSerializationProvider/**/*.swift'

  s.preserve_paths = 'EosioSwiftAbieosSerializationProvider/eosio.assert.abi.json',
                     'EosioSwiftAbieosSerializationProvider/transaction.abi.json',
                     'EosioSwiftAbieosSerializationProvider/abi.abi.json'

  s.ios.resource_bundle = { 'EosioSwiftAbieosSerializationProvider' => 'EosioSwiftAbieosSerializationProvider/*.abi.json' }

  s.resources = 'EosioSwiftAbieosSerializationProvider/transaction.abi.json',
                'EosioSwiftAbieosSerializationProvider/abi.abi.json',
                'EosioSwiftAbieosSerializationProvider/eosio.assert.abi.json'

  s.libraries = "c++"
  s.pod_target_xcconfig = { 'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++17',
                            'CLANG_CXX_LIBRARY' => 'libc++',
                            'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                            'CLANG_ENABLE_MODULES' => 'YES',
                            'SWIFT_COMPILATION_MODE' => 'wholemodule',
                            'ENABLE_BITCODE' => 'YES'}

  s.ios.dependency 'EosioSwift', '~> 0.4.0'
end
