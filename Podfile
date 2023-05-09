# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'ItsME' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ItsME
	pod 'RxSwift', '6.5.0'
	pod 'RxCocoa', '6.5.0'
	pod 'SnapKit', '5.6.0'
	pod 'RxKakaoSDK', '2.14.0'
	pod 'Firebase/Analytics', '10.3.0' # Google Analytics
	pod 'FirebaseAuth', '10.3.0'
	pod 'FirebaseDatabase', '10.3.0' #Realtime Database
	pod 'FirebaseStorage', '10.3.0' # Cloud Storage
	pod 'Then', '~> 3.0.0'
	pod 'UITextView+Placeholder', '~> 1.4.0'
	pod 'SFSafeSymbols', '~> 4.1.1'
	pod 'Keychaining', '0.9.0'
	pod 'SwiftJWT', '~> 3.6.2'

  target 'ItsMETests' do
    inherit! :search_paths
    # Pods for testing
		pod 'RxBlocking', '6.5.0'
  end

  target 'ItsMEUITests' do
    # Pods for testing
  end

end

post_install do |installer|

  # Configure the Pods project
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['DEAD_CODE_STRIPPING'] = 'YES'
  end

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end

end
