# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

#ignore all warnings from all pods
inhibit_all_warnings!

target 'RichTextView' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'Down'
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
