Pod::Spec.new do |s|
  s.name         = "Regex"
  s.version      = %x(git describe --tags --abbrev=0).chomp.sub(/^v/, '')
  s.summary      = "A Swift µframework providing an NSRegularExpression-backed Regex type"
  s.homepage     = "https://github.com/sharplet/Regex"
  s.license      = "LICENSE.txt"
  s.author       = "Adam Sharp"
  s.source       = { :git => "https://github.com/sharplet/Regex.git", :tag => "v#{s.version}" }
  s.source_files = "Regex/**/*.swift"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
end
