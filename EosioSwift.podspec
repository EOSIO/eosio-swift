#
# Be sure to run `pod lib lint EosioSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EosioSwift'
  s.version          = '1.0'
  s.summary          = 'Open source library to build native blockchain applications.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!


  s.homepage         = 'https://github.com/EOSIO/eosio-swift/tree/master'
  s.license      = {
    :type => 'Block One Proprietary',
    :text => <<-LICENSE
              Copyright (C) 2018-2019 Block One.  All rights reserved.
    LICENSE
  }
  
  s.author           = { 'Steve McCoole' => 'steve.mccoole@objectpartners.com' }
  
  s.source           = { :git => 'https://github.com/EOSIO/eosio-swift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  
  s.source_files = 'EosioSwift/**/*.swift'

					   

  s.pod_target_xcconfig = {
 						   'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES', 
 						   'CLANG_ENABLE_MODULES' => 'YES',
						   'SWIFT_COMPILATION_MODE' => 'wholemodule',
						   'ENABLE_BITCODE' => 'YES'} 

  s.ios.dependency 'BigInt'

end
