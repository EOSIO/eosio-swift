using_local_pods = true

unless using_local_pods
  source 'https://github.com/EOSIO/eosio-swift-pod-specs.git'
  source 'https://github.com/CocoaPods/Specs.git'
end

platform :ios, '11.0'

if using_local_pods
  # Pull pods from sibling directories if using local pods
  target 'EosioSwiftSoftkeySignatureProvider' do
    use_frameworks!

    pod 'EosioSwift', :path => '../eosio-swift'
    pod 'EosioSwiftEcc', :path => '../eosio-swift-ecc'
    pod 'SwiftLint'

    target 'EosioSwiftSoftkeySignatureProviderTests' do
      inherit! :search_paths
      pod 'EosioSwift', :path => '../eosio-swift'
      pod 'EosioSwiftEcc', :path => '../eosio-swift-ecc'
    end
  end
else
  # Pull pods from sources above if not using local pods
  target 'EosioSwiftSoftkeySignatureProvider' do
    use_frameworks!

    pod 'EosioSwift', '~> 0.0.1'
    pod 'EosioSwiftEcc', '~> 0.0.1'
    pod 'SwiftLint'

    target 'EosioSwiftSoftkeySignatureProviderTests' do
      inherit! :search_paths
      pod 'EosioSwift', '~> 0.0.1'
      pod 'EosioSwiftEcc', '~> 0.0.1'
    end
  end
end
