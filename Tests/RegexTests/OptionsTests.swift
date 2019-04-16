import Regex
import XCTest

final class OptionsTests: XCTestCase {
  func testIgnoreCaseEnablesAnUppercasePatternToMatchLowercaseInput() {
    let regex = Regex("FOO", options: .ignoreCase)
    XCTAssertTrue(regex.matches("foo"))
  }

  func testIgnoreCaseEnablesALowercasePatternToMatchUppercaseInput() {
    let regex = Regex("foo", options: .ignoreCase)
    XCTAssertTrue(regex.matches("FOO"))
  }

  func testIgnoreMetacharactersTreatsMetacharactersAsLiterals() {
    let regex = Regex("foo(bar)", options: .ignoreMetacharacters)
    XCTAssertFalse(regex.matches("foobar"))
    XCTAssertTrue(regex.matches("foo(bar)"))
  }

  func testAnchorsMatchLinesCanAnchorMatchesToTheStartOfEachLine() {
    let regex = Regex("^foo", options: .anchorsMatchLines)
    let multilineString = "foo\nbar\nfoo\nbaz"
    XCTAssertEqual(regex.allMatches(in: multilineString).count, 2)
  }

  func testDotMatchesLineSeparatorsAllowsDotToMatchNewlines() {
    let regex = Regex("test.test", options: .dotMatchesLineSeparators)
    let multilineString = "test\ntest"
    XCTAssertEqual(regex.allMatches(in: multilineString).count, 1)
  }

  func testAllowCommentsAndWhitespaceAllowsCommentsAndWhitespaces() {
    let regex = Regex("test test # this is a regex", options: .allowCommentsAndWhitespace)
    XCTAssertEqual(regex.allMatches(in: "testtest").count, 1)
  }
}
