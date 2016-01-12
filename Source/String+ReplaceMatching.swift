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

  public func stringByReplacingFirstMatching(regex: Regex, with template: String) -> String {
    var string = self
    string.replaceFirstMatching(regex, with: template)
    return string
  }

  public func stringByReplacingFirstMatching(pattern: String, with template: String) -> String {
    return stringByReplacingFirstMatching(Regex(pattern), with: template)
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

  public func stringByReplacingAllMatching(regex: Regex, with template: String) -> String {
    var string = self
    string.replaceAllMatching(regex, with: template)
    return string
  }

  public func stringByReplacingAllMatching(pattern: String, with template: String) -> String {
    return stringByReplacingAllMatching(Regex(pattern), with: template)
  }

}

import Foundation
