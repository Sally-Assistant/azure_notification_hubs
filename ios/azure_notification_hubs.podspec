#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint azure_notification_hubs.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'azure_notification_hubs'
  s.version          = '1.0.0'
  s.summary          = 'Flutter support for using Azure Push Notifications in iOS apps.'
  s.description      = <<-DESC
  Flutter support for using Azure Push Notifications in iOS apps.
                       DESC
  s.homepage         = 'https://aliru.de'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Aliru UG' => 'benedikt.dreher@aliru.de' }
  s.source           = { :path => '.' } # TODO: Update source for git repo
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'
end
