using_local_pods = false

platform :ios, '11.0'

# ignore all warnings from all pods
inhibit_all_warnings!

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
    pod 'SwiftLint'
  end
else
  # Pull pods from sources above if not using local pods
    target 'EosioSwiftEcc' do
    use_frameworks!

    target 'EosioSwiftEccTests' do
      inherit! :search_paths
      pod 'GRKOpenSSLFramework', '~> 1.0'
      pod 'EosioSwift', '~> 0.1.0'
    end

    pod 'GRKOpenSSLFramework', '~> 1.0'
    pod 'EosioSwift', '~> 0.1.0'
    pod 'SwiftLint'
  end
end
