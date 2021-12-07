#
# Be sure to run `pod lib lint DeviceStateMonitor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DeviceStateMonitor'
  s.version          = '0.0.3'
  s.summary          = 'DeviceStateMonitor wraps logic about different device state events like: battery state, thermal state, power mode'

  s.homepage         = 'https://dashdevs.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dashdevs llc' => 'hello@dashdevs.com' }
  s.source           = { :git => 'https://github.com/dashdevs/DeviceStateMonitor.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'Sources/DeviceStateMonitor/**/*'
  s.frameworks = 'UIKit'
  
  s.swift_version = '4.2'
end
