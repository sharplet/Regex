import PackageDescription

#if os(Linux) && !swift(>=3.1)
fatalError("On Linux this package requires Swift >=3.1")
#endif

let package = Package(
  name: "Regex"
)
