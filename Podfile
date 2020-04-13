using_local_pods = ENV['USE_LOCAL_PODS'] == 'true' || false

platform :ios, '12.0'

if using_local_pods
  # Pull pods from sibling directories if using local pods
  target 'EosioSwiftAbieosSerializationProvider' do
    use_frameworks!

    pod 'EosioSwift', :path => '../eosio-swift'
    pod 'SwiftLint'

    target 'EosioSwiftAbieosTests' do
      inherit! :search_paths
      pod 'EosioSwift', :path => '../eosio-swift'
    end
  end
else
  # Pull pods from sources above if not using local pods
  target 'EosioSwiftAbieosSerializationProvider' do
    use_frameworks!

    pod 'EosioSwift', '~> 0.4.0'
    pod 'SwiftLint'

    target 'EosioSwiftAbieosTests' do
      inherit! :search_paths
      pod 'EosioSwift', '~> 0.4.0'
    end
  end
end
