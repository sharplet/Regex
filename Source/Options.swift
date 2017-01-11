import Foundation

/// `Options` defines alternate behaviours of regular expressions when matching.
public struct Options: OptionSet {

  /// Ignores the case of letters when matching.
  ///
  /// Example:
  ///
  ///     let a = Regex("a", options: .ignoreCase)
  ///     a.allMatches(in: "aA").map { $0.matchedString } // ["a", "A"]
  public static let ignoreCase = Options(rawValue: 1)

  /// Ignore any metacharacters in the pattern, treating every character as
  /// a literal.
  ///
  /// Example:
  ///
  ///     let parens = Regex("()", options: .ignoreMetacharacters)
  ///     parens.matches("()") // true
  public static let ignoreMetacharacters = Options(rawValue: 1 << 1)

  /// By default, "^" matches the beginning of the string and "$" matches the
  /// end of the string, ignoring any newlines. With this option, "^" will
  /// the beginning of each line, and "$" will match the end of each line.
  ///
  ///     let foo = Regex("^foo", options: .anchorsMatchLines)
  ///     foo.allMatches(in: "foo\nbar\nfoo\n").count // 2
  public static let anchorsMatchLines = Options(rawValue: 1 << 2)

  /// Usually, "." matches all characters except newlines (\n). Using this
  /// this options will allow "." to match newLines
  ///
  ///     let newLines = Regex("test.test", options: .dotMatchesLineSeparators)
  ///     newLines.allMatches(in: "test\ntest").count // 1
  public static let dotMatchesLineSeparators = Options(rawValue: 1 << 3)

  // MARK: OptionSetType

  public let rawValue: Int

  public init(rawValue: Int) {
    self.rawValue = rawValue
  }

}

internal extension NSRegularExpression.Options {

  init(_ options: Options) {
    self = []
    if options.contains(.ignoreCase) { insert(.caseInsensitive) }
    if options.contains(.ignoreMetacharacters) { insert(.ignoreMetacharacters) }
    if options.contains(.anchorsMatchLines) { insert(.anchorsMatchLines) }
    if options.contains(.dotMatchesLineSeparators) { insert(.dotMatchesLineSeparators) }
  }

}

// MARK: Deprecations / Removals

extension Options {

  @available(*, unavailable, renamed: "ignoreCase")
  public static var IgnoreCase: Options {
    fatalError()
  }

  @available(*, unavailable, renamed: "ignoreMetacharacters")
  public static var IgnoreMetacharacters: Options {
    fatalError()
  }

  @available(*, unavailable, renamed: "anchorsMatchLines")
  public static var AnchorsMatchLines: Options {
    fatalError()
  }

  @available(*, unavailable, renamed: "dotMatchesLineSeparators")
  public static var DotMatchesLineSeparators: Options {
    fatalError()
  }

}
