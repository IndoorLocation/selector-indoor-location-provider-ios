Pod::Spec.new do |s|
  s.name         = "SelectorIndoorLocationProvider"
  s.version      = "1.0.0"
  s.license      = { :type => 'MIT' }
  s.summary      = "Allows to set an IndoorLocation manually"
  s.homepage     = "https://github.com/IndoorLocation/selector-indoor-location-provider-ios.git"
  s.author       = { "Indoor Location" => "indoorlocation@mapwize.io" }
  s.platform     = :ios
  s.ios.deployment_target = '6.0'
  s.source       = { :git => "https://github.com/IndoorLocation/selector-indoor-location-provider-ios.git", :tag => "#{s.version}" }
  s.source_files  = "selector-indoorlocation-provider-ios/Provider/*.{h,m}"
  s.dependency "IndoorLocation", "~> 1.0"
end
