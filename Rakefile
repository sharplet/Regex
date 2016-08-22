require_relative "lib/suite_task"

desc "Set up the project for development"
task :setup do
  sh "carthage bootstrap --no-build"
end

namespace :build do
  desc "Build for all platforms"
  suite :all => [:pod, :framework, :package]

  desc "Build and validate the podspec"
  task :pod do
    sh "pod lib lint *.podspec --quick --no-clean"
  end

  desc "Build the framework"
  task :framework do
    sh "carthage build --no-skip-current"
  end

  desc "Build the Swift package"
  task :package do
    if ENV["TRAVIS"] == "true"
      puts "warning: Skipping swift build while Swift 3 is in development"
      next
    end
    sh "swift build"
  end
end

desc "Run swiftlint if available"
task :swiftlint do
  system "which -s swiftlint" and exec "swiftlint"
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
    if system("which -s xcpretty")
      sh("/bin/sh", "-o", "pipefail", "-c", "env NSUnbufferedIO=YES #{cmd} | xcpretty")
    else
      sh(cmd)
    end
  end

  desc "Run tests on OS X"
  task :osx do
    pretty "xcodebuild build-for-testing test-without-building -workspace Regex.xcworkspace -scheme Regex-OSX"
  end

  desc "Run tests on iOS Simulator"
  task :ios do
    pretty "xcodebuild build-for-testing test-without-building -workspace Regex.xcworkspace -scheme Regex-iOS -destination 'platform=iOS Simulator,name=iPhone 6s'"
  end

  desc "Run tests on tvOS Simulator"
  task :tvos do
    pretty "xcodebuild build-for-testing test-without-building -workspace Regex.xcworkspace -scheme Regex-tvOS -destination 'platform=tvOS Simulator,name=Apple TV 1080p'"
  end

  desc "Build for watchOS Simulator"
  task :watchos do
    pretty "xcodebuild build -workspace Regex.xcworkspace -scheme Regex-watchOS -destination 'platform=watchOS Simulator,name=Apple Watch - 42mm'"
  end
end

desc "Run all tests"
task :test => ["test:osx", "test:ios", "test:tvos", "test:watchos"]

task :default => :test
