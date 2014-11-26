#
# Be sure to run `pod lib lint SIMDictionaryMapper.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SIMDictionaryMapper"
  s.version          = "0.1.0"
  s.summary          = "Simple library for mapping dictionnary on object."
  s.description      = <<-DESC
                       This library contains 2 classes.
                        * First - resource for mapping dictionary on resource model.
                        * Second - for formatting dictionary fields
                       DESC
  s.homepage         = "https://github.com/dearkato/SIMDictionaryMapper"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Yekaterina Gekkel" => "gekkelkate@gmail.com" }
  s.source           = { :git => "https://github.com/dearkato/SIMDictionaryMapper.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'SIMDictionaryMapper' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
