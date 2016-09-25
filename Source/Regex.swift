public struct Regex: CustomStringConvertible, CustomDebugStringConvertible {

  // MARK: Initialisation

  internal let regularExpression: NSRegularExpression

  /// Create a `Regex` based on a pattern string.
  ///
  /// If `pattern` is not a valid regular expression, an error is thrown
  /// describing the failure.
  ///
  /// - parameters:
  ///     - pattern: A pattern string describing the regex.
  ///     - options: Configure regular expression matching options.
  ///       For details, see `Regex.Options`.
  ///
  /// - throws: A value of `ErrorType` describing the invalid regular expression.
  public init(string pattern: String, options: Options = []) throws {
    regularExpression = try NSRegularExpression(
      pattern: pattern,
      options: options.toNSRegularExpressionOptions())
  }

  /// Create a `Regex` based on a static pattern string.
  ///
  /// Unlike `Regex.init(string:)` this initialiser is not failable. If `pattern`
  /// is an invalid regular expression, it is considered programmer error rather
  /// than a recoverable runtime error, so this initialiser instead raises a
  /// precondition failure.
  ///
  /// - requires: `pattern` is a valid regular expression.
  ///
  /// - parameters:
  ///     - pattern: A pattern string describing the regex.
  ///     - options: Configure regular expression matching options.
  ///       For details, see `Regex.Options`.
  public init(_ pattern: StaticString, options: Options = []) {
    do {
      regularExpression = try NSRegularExpression(
        pattern: pattern.description,
        options: options.toNSRegularExpressionOptions())
    } catch {
      preconditionFailure("unexpected error creating regex: \(error)")
    }
  }

  // MARK: Matching

  /// Returns `true` if the regex matches `string`, otherwise returns `false`.
  ///
  /// - parameter string: The string to test.
  ///
  /// - returns: `true` if the regular expression matches, otherwise `false`.
  ///
  /// - note: If the match is successful, `Regex.lastMatch` will be set with the
  ///   result of the match.
#if swift(>=3.0)
  public func matches(_ string: String) -> Bool {
    return _matches(self, string)
  }
#else
  public func matches(string: String) -> Bool {
    return _matches(self, string)
  }
#endif

  private let _matches: (Regex, String) -> Bool = { regex, string in
    return regex.match(string) != nil
  }

  /// If the regex matches `string`, returns a `MatchResult` describing the
  /// first matched string and any captures. If there are no matches, returns
  /// `nil`.
  ///
  /// - parameter string: The string to match against.
  ///
  /// - returns: An optional `MatchResult` describing the first match, or `nil`.
  ///
  /// - note: If the match is successful, the result is also stored in `Regex.lastMatch`.
#if swift(>=3.0)
  public func match(_ string: String) -> MatchResult? {
    let match = regularExpression
      .firstMatch(in: string, range: string.entireRange)
      .map { MatchResult(string, $0) }
    Regex._lastMatch = match
    return match
  }
#else
  public func match(string: String) -> MatchResult? {
    let match = regularExpression
      .firstMatchInString(string, options: [], range: string.entireRange)
      .map { MatchResult(string, $0) }
    Regex._lastMatch = match
    return match
  }
#endif

  /// If the regex matches `string`, returns an array of `MatchResult`, describing
  /// every match inside `string`. If there are no matches, returns an empty
  /// array.
  ///
  /// - parameter string: The string to match against.
  ///
  /// - returns: An array of `MatchResult` describing every match in `string`.
  ///
  /// - note: If there is at least one match, the first is stored in `Regex.lastMatch`.
#if swift(>=3.0)
  public func allMatches(_ string: String) -> [MatchResult] {
    let matches = regularExpression
      .matches(in: string, range: string.entireRange)
      .map { MatchResult(string, $0) }
    if let firstMatch = matches.first { Regex._lastMatch = firstMatch }
    return matches
  }
#else
  public func allMatches(string: String) -> [MatchResult] {
    let matches = regularExpression
      .matchesInString(string, options: [], range: string.entireRange)
      .map { MatchResult(string, $0) }
    if let firstMatch = matches.first { Regex._lastMatch = firstMatch }
    return matches
  }
#endif

  // MARK: Accessing the last match

  /// After any match, the result will be stored in this property for later use.
  /// This is useful when pattern matching:
  ///
  ///     switch "hello" {
  ///     case Regex("l+"):
  ///       let count = Regex.lastMatch!.matchedString.characters.count
  ///       print("matched \(count) characters")
  ///     default:
  ///       break
  ///     }
  ///
  /// This property uses thread-local storage, and thus is thread safe.
  public static var lastMatch: MatchResult? {
    return _lastMatch
  }

  private static let _lastMatchKey = "me.sharplet.Regex.lastMatch"

  private static var _lastMatch: MatchResult? {
    get { return ThreadLocal(_lastMatchKey).value }
    set { ThreadLocal(_lastMatchKey).value = newValue }
  }

  // MARK: Describing

  public var description: String {
    return regularExpression.pattern
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
///
/// - parameters:
///     - regex: The regular expression to match against.
///     - string: The string to test.
///
/// - returns: `true` if the regular expression matches, otherwise `false`.
public func ~= (regex: Regex, string: String) -> Bool {
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
///
/// - parameters:
///     - regex: The regular expression to match against.
///     - string: The string to test.
///
/// - returns: `true` if the regular expression matches, otherwise `false`.
public func ~= (string: String, regex: Regex) -> Bool {
  return regex.matches(string)
}

import Foundation
