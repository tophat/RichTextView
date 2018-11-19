# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

#ignore all warnings from all pods
inhibit_all_warnings!

target 'RichTextView' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'Down'
  pod 'iosMath', :git => 'https://github.com/tophatmonocle/iosMath.git'
  pod 'SwiftLint'

  target 'RichTextViewUITests' do
    inherit! :search_paths
    # Pods for testing
    pod 'KIF-Quick'
    pod 'Mockingjay'
    pod 'Nimble-Snapshots'
  end

  target 'RichTextViewUnitTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Nimble'
    pod 'Quick'
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            # This works around a unit test issue introduced in Xcode 10.
            # We only apply it to the Debug configuration to avoid bloating the app size
            if config.name == "Debug" && defined?(target.product_type) && target.product_type == "com.apple.product-type.framework"
                config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = "YES"
            end
        end
    end
end 