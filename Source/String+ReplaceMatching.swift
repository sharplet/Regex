extension String {

  // MARK: Replacing the first match

  public mutating func replaceFirstMatching(regex: Regex, with template: String) {
    if let match = regex.match(self) {
      let replacement = regex
        .regularExpression
        .replacementStringForResult(match.matchResult,
          inString: self,
          offset: 0,
          template: template)

      replaceRange(match.range, with: replacement)
    }
  }

  public mutating func replaceFirstMatching(pattern: String, with template: String) {
    replaceFirstMatching(Regex(pattern), with: template)
  }

  public func replacingFirstMatching(regex: Regex, with template: String) -> String {
    var string = self
    string.replaceFirstMatching(regex, with: template)
    return string
  }

  public func replacingFirstMatching(pattern: String, with template: String) -> String {
    return replacingFirstMatching(Regex(pattern), with: template)
  }

  // MARK: Replacing all matches

  public mutating func replaceAllMatching(regex: Regex, with template: String) {
    for match in regex.allMatches(self).reverse() {
      let replacement = regex
        .regularExpression
        .replacementStringForResult(match.matchResult,
          inString: self,
          offset: 0,
          template: template)

      replaceRange(match.range, with: replacement)
    }
  }

  public mutating func replaceAllMatching(pattern: String, with template: String) {
    replaceAllMatching(Regex(pattern), with: template)
  }

  public func replacingAllMatching(regex: Regex, with template: String) -> String {
    var string = self
    string.replaceAllMatching(regex, with: template)
    return string
  }

  public func replacingAllMatching(pattern: String, with template: String) -> String {
    return replacingAllMatching(Regex(pattern), with: template)
  }

}

import Foundation
