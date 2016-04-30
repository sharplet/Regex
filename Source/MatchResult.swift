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
  ///     if let match = pattern.match("aaa") {
  ///       match.matchedString // "aaa"
  ///     }
  ///
  ///     if let match = pattern.match("bbb") {
  ///       match.matchedString // ""
  ///     }
  public var matchedString: String {
    return _result.matchedString
  }

  /// The range of the matched string.
  ///
  /// - note: This property currently assumes that it is always possible to
  ///   create a valid character range based on the underlying UTF-16 range.
  ///   If for some reason this turns out not to be true, it will trap.
  ///
  /// - returns: The character range of the matched string.
  internal var range: Range<String.Index> {
    let utf16range = _result.range
    let start = String.Index(utf16range.lowerBound, within: _string)!
    let end = String.Index(utf16range.upperBound, within: _string)!
    return start..<end
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
  ///     regex.match("ab")?.captures // [Optional("a"), Optional("b")]
  ///     regex.match("b")?.captures // [nil, Optional("b")]
  public var captures: [String?] {
    return _result.captures
  }

  // MARK: Internal initialisers

  internal var matchResult: NSTextCheckingResult {
    return _result.result
  }

  private let _result: _MatchResult
  private let _string: String

  internal init(_ string: String, _ result: NSTextCheckingResult) {
    self._result = _MatchResult(string.utf16, result)
    self._string = string
  }

}

// Use of a private class allows for lazy vars without the need for `mutating`.
private final class _MatchResult {

  private let string: String.UTF16View
#if swift(>=3.0)
  fileprivate let result: NSTextCheckingResult
#else
  private let result: NSTextCheckingResult
#endif

#if swift(>=3.0)
  fileprivate init(_ string: String.UTF16View, _ result: NSTextCheckingResult) {
    self.string = string
    self.result = result
  }
#else
  private init(_ string: String.UTF16View, _ result: NSTextCheckingResult) {
    self.string = string
    self.result = result
  }
#endif

  lazy var range: Range<String.UTF16Index> = {
    return self.rangeFromNSRange(self.string, self.result.range)!
  }()

  lazy var captures: [String?] = {
    return self.captureRanges.map { $0.map { self.substringFromRange(self.string, $0) } }
  }()

  lazy var captureRanges: [Range<String.UTF16Index>?] = {
    return self.result.ranges.dropFirst().map { self.rangeFromNSRange(self.string, $0) }
  }()

  lazy var matchedString: String = {
    return self.substringFromRange(self.string, self.rangeFromNSRange(self.string, self.result.range)!)
  }()

  private let rangeFromNSRange: (String.UTF16View, NSRange) -> Range<String.UTF16Index>? = { string, range in
    guard range.location != NSNotFound else { return nil }
#if swift(>=3.0)
    let start = string.startIndex.advanced(by: range.location)
    let end = start.advanced(by: range.length)
#else
    let start = string.startIndex.advancedBy(range.location)
    let end = start.advancedBy(range.length)
#endif
    return start..<end
  }

  private let substringFromRange: (String.UTF16View, Range<String.UTF16Index>) -> String = { string, range in
    return string[range].description
  }

}
