/// A lazily-enumerated sequence of regular expression matches in a given search
/// string. The search is lazy in that in that each match only consumes as much
/// of the search string as necessary (i.e., the entire string won't be searched
/// if only a single match is generated).
///
///     let matches = Regex("a").enumerateMatches("aaa")
///     matches.map { $0.matchedString } // ["a", "a", "a"]
///
/// - note: A `MatchSequence` can only be constructed by calling
///   `enumerateMatches(_:)` on `Regex`.
public struct MatchSequence: SequenceType {

  // MARK: SequenceType

  public typealias Generator = MatchGenerator

  public func generate() -> MatchGenerator {
    return MatchGenerator(regularExpression, string)
  }

  // MARK: Initialisation

  private let regularExpression: NSRegularExpression
  private let string: String

  internal init(_ regularExpression: NSRegularExpression, _ string: String) {
    self.regularExpression = regularExpression
    self.string = string
  }

}

// MARK: -

public struct MatchGenerator: GeneratorType {

  // MARK: GeneratorType

  public typealias Element = MatchResult

  public mutating func next() -> MatchResult? {
    var next: MatchResult?

    // Using `.ReportCompletion` means that after the search string is exhausted,
    // the block is called once more with a `nil` result.
    regularExpression.enumerateMatchesInString(string, options: .ReportCompletion, range: searchRange) { result, flags, stop in
      next = result.map { result in
        self.consumeMatch(result)
        return MatchResult(self.string, result)
      }

      // Always stop after a match — the next search will pick up where this one left off.
      stop.memory = true
    }

    return next
  }

  // MARK: Initialisation

  private let regularExpression: NSRegularExpression
  private let string: String

  private init(_ regularExpression: NSRegularExpression, _ string: String) {
    self.regularExpression = regularExpression
    self.string = string
    self._searchRange = string.utf16.startIndex..<string.utf16.endIndex
  }

  // MARK: Managing the search range

  private var searchRange: NSRange {
    let location = string.utf16.startIndex.distanceTo(_searchRange.startIndex)
    let length = _searchRange.count
    return NSRange(location: location, length: length)
  }
  private var _searchRange: Range<String.UTF16Index>

  private mutating func consumeMatch(result: NSTextCheckingResult) {
    let start = string.utf16.startIndex
    let limit = string.utf16.endIndex

    let match = start.advancedBy(result.range.location)
    let next = match.advancedBy(result.range.length, limit: limit)

    _searchRange = next..<limit
  }

}

import Foundation
