//  Copyright © 2015 Outware Mobile. All rights reserved.

final class RegexSpec: QuickSpec {
  override func spec() {

    describe("Regex") {
      it("is string literal convertible") {
        let regex: Regex = "foo"
        expect(regex).notTo(beNil())
      }

      it("matches with no capture groups") {
        let regex = Regex("now you're matching with regex")
        expect(regex).to(match("now you're matching with regex"))
      }

      it("matches a single capture group") {
        let regex = Regex("foo (bar|baz)")
        expect(regex).to(capture("bar", from: "foo bar"))
      }

      it("matches multiple capture groups") {
        let regex = Regex("foo (bar|baz) (123|456)")
        expect(regex).to(capture("baz", "456", from: "foo baz 456"))
      }

      it("doesn't include the entire match in the list of captures") {
        let regex = Regex("foo (bar|baz)")
        expect(regex).notTo(capture("foo bar", from: "foo bar"))
      }

      it("provides access to the entire matched string") {
        let regex = Regex("foo (bar|baz)")
        expect(regex.match("foo bar")?.matchedString).to(equal("foo bar"))
      }

      it("can match a regex multiple times in the same string") {
        let regex = Regex("(foo)")
        expect(regex.allMatches("foo foo foo").flatMap { $0.captures }).to(equal(["foo", "foo", "foo"]))
      }

      it("supports the match operator") {
        let matched: Bool

        switch "eat some food" {
        case Regex("foo"):
          matched = true
        default:
          matched = false
        }

        expect(matched).to(beTrue())
      }

      it("supports the match operator in reverse") {
        let matched: Bool

        switch Regex("foo") {
        case "fool me twice":
          matched = true
        default:
          matched = false
        }

        expect(matched).to(beTrue())
      }
    }

  }
}

private func match(string: String) -> NonNilMatcherFunc<Regex> {
  return NonNilMatcherFunc { actual, failureMessage in
    let regex: Regex! = try! actual.evaluate()
    failureMessage.stringValue = "expected <\(regex)> to match <\(string)>"
    return regex.matches(string)
  }
}

private func capture(captures: String..., from string: String) -> NonNilMatcherFunc<Regex> {
  return NonNilMatcherFunc { actual, failureMessage in
    let regex: Regex! = try! actual.evaluate()

    failureMessage.stringValue = "expected <\(regex)> to capture <\(captures)> from <\(string)>"

    for expected in captures {
      guard let match = regex.match(string) where match.captures.contains(expected)
      else { return false }
    }

    return true
  }
}

import Quick
import Nimble
import Regex
