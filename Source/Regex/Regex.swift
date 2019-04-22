import class Foundation.NSRegularExpression

public struct Regex: CustomStringConvertible, CustomDebugStringConvertible {
  internal let _regex: NSRegularExpression

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
  /// - throws: An error describing the invalid regular expression.
  public init(string pattern: String, options: Options = []) throws {
    self._regex = try NSRegularExpression(
      pattern: pattern,
      options: options.toNSRegularExpressionOptions()
    )
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
      try self.init(string: String(describing: pattern), options: options)
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
  public func matches(_ string: String) -> Bool {
    return firstMatch(in: string) != nil
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
  public func firstMatch(in string: String) -> MatchResult? {
    var matches = self.matches(in: string).makeIterator()
    return matches.next()
  }

  /// Returns a `MatchSequence` that will enumerate all matches in the provided
  /// `string`, one by one.
  ///
  /// - parameter string: The string to match against.
  ///
  /// - returns: A sequence of `MatchResult` describing each match in `string`.
  public func matches(in string: String) -> MatchSequence {
    return MatchSequence(regex: _regex, string: string)
  }

  // MARK: Describing

  public var description: String {
    return _regex.pattern
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
public func ~= (regex: Regex, string: String) -> Bool {
  return regex.matches(string)
}

// MARK: Conformances

extension Regex: Hashable {}

extension Regex: Codable {
  public init(from decoder: Decoder) throws {
    let string = try decoder.singleValueContainer().decode(String.self)
    try self.init(string: string)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(_regex.pattern)
  }
}

// MARK: Deprecations / Removals

extension Regex {
  @available(*, unavailable, renamed: "matches(in:)")
  public func allMatches(in string: String) -> [MatchResult] {
    fatalError()
  }
}
