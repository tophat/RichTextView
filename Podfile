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
  pod 'SnapKit'
  pod 'SwiftRichString', :git => 'https://github.com/tophatmonocle/SwiftRichString.git'
end

# This works around a unit test issue introduced in Xcode 10 / Cocoapod
# https://github.com/CocoaPods/CocoaPods/issues/8605
target 'RichTextViewUnitTests' do
  use_frameworks!
  inherit! :search_paths
  pod 'Nimble'
  pod 'Quick'
end

target 'RichTextViewUITests' do
  use_frameworks!
  inherit! :search_paths
  pod 'Nimble-Snapshots'
  pod 'Quick'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED'] = 'YES'
            # This works around a unit test issue introduced in Xcode 10.
            # We only apply it to the Debug configuration to avoid bloating the app size
            if config.name == "Debug" && defined?(target.product_type) && target.product_type == "com.apple.product-type.framework"
                config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = "YES"
            end
            config.build_settings['SWIFT_VERSION'] = '5.0'
        end
    end
    installer.pods_project.root_object.known_regions = ["Base", "en"]
    installer.pods_project.root_object.development_region = "en"
end
