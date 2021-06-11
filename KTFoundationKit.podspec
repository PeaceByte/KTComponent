# Start from https://github.com/CocoaPods/pod-template/blob/master/NAME.podspec
#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KTFoundationKit'
  s.version          = '0.0.1'
  s.summary          = 'KT Foundation components'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Contains the decomponents for Design System.
                       DESC

  s.homepage         = 'https://github.com/PeaceByte/KTComponent'
  s.license          = 'MIT'
  s.author           = { :type => "MIT", :file => "LICENSE.md" }
  s.source           =  { :git => "https://github.com/PeaceByte/KTComponent.git", :tag => s.version.to_s }
  s.requires_arc  = true
  s.ios.deployment_target = '10.0'
  s.swift_versions = '5.3'

  s.source_files = 'KTFoundationKit/**/*','KTFoundationKit/*.h'
  # s.resources = 'assets/**/*'
  s.dependency 'XCGLogger'

end
