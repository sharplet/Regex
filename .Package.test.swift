// swift-tools-version:3.1

import PackageDescription

let package = Package(
  name: "Regex",
  dependencies: [
    .Package(url: "https://github.com/Quick/Quick.git", majorVersion: 1),
    .Package(url: "https://github.com/Quick/Nimble.git", majorVersion: 7),
  ]
)
