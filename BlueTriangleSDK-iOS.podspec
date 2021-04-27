#
# Be sure to run `pod lib lint BlueTriangleSDK-iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BlueTriangleSDK-iOS'
  s.version          = '2.0.6'
  s.summary          = 'BlueTriangleSDK exposes methods to send analytics and crash data to the Blue Triangle portal'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  BlueTriangleSDK exposes methods to send analytics and crash data to the Blue Triangle portal via HTTP Post
                       DESC

  s.homepage         = 'https://www.bluetriangle.com'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Julian Wilkison-Duran' => 'julian.wilkison@bluetriangle.com' }
  s.source           = { :git => 'https://github.com/blue-triangle-tech/BlueTriangleSDK-iOS.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/_BlueTriangle'

  s.ios.deployment_target = '12.0'

  s.source_files = 'BlueTriangleSDK-iOS/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BlueTriangleSDK-iOS' => ['BlueTriangleSDK-iOS/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
