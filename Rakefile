require_relative "lib/suite_task"

desc "Set up the project for development"
task :setup do
  sh "carthage bootstrap --platform iphoneos,macosx"
end

namespace :build do
  desc "Build for all platforms"
  suite :build => [:pod, :framework, :package]

  desc "Build and validate the podspec"
  task :pod do
    sh "pod lib lint *.podspec --no-clean"
  end

  desc "Build the framework"
  task :framework do
    sh "carthage build --no-skip-current"
  end

  desc "Build the Swift package"
  task :package do
    sh "swift build"
  end
end

desc "Clean built products"
task :clean do
  Dir["build/", "Carthage/Build/*/Regex.framework*"].each do |f|
    rm_rf(f)
  end
  sh "swift build --clean"
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
