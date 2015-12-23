public struct Regex: StringLiteralConvertible, CustomStringConvertible, CustomDebugStringConvertible {

  // MARK: Initialisation

  private let regex: NSRegularExpression

  /// Create a `Regex` based on a pattern string.
  ///
  /// - parameters:
  ///     - pattern: A pattern string describing the regex.
  ///     - options: Configure regular expression matching options.
  ///       For details, see `Regex.Options`.
  ///
  /// - note: You should always use string literals when defining regex
  ///   patterns. If the input string is an invalid regular expression, this
  ///   initialiser will raise a fatal error.
  public init(_ pattern: String, options: Options = []) {
    do {
      regex = try NSRegularExpression(pattern: pattern, options: options.toNSRegularExpressionOptions())
    } catch {
      fatalError("expected a valid regex: \(error)")
    }
  }

  public init(stringLiteral value: String) {
    self.init(value)
  }

  public init(extendedGraphemeClusterLiteral value: String) {
    self.init(value)
  }

  public init(unicodeScalarLiteral value: String) {
    self.init(value)
  }

  // MARK: Matching

  /// Returns `true` if the regex matches `string`, otherwise returns `false`.
  public func matches(string: String) -> Bool {
    return match(string) != nil
  }

  /// If the regex matches `string`, returns a `MatchResult` describing the
  /// first matched string and any captures. If there are no matches, returns
  /// `nil`.
  ///
  /// - parameter string: The string to match against.
  ///
  /// - returns: An optional `MatchResult` describing the first match, or `nil`.
  public func match(string: String) -> MatchResult? {
    return regex.firstMatchInString(string, options: [], range: string.entireRange).map { MatchResult(string.utf16, $0) }
  }

  /// If the regex matches `string`, returns an array of `MatchResult`, describing
  /// every match inside `string`. If there are no matches, returns an empty
  /// array.
  ///
  /// - parameter string: The string to match against.
  ///
  /// - returns: An array of `MatchResult` describing every match in `string`.
  public func allMatches(string: String) -> [MatchResult] {
    return regex.matchesInString(string, options: [], range: string.entireRange).map { MatchResult(string.utf16, $0) }
  }

  // MARK: Describing

  public var description: String {
    return regex.pattern
  }

  public var debugDescription: String {
    return "/\(description)/"
  }

}

// MARK: Pattern matching

/// Match `regex` on the left with some `string` on the right. Equivalent to
/// `regex.matches(string)`, and allows for the use of a `Regex` in pattern
/// matching contexts, e.g.:
///
///     switch Regex("hello (\\w+)") {
///     case "hello world":
///       // successful match
///     }
public func ~=(regex: Regex, string: String) -> Bool {
  return regex.matches(string)
}

/// Match `string` on the left with some `regex` on the right. Equivalent to
/// `regex.matches(string)`, and allows for the use of a `Regex` in pattern
/// matching contexts, e.g.:
///
///     switch "hello world" {
///     case Regex("hello (\\w+)"):
///       // successful match
///     }
public func ~=(string: String, regex: Regex) -> Bool {
  return regex.matches(string)
}

import Foundation
