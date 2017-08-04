import Foundation

/// A `MatchResult` encapsulates the result of a single match in a string,
/// providing access to the matched string, as well as any capture groups within
/// that string.
public struct MatchResult {

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
  public var matchedString: String {
    return _result.matchedString
  }

  /// The range of the matched string.
  public var range: Range<String.Index> {
    return _string.range(from: _result.range)
  }

  /// The matching string for each capture group in the regular expression
  /// (if any).
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
  public var captures: [String?] {
    return _result.captures
  }

  /// The ranges of each capture (if any).
  ///
  /// - seealso: The discussion and example for `MatchResult.captures`.
  public var captureRanges: [Range<String.Index>?] {
    return _captureRanges.value
  }

  // MARK: Internal initialisers

  internal var matchResult: NSTextCheckingResult {
    return _result.result
  }

  private let _captureRanges: Memo<[Range<String.Index>?]>
  private let _result: _MatchResult
  private let _string: String

  internal init(_ string: String, _ result: NSTextCheckingResult) {
    self._result = _MatchResult(string, result)
    self._string = string
    self._captureRanges = Memo { [_result] in
      _result.captureRanges.map { utf16range in
        utf16range.map { string.range(from: $0) }
      }
    }
  }

}

private extension String {
  func range(from utf16Range: Range<UTF16Index>) -> Range<Index> {
#if swift(>=4.0)
    return utf16Range
#else
    let start = Index(utf16Range.lowerBound, within: self)!
    let end = Index(utf16Range.upperBound, within: self)!
    return start..<end
#endif
  }
}

// Use of a private class allows for lazy vars without the need for `mutating`.
private final class _MatchResult {

#if swift(>=4.0)
  private let string: String
#else
  private let string: String.UTF16View
#endif
  fileprivate let result: NSTextCheckingResult

  fileprivate init(_ string: String, _ result: NSTextCheckingResult) {
#if swift(>=4.0)
    self.string = string
#else
    self.string = string.utf16
#endif
    self.result = result
  }

  lazy var range: Range<String.UTF16Index> = {
    return self.utf16Range(from: self.result.range)!
  }()

  lazy var captures: [String?] = {
    return self.captureRanges.map { $0.map(self.substring(from:)) }
  }()

  lazy var captureRanges: [Range<String.UTF16Index>?] = {
    return self.result.ranges.dropFirst().map(self.utf16Range(from:))
  }()

  lazy var matchedString: String = {
    let range = self.utf16Range(from: self.result.range)!
    return self.substring(from: range)
  }()

  private func utf16Range(from range: NSRange) -> Range<String.UTF16Index>? {
#if swift(>=4.0)
    return Range(range, in: string)
#else
    guard range.location != NSNotFound else { return nil }
    let start = string.index(string.startIndex, offsetBy: range.location)
    let end = string.index(start, offsetBy: range.length)
    return start..<end
#endif
  }

  private func substring(from range: Range<String.UTF16Index>) -> String {
    return String(describing: string[range])
  }

}
