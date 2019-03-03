// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Regex",
    products: [
        .library(name: "Regex", targets: ["Regex"])
    ],
    targets: [
        .target(name: "Regex", dependencies: []),
        .testTarget(name: "RegexTests", dependencies: ["Regex"])
    ],
    swiftLanguageVersions: [.v4_2, .version("5")]
)
