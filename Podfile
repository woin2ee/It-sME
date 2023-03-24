# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'ItsME' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ItsME
	pod 'RxSwift', '6.5.0'
	pod 'RxCocoa', '6.5.0'
	pod 'SnapKit', '5.6.0'
	pod 'RxKakaoSDK'
	pod 'Firebase/Analytics' # Google Analytics
	pod 'FirebaseAuth'
	pod 'FirebaseDatabase' #Realtime Database
	pod 'Then'
	pod 'UITextView+Placeholder'
	pod 'Keychaining'

  target 'ItsMETests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ItsMEUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
  end
end
