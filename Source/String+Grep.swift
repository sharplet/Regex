extension String {

  public func grep(regex: Regex) -> AnySequence<(String, MatchResult)> {
    return lines().grep(regex)
  }

  public func grep(pattern: String) -> AnySequence<(String, MatchResult)> {
    return grep(Regex(pattern))
  }

  internal func lines() -> AnySequence<String> {
    var searchRange = characters.startIndex..<characters.endIndex

    func rangeOfNewline() -> Range<String.Index>? {
      guard let newline = self.rangeOfCharacterFromSet(.newlineCharacterSet(), options: [], range: searchRange) else {
        return nil
      }

      let nextCharacter = newline.endIndex..<newline.endIndex.advancedBy(1, limit: searchRange.endIndex)

      if !nextCharacter.isEmpty && self[newline] == "\r" && self[nextCharacter] == "\n" {
        return newline.startIndex..<nextCharacter.endIndex
      } else {
        return newline
      }
    }

    let lines: AnyGenerator<String> = anyGenerator {
      if let newline = rangeOfNewline() {
        let lineRange = searchRange.startIndex..<newline.endIndex
        searchRange.startIndex = newline.endIndex
        return self[lineRange]

      } else if !searchRange.isEmpty {
        let lastLineRange = searchRange
        searchRange.startIndex = searchRange.endIndex
        return self[lastLineRange]

      } else {
        return nil
      }
    }

    return AnySequence(lines)
  }

}

import Foundation
