// swift-tools-version:3.1

import Foundation
import PackageDescription

var isTesting: Bool {
  let environment = ProcessInfo.processInfo.environment
  guard let value = environment["SWIFT_PACKAGE_TEST_REGEX"] else { return false }
  return NSString(string: value).boolValue
}

var package = Package(
  name: "Regex",
  swiftLanguageVersions: [3, 4]
)

if isTesting {
  package.dependencies.append(contentsOf: [
    .Package(url: "https://github.com/Quick/Quick.git", majorVersion: 1),
    .Package(url: "https://github.com/Quick/Nimble.git", majorVersion: 7),
  ])
}
