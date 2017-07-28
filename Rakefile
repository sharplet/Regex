desc "Set up the project for development"
task :setup do
  platform = ENV.fetch("PLATFORM", nil)
  if platform
    sh "carthage bootstrap --cache-builds --platform #{platform}"
  else
    sh "carthage bootstrap --cache-builds"
  end
end

namespace :build do
  desc "Build and validate the podspec"
  task :pod do
    sh "pod lib lint *.podspec --quick --no-clean"
  end

  namespace :carthage do
    %w[iOS macOS tvOS watchOS].each do |platform|
      desc "Build the Carthage framework on #{platform}"
      task platform.downcase.to_sym do
        sh "carthage build --platform #{platform} --no-skip-current"
      end
    end
  end

  desc "Build the Swift package"
  task :package do
    sh "swift build"
  end
end

desc "Run swiftlint if available"
task :swiftlint do
  return unless system "which -s swiftlint"
  exec "swiftlint"
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
    pretty "xcodebuild build-for-testing test-without-building -project Regex.xcodeproj -scheme Regex-OSX"
  end

  desc "Run tests on iOS Simulator"
  task :ios do
    pretty "xcodebuild build-for-testing test-without-building -project Regex.xcodeproj -scheme Regex-iOS -destination 'platform=iOS Simulator,name=iPhone 6s'"
  end

  desc "Run tests on tvOS Simulator"
  task :tvos do
    pretty "xcodebuild build-for-testing test-without-building -project Regex.xcodeproj -scheme Regex-tvOS -destination 'platform=tvOS Simulator,name=Apple TV 1080p'"
  end

  desc "Run the SwiftPM tests"
  task :package do
    sh "env SWIFT_PACKAGE_TEST_REGEX=true swift test"
  end
end

desc "Run all tests"
task :test => ["test:osx", "test:ios", "test:tvos", "test:watchos", "test:package"]

desc "Open project in a docker container"
task :docker do
  sh "docker build -t regex ."
  exec "docker run --privileged=true -v $PWD:/Regex -w /Regex -it regex"
end

task :default => :test
