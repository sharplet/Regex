final class RegexSpec: QuickSpec {
  override func spec() {

    describe("Regex") {
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
        expect(regex.firstMatch(in: "foo bar")?.matchedString).to(equal("foo bar"))
      }

      it("can match a regex multiple times in the same string") {
        let regex = Regex("(foo)")
        let matches = regex
          .allMatches(in: "foo foo foo")
          .flatMap { $0.captures }
          .flatMap { $0 }
        expect(matches).to(equal(["foo", "foo", "foo"]))
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

    describe("optional capture groups") {
      let regex = Regex("(a)?(b)")

      it("maintains the position of captures regardless of optionality") {
        expect(regex.firstMatch(in: "ab")?.captures[1]).to(equal("b"))
        expect(regex.firstMatch(in: "b")?.captures[1]).to(equal("b"))
      }

      it("returns nil for an unmatched capture") {
        expect(regex.firstMatch(in: "b")?.captures[0]).to(beNil())
      }
    }

    describe("capture ranges") {
      it("correctly converts from the underlying index type") {
        // U+0061 LATIN SMALL LETTER A
        // U+0065 LATIN SMALL LETTER E
        // U+0301 COMBINING ACUTE ACCENT
        // U+221E INFINITY
        // U+1D11E MUSICAL SYMBOL G CLEF
        let string = "\u{61}\u{65}\u{301}\u{221E}\u{1D11E}"
        let infinity = Regex("(\u{221E})").firstMatch(in: string)!.captures[0]!
        let rangeOfInfinity = string.range(of: infinity)!
        let location = string.distance(from: string.startIndex, to: rangeOfInfinity.lowerBound)
        let length = string.distance(from: rangeOfInfinity.lowerBound, to: rangeOfInfinity.upperBound)
        expect(location).to(equal(2))
        expect(length).to(equal(1))
      }
    }

    describe("matching at line anchors") {
      it("can anchor matches to the start of each line") {
        let regex = Regex("(?m)^foo")
        let multilineString = "foo\nbar\nfoo\nbaz"
        expect(regex.allMatches(in: multilineString).count).to(equal(2))
      }

      it("validates that the example in the README is correct") {
        let totallyUniqueExamples = Regex(
          "^(hello|foo).*$",
          options: [.ignoreCase, .anchorsMatchLines])
        let multilineText = "hello world\ngoodbye world\nFOOBAR\n"
        let matchingLines = totallyUniqueExamples.allMatches(in: multilineText).map { $0.matchedString }
        expect(matchingLines).to(equal(["hello world", "FOOBAR"]))
      }
    }

    describe("last match") {
      it("is available in a pattern matching context") {
        switch "hello" {
        case Regex("l+"):
          expect(Regex.lastMatch?.matchedString).to(equal("ll"))
        default:
          fail("expected regex to match")
        }
      }

      it("resets the last match to nil when a match fails") {
        _ = "foo" ~= Regex("foo")
        expect(Regex.lastMatch).notTo(beNil())
        _ = "foo" ~= Regex("bar")
        expect(Regex.lastMatch).to(beNil())
      }
    }

  }
}

private func match(_ string: String) -> NonNilMatcherFunc<Regex> {
  return NonNilMatcherFunc { actual, failureMessage throws in
    let regex: Regex! = try actual.evaluate()
    failureMessage.stringValue = "expected <\(regex)> to match <\(string)>"
    return regex.matches(string)
  }
}

private func capture(_ captures: String..., from string: String) -> NonNilMatcherFunc<Regex> {
  return NonNilMatcherFunc { actual, failureMessage throws in
    let regex: Regex! = try actual.evaluate()

    failureMessage.stringValue = "expected <\(regex)> to capture <\(captures)> from <\(string)>"

    for expected in captures {
      guard let match = regex.firstMatch(in: string), match.captures.contains(where: { $0 == expected }) else {
        return false
      }
    }

    return true
  }
}

import Quick
import Nimble
import Regex
