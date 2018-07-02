#
# Be sure to run `pod lib lint BXTransition.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BXTransition'
  s.version          = '0.1.0'
  s.summary          = 'BXTransition is a smooth and simple way to made your iOS app more interactive.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
With BXTransition you can add the same transition that Instagram and Snapchat have on their app with just a few lines of code.
                       DESC

  s.homepage         = 'https://github.com/brenoxp/BXTransition'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brenoxp2008@hotmail.com' => 'brenoxp2008@gmail.com' }
  s.source           = { :git => 'https://github.com/brenoxp/BXTransition.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'BXTransition/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BXTransition' => ['BXTransition/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
