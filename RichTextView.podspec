#
# Be sure to run `pod lib lint RichTextView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RichTextView'
  s.version          = '3.3.0'
  s.summary          = 'iOS Text View that Properly Displays LaTeX, HTML, Markdown, and YouTube/Vimeo Links.'
  s.description      = <<-DESC
This is an iOS UIView that Properly Displays LaTeX, HTML, Markdown, and YouTube/Vimeo Links. Simply feed in an input
string with the relevant rich text surrounded by the appropriate tags and it will render correctly. Specifically:
  - Any math/LaTeX should be in between [math] and [/math] tags
  - Any code should be in between [code] and [/code] tags
  - Any YouTube videos should be represented as youtube[x], where x is the ID of the YouTube video
  - Any Vimeo videos should be represented as vimeo[y], where y is the ID of the Vimeo video
                       DESC

  s.homepage         = 'https://github.com/tophat/RichTextView'
  s.license          = { :type => 'Apache-2', :file => 'LICENSE' }
  s.author           = { 'Top Hat' => 'tophat' }
  s.source           = { :git => 'https://github.com/tophat/RichTextView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.source_files = 'Source/*.swift', 'Source/Text Parsing/*.swift', 'Source/Constants/*.swift', 'Source/Extensions/*.swift', 'Source/View Generators/*.swift', 'Source/Delegates/*.swift'
  s.dependency 'Down'
  s.dependency 'iosMath'
  s.dependency 'SnapKit'
  s.dependency 'SwiftRichString'
  s.swift_version = '5.0'
end
