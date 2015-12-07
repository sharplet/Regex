Pod::Spec.new do |s|
  s.name         = File.basename(__FILE__, ".podspec")
  s.version      = %x(git describe --tags --abbrev=0).chomp.sub(/^v/, '')
  s.summary      = %x(curl -s https://api.github.com/repos/sharplet/Regex | ruby -rjson -e 'puts JSON.parse($stdin.read).fetch("description")').chomp
  s.homepage     = "https://github.com/sharplet/Regex"
  s.license      = "LICENSE.txt"
  s.author       = "Adam Sharp"
  s.source       = { :git => "https://github.com/sharplet/Regex.git", :tag => "v#{s.version}" }
  s.source_files = "Source/**/*.swift"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
end
