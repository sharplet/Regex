import Regex
import XCTest

final class RegexTests: XCTestCase {
  func testRegexMatchesWithNoCaptureGroups() {
    let regex = Regex("now you're matching with regex")
    XCTAssertMatches(regex, "now you're matching with regex")
  }

  func testRegexMatchesSingleCaptureGroup() {
    let regex = Regex("foo (bar|baz)")
    XCTAssertCaptures(regex, captures: "bar", from: "foo bar")
  }

  func testRegexMatchesMultipleCaptureGroups() {
    let regex = Regex("foo (bar|baz) (123|456)")
    XCTAssertCaptures(regex, captures: "baz", "456", from: "foo baz 456")
  }

  func testRegexDoesNotIncludeEntireMatchInCaptureList() {
    let regex = Regex("foo (bar|baz)")
    XCTAssertDoesNotCapture(regex, captures: "foo bar", from: "foo bar")
  }

  func testRegexProvidesAccessToTheEntireMatchedString() {
    let regex = Regex("foo (bar|baz)")
    XCTAssertEqual(regex.firstMatch(in: "foo bar")?.matchedString, "foo bar")
  }

  func testRegexCanMatchMultipleTimesInTheSameString() {
    let regex = Regex("(foo)")
    let matches = regex
      .matches(in: "foo foo foo")
      .flatMap { $0.captures }
      .compactMap { $0 }

    XCTAssertEqual(matches, ["foo", "foo", "foo"])
  }

  func testRegexSupportsMatchOperator() {
    let matched: Bool

    switch "eat some food" {
    case Regex("foo"):
      matched = true
    default:
      matched = false
    }

    XCTAssertTrue(matched)
  }

  func testRegexProvidesAccessToTheMatchedRange() {
    let foobar = "foobar"
    let match = Regex("f(oo)").firstMatch(in: foobar)
    XCTAssertNotNil(match)
    XCTAssertEqual(foobar[match!.range], "foo")
  }

  func testRegexProvidesAccessToCaptureRanges() {
    let foobar = "foobar"
    let match = Regex("f(oo)b(ar)").firstMatch(in: foobar)!
    let firstCaptureRange = match.captures.range(at: 0)!
    let secondCaptureRange = match.captures.range(at: 1)!
    XCTAssertEqual(foobar[firstCaptureRange], "oo")
    XCTAssertEqual(foobar[secondCaptureRange], "ar")
  }

  func testRegexOptionatCaptureGroupsMaintainCapturePositionRegardlessOfOptionality() {
    let regex = Regex("(a)?(b)")
    XCTAssertEqual(regex.firstMatch(in: "ab")?.captures[1], "b")
    XCTAssertEqual(regex.firstMatch(in: "b")?.captures[1], "b")
  }

  func testRegexOptionatCaptureGroupsReturnNilForUnmatchedCaptures() {
    let regex = Regex("(a)?(b)")
    XCTAssertNil(regex.firstMatch(in: "b")?.captures[0])
  }

  func testRegexCaptureRangesCorrectlyConvertFromUnderlyingIndexType() {
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
    XCTAssertEqual(location, 2)
    XCTAssertEqual(length, 1)
  }

  func testValidateReadmeExampleForCaptureRanges() {
    let lyrics = """
    So it's gonna be forever
    Or it's gonna go down in flames
    """

    let possibleEndings = Regex("it's gonna (.+)")
      .matches(in: lyrics)
      .compactMap { $0.captures.range(at: 0) }
      .map { lyrics[$0] }

    XCTAssertEqual(possibleEndings, ["be forever", "go down in flames"])
  }

  func testRegexWhenMatchingAtLineAnchorsCanAnchorMatchesToTheStartOfEachLine() {
    let regex = Regex("(?m)^foo")
    let multilineString = "foo\nbar\nfoo\nbaz"
    let matches = Array(regex.matches(in: multilineString))
    XCTAssertEqual(matches.count, 2)
  }

  func testRegexWhenMatchingAtLineAnchorsValidatesReadmeExampleIsCorrect() {
    let totallyUniqueExamples = Regex(
      "^(hello|foo).*$",
      options: [.ignoreCase, .anchorsMatchLines]
    )
    let multilineText = "hello world\ngoodbye world\nFOOBAR\n"
    let matchingLines = totallyUniqueExamples.matches(in: multilineText).map { $0.matchedString }
    XCTAssertEqual(matchingLines, ["hello world", "FOOBAR"])
  }

  func testRegexLastMatchIsAvailableInPatternMatchingContext() {
    switch "hello" {
    case Regex("l+"):
      XCTAssertEqual(Regex.lastMatch?.matchedString, "ll")
    default:
      XCTFail("expected regex to match")
    }
  }

  func testRegexLastMatchResetsLastMatchToNilWhenMatchFails() {
    _ = Regex("foo") ~= "foo"
    XCTAssertNotNil(Regex.lastMatch)
    _ = Regex("bar") ~= "foo"
    XCTAssertNil(Regex.lastMatch)
  }
}
