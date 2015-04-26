#
# Be sure to run `pod lib lint TFTableDescriptor.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TFTableDescriptor"
  s.version          = "1.1.0"
  s.summary          = "Simple table descriptor with dynamic cell height support"
  s.description      = <<-DESC
                       TFTableDescriptor is simple table descriptor that helps you describe how a table content should looks like (sections, row). It have a dynamic cell height support for iOS 7 and higher.
                       DESC
  s.homepage         = "https://github.com/thefuntasty/TFTableDescriptor"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Ales Kocur" => "ales@thefuntasty.com" }
  s.source           = { :git => "https://github.com/thefuntasty/TFTableDescriptor.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'TFTableDescriptor' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
