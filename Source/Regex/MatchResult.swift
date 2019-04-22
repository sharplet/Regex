import class Foundation.NSTextCheckingResult

/// A `MatchResult` encapsulates the result of a single match in a string,
/// providing access to the matched string, as well as any capture groups within
/// that string.
public struct MatchResult {
  let _result: NSTextCheckingResult
  let string: String

  init(_ result: NSTextCheckingResult, in string: String) {
    self._result = result
    self.string = string
  }

  // MARK: Accessing match results

  /// The entire matched string.
  ///
  /// Example:
  ///
  ///     let pattern = Regex("a*")
  ///
  ///     if let match = pattern.firstMatch(in: "aaa") {
  ///       match.matchedString // "aaa"
  ///     }
  ///
  ///     if let match = pattern.firstMatch(in: "bbb") {
  ///       match.matchedString // ""
  ///     }
  public var matchedString: Substring {
    return string[range]
  }

  /// The range of the matched string.
  public var range: Range<String.Index> {
    return Range(_result.range, in: string)!
  }

  /// A collection of the matching strings for each capture group in the regular
  /// expression (if any).
  ///
  /// **Note:** Usually if the match was successful, the captures will by
  /// definition be non-nil. However if a given capture group is optional, the
  /// captured string may also be nil, depending on the particular string that
  /// is being matched against.
  ///
  /// Example:
  ///
  ///     let regex = Regex("(a)?(b)")
  ///
  ///     regex.firstMatch(in: "ab")?.captures // [Optional("a"), Optional("b")]
  ///     regex.firstMatch(in: "b")?.captures // [nil, Optional("b")]
  public var captures: Captures {
    return Captures(result: _result, string: string)
  }
}

extension MatchResult {
  /// A random-access collection of captures for a given `MatchResult`. The
  /// first capture group is always at index 0.
  public struct Captures: RandomAccessCollection {
    var result: NSTextCheckingResult
    var string: String

    public let startIndex: Int = 0

    public var endIndex: Int {
      return result.numberOfRanges - 1
    }

    /// Look up the range of a capture group at the given index, or `nil` if
    /// the capture group was optional and did not match.
    ///
    /// - parameter position: The index of the capture group.
    ///
    /// - returns: The range of the captured string, or `nil`.
    public func range(at position: Int) -> Range<String.Index>? {
      return Range(result.range(at: position + 1), in: string)
    }

    public subscript(position: Int) -> Substring? {
      return range(at: position).map { string[$0] }
    }
  }
}

extension MatchResult.Captures: CustomStringConvertible {
  public var description: String {
    var description = "["
    description += self.lazy.map(String.init(reflecting:)).joined(separator: ", ")
    description += "]"
    return description
  }
}
