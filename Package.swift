import PackageDescription

#if os(Linux) && !swift(>=3.1)
fatalError("On Linux this package requires Swift >=3.1")
#endif

let package = Package(
  name: "Regex",
  dependencies: [
    .Package(url: "https://github.com/Quick/Quick.git", majorVersion: 1),
    .Package(url: "https://github.com/Quick/Nimble.git", majorVersion: 5),
  ]
)
