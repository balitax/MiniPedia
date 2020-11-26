platform :ios, '13.1'

target 'MiniPedia' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for MiniPedia
  
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxRealm'
  
  pod 'SVProgressHUD'
  pod 'Kingfisher'
  pod 'SkeletonView'
  pod 'BottomPopup'
  pod 'FaveButton'
  pod 'IQKeyboardManagerSwift'
  
  target 'MiniPediaTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'MiniPediaUITests' do
    # Pods for testing
  end
  
  
end

post_install do |pi|
  pi.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.1'
      if t.name == 'RxSwift'
        t.build_configurations.each do |config|
          if config.name == 'Debug'
            config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
          end
        end
      end
    end
  end
end
