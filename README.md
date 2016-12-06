# Regex

Pattern match like a boss.



## Usage

Create:

```swift
// Use `Regex.init(_:)` to build a regex from a static pattern

let greeting = Regex("hello (world|universe)")

// Use `Regex.init(string:)` to construct a regex from dynamic data, and
// gracefully handle invalid input

var validations: [String: Regex]

for (name, pattern) in config.loadValidations() {
  do {
    validations[name] = try Regex(string: pattern)
  } catch {
    print("error building validation \(name): \(error)")
  }
}
```

Match:

```swift
if greeting.matches("hello universe!") {
  print("wow, you're friendly!")
}
```

_Pattern_ match:

```swift
switch someTextFromTheInternet {
case Regex("DROP DATABASE (.+)"):
  // TODO: patch security hole
default:
  break
}
```

Capture:

```swift
let greeting = Regex("hello (world|universe|swift)")

if let subject = greeting.match("hello swift")?.captures[0] {
  print("ohai \(subject)")
}
```

Find and replace:

```swift
"hello world".replacingFirstMatching("h(ello) (\\w+)", with: "H$1, $2!")
// "Hello, world!"
```

Accessing the last match:

```swift
switch text {
case Regex("hello (\\w+)"):
  if let friend = Regex.lastMatch?.captures[0] {
    print("lovely to meet you, \(friend)!")
  }
case Regex("goodbye (\\w+)"):
  if let traitor = Regex.lastMatch?.captures[0] {
    print("so sorry to see you go, \(traitor)!")
  }
default:
  break
}
```

Options:

```swift
let totallyUniqueExamples = Regex("^(hello|foo).*$", options: [.IgnoreCase, .AnchorsMatchLines])
let multilineText = "hello world\ngoodbye world\nFOOBAR\n"
let matchingLines = totallyUniqueExamples.allMatches(multilineText).map { $0.matchedString }
// ["hello world", "FOOBAR"]
```



## Installation

#### Swift Package Manager

Add a dependency to your `Package.swift`:

```swift
let package = Package(
  name: "MyPackage",
  dependencies: [
    // other dependencies...
    .Package(url: "https://github.com/sharplet/Regex.git", majorVersion: 0, minor: 4),
  ]
)
```

#### Carthage

Put this in your Cartfile:

```
github "sharplet/Regex" ~> 0.4
```

#### CocoaPods

Put this in your Podfile:

```ruby
pod "STRegex", "~> 0.4.0"
```



## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).



## Development Setup

Development is currently only supported on Mac OS X. An Xcode project is
provided for your convenience.

Regex depends on Carthage for development:

```
$ brew update && brew install carthage
```

Regex uses [SwiftLint](https://github.com/realm/SwiftLint) to validate code style.
SwiftLint is automatically run against pull requests using [Hound CI](https://houndci.com/).

To enable SwiftLint warnings in Xcode, just make sure it's installed and available on Xcode's PATH:

```
$ brew install swiftlint
```

`xcpretty` is also recommended, for prettifying test output:

```
$ gem install xcpretty
```

After cloning the project, first set up your environment:

```
$ rake setup
```

Build and run the tests to ensure everything works:

```
$ rake
```



## License

See [LICENSE.txt](LICENSE.txt).
