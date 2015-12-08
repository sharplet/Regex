desc "Set up the project for development"
task :setup do
  sh "carthage bootstrap --platform iphoneos,macosx"
end

namespace :test do
  def pretty(cmd)
    if system("which", "xcpretty", [:out, :err] => "/dev/null")
      sh("/bin/sh", "-o", "pipefail", "-c", "#{cmd} | xcpretty")
    else
      sh(cmd)
    end
  end

  desc "Run tests on OS X"
  task :osx do
    pretty "xcodebuild test -scheme Regex-OSX"
  end

  desc "Run tests on iOS Simulator"
  task :ios do
    pretty "xcodebuild test -scheme Regex-iOS -destination 'platform=iOS Simulator,name=iPhone 6s'"
  end
end

desc "Run all tests"
task :test => ["test:osx", "test:ios"]

task :default => :test
