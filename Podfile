using_local_pods = true

unless using_local_pods
  source 'https://github.com/EOSIO/eosio-swift-pod-specs.git'
  source 'https://github.com/CocoaPods/Specs.git'
end

platform :ios, '11.0'

if using_local_pods
  # Pull pods from sibling directories if using local pods
  target 'EosioSwiftEcc' do
    use_frameworks!

    target 'EosioSwiftEccTests' do
      inherit! :search_paths
      pod 'GRKOpenSSLFramework', '~> 1.0'
      pod 'EosioSwift', :path => '../eosio-swift'
    end

    pod 'GRKOpenSSLFramework', '~> 1.0'
    pod 'EosioSwift', :path => '../eosio-swift'
  end
else
  # Pull pods from sources above if not using local pods
    target 'EosioSwiftEcc' do
    use_frameworks!

    target 'EosioSwiftEccTests' do
      inherit! :search_paths
      pod 'GRKOpenSSLFramework', '~> 1.0'
      pod 'EosioSwift', '~> 0.0.1'
    end

    pod 'GRKOpenSSLFramework', '~> 1.0'
    pod 'EosioSwift', '~> 0.0.1'
  end
end
