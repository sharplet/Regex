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

if let subject = greeting.firstMatch(in: "hello swift")?.captures[0] {
  print("ohai \(subject)")
}
```

Find and replace:

```swift
"hello world".replacingFirst(matching: "h(ello) (\\w+)", with: "H$1, $2!")
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
let totallyUniqueExamples = Regex("^(hello|foo).*$", options: [.ignoreCase, .anchorsMatchLines])
let multilineText = "hello world\ngoodbye world\nFOOBAR\n"
let matchingLines = totallyUniqueExamples.allMatches(in: multilineText).map { $0.matchedString }
// ["hello world", "FOOBAR"]
```

Decode:

```swift
let json = """
  [
    {
      "name" : "greeting",
      "pattern" : "^(\\\\w+) world!$"
    }
  ]
  """.data(using: .utf8)!

struct Validation: Codable {
  var name: String
  var pattern: Regex
}

let decoder = JSONDecoder()
try decoder.decode(Validation.self, from: json)
// Validation(name: "greeting", pattern: /^(\w+) world!/)
```

Ranges:

```swift
let lyrics = """
  So it's gonna be forever
  Or it's gonna go down in flames
  """

let possibleEndings = Regex("it's gonna (.+)")
    .allMatches(in: lyrics)
    .flatMap { $0.captureRanges[0] }
    .map { lyrics[$0] }

// it's gonna: ["be forever", "go down in flames"]
```



## Installation

Regex supports Swift 4.2 and above, on all Swift platforms.

#### Swift Package Manager

Add a dependency to your `Package.swift`:

```swift
let package = Package(
  name: "MyPackage",
  dependencies: [
    // other dependencies...
    .package(url: "https://github.com/sharplet/Regex.git", from: "2.1.0"),
  ]
)
```

#### Carthage

Put this in your Cartfile:

```
github "sharplet/Regex" ~> 2.1
```

#### CocoaPods

Put this in your Podfile:

```ruby
pod "STRegex", "~> 2.1"
```



## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).



## Development Setup

### Swift Package Manager

Build and run the tests:

```
swift test

# or just

rake test:package
```

If you're on a Mac, testing on Linux is supported via [Docker for Mac](https://www.docker.com/docker-mac).
Once Docker is set up, start a Linux shell:

```
rake docker
```

And run the tests via Swift Package Manager.

### Xcode

`xcpretty` is recommended, for prettifying test output:

```
gem install xcpretty
```

Then run the tests:

```
# one of
rake test:osx
rake test:ios
rake test:tvos
```

### Formatting & Linting

Regex uses [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) to
maintain consistent code formatting.

Regex uses [SwiftLint](https://github.com/realm/SwiftLint) to validate code style.
SwiftLint is automatically run against pull requests using [Hound CI](https://houndci.com/).

When submitting a pull request, running these tools and addressing any issues
is much appreciated!

```
brew bundle
swiftformat .
swiftlint
```



## License

See [LICENSE.txt](LICENSE.txt).
