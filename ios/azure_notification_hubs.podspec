#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint azure_notification_hubs.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'azure_notification_hubs'
  s.version          = '0.0.1'
  s.summary          = 'Flutter support for using Azure Push Notifications in iOS apps.'
  s.description      = <<-DESC
  Flutter support for using Azure Push Notifications in iOS apps.
                       DESC
  s.homepage         = 'https://aliru.de'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Aliru UG' => 'benedikt.dreher@aliru.de' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'WindowsAzureMessaging'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  # s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  # s.swift_version = '4.2'
end
