//  Copyright © 2015 Outware Mobile. All rights reserved.

public struct Regex: StringLiteralConvertible, CustomStringConvertible, CustomDebugStringConvertible {

  // MARK: Initialisation

  private let regex: NSRegularExpression

  public init(_ pattern: String) {
    regex = try! NSRegularExpression(pattern: pattern, options: [])
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

  public func matches(string: String) -> Bool {
    return match(string) != nil
  }

  public func match(string: String) -> MatchResult? {
    return regex.firstMatchInString(string, options: [], range: string.entireRange).map { MatchResult(string.utf16, $0) }
  }

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

public func ~=(regex: Regex, string: String) -> Bool {
  return regex.matches(string)
}

public func ~=(string: String, regex: Regex) -> Bool {
  return regex.matches(string)
}

import Foundation
