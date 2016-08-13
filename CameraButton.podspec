#
# Be sure to run `pod lib lint CameraButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CameraButton'
  s.version          = '0.1.1'
  s.summary          = 'A subclass of UIButton that can be used to integrate camera on any app.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is a subclass of UIButton, that will allow to include photo capturing functionality in any app as easy as subclassing a button and changing a couple of configuration
                       DESC

  s.homepage         = 'https://github.com/subarna-santra/CameraButton.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Subarna Santra' => 'subarna.santra@gmail.com' }
  s.source           = { :git => 'https://github.com/subarnas-repo/CameraButton.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CameraButton/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CameraButton' => ['CameraButton/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
