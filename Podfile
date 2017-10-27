# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'RxAstroChannels' do
use_frameworks!
    pod 'RxSwift', '~> 3.1.0'
    pod 'RxCocoa', '~> 3.1.0'
pod 'RealmSwift'
end

# enable tracing resources

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'RxSwift'
      target.build_configurations.each do |config|
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
        end
      end
    end
  end
end