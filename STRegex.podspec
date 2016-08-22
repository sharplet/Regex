Pod::Spec.new do |s|
  s.name         = File.basename(__FILE__, ".podspec")
  s.version      = %x(git describe --tags --abbrev=0).chomp.sub(/^v/, '')
  s.summary      = "A Swift µframework providing an NSRegularExpression-backed Regex type"
  s.homepage     = "https://github.com/sharplet/Regex"
  s.license      = "LICENSE.txt"
  s.author       = "Adam Sharp"
  s.social_media_url = "https://twitter.com/sharplet"
  s.source       = { :git => "https://github.com/sharplet/Regex.git", :tag => s.version.to_s }
  s.source_files = "Source/**/*.swift"
  s.module_name  = "Regex"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
end
