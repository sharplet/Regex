//  Copyright © 2015 Outware Mobile. All rights reserved.

public struct MatchResult {

  // MARK: Accessing match results

  public var captures: [String] {
    return _result.captures
  }

  public var matchedString: String {
    return _result.matchedString
  }

  // MARK: Internal initialisers

  private let _result: _MatchResult

  internal init(_ string: String.UTF16View, _ result: NSTextCheckingResult) {
    self._result = _MatchResult(string, result)
  }

}

// Use of a private class allows for lazy vars without the need for `mutating`.
private final class _MatchResult {

  private let string: String.UTF16View
  private let result: NSTextCheckingResult

  private init(_ string: String.UTF16View, _ result: NSTextCheckingResult) {
    self.string = string
    self.result = result
  }

  lazy var captures: [String] = {
    return self.captureRanges.map(self.substringFromRange)
  }()

  lazy var captureRanges: [Range<String.UTF16Index>] = {
    return self.result.ranges.dropFirst().map(self.rangeFromNSRange)
  }()

  lazy var matchedString: String = {
    return self.substringFromRange(self.rangeFromNSRange(self.result.range))
  }()

  private func rangeFromNSRange(range: NSRange) -> Range<String.UTF16Index> {
    let start = string.startIndex.advancedBy(range.location)
    let end = start.advancedBy(range.length)
    return start..<end
  }

  private func substringFromRange(range: Range<String.UTF16Index>) -> String {
    return String(string[range])
  }

}
