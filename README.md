# Regex

Pattern match like a boss.

## Usage

Create:

```swift
let greeting = Regex("hello (world|universe)")

let magic: Regex = "(.*)"
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
let greeting: Regex = "hello (world|universe|swift)"

if let subject = greeting.match("hello swift")?.captures[0] {
  print("ohai \(subject)")
}
```

## Installation

#### Carthage

Put this in your Cartfile:

```
github "sharplet/Regex"
```

#### CocoaPods

Put this in your Podfile:

```
pod "Regex", git: "https://github.com/sharplet/Regex.git"
```
