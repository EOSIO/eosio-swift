#
# Be sure to run `pod lib lint EosioSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EosioSwift'
  s.version          = '0.4.0'
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
  s.ios.deployment_target = '11.0'

  s.source_files = 'EosioSwift/**/*.swift'

  s.pod_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
						                'CLANG_ENABLE_MODULES' => 'YES',
						                'SWIFT_COMPILATION_MODE' => 'wholemodule',
						                'ENABLE_BITCODE' => 'YES' }

  s.ios.dependency 'BigInt', '~> 5.0'
  s.ios.dependency 'PromiseKit', '~> 6.8'

  s.dependency 'UIExtensions.swift', '~> 1.1.0'
end