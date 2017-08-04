// swift-tools-version:4.0

import PackageDescription

let package = Package(
  name: "Regex",
  products: [
    .library(name: "Regex", targets: ["Regex"]),
  ],
  dependencies: [
    .package(url: "https://github.com/Quick/Quick.git", from: "1.1.0"),
    .package(url: "https://github.com/Quick/Nimble.git", from: "7.0.1"),
  ],
  targets: [
    .target(name: "Regex", dependencies: [], path: "Source"),
    .testTarget(name: "RegexTests", dependencies: [
      "Nimble",
      "Quick",
      "Regex",
    ]),
  ],
  swiftLanguageVersions: [3, 4]
)
