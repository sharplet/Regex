import struct Foundation.NSRange
import class Foundation.NSRegularExpression

/// A sequence of lazily enumerated regular expression matches in a given string.
public struct MatchSequence: Sequence {
  var regex: NSRegularExpression
  var string: String

  public func makeIterator() -> MatchIterator {
    return MatchIterator(regex: regex, string: string)
  }
}

/// An iterator that returns regular expression matches in a string one at a time.
public struct MatchIterator: IteratorProtocol {
  var regex: NSRegularExpression
  var string: String
  var searchRange: NSRange?

  init(regex: NSRegularExpression, string: String) {
    self.regex = regex
    self.string = string
    self.searchRange = NSRange(string.startIndex..., in: string)
  }

  public mutating func next() -> MatchResult? {
    guard let searchRange = searchRange else { return nil }

    var match: MatchResult?

    regex.enumerateMatches(in: string, options: .reportCompletion, range: searchRange) { result, _, stop in
      guard let result = result else {
        self.searchRange = nil
        return
      }

      match = MatchResult(result, in: string)
      stop.pointee = true
      self.searchRange = NSRange(match!.range.upperBound..., in: string)
    }

    Regex._lastMatch.value = match

    return match
  }
}
