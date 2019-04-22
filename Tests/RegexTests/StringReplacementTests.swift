import Regex
import XCTest

final class StringReplacementTests: XCTestCase {
  func testReplaceFirstMatchingReplacesTheFirstMatchWithTheGivenString() {
    var string = "foo"
    string.replaceFirst(matching: "o", with: "r")
    XCTAssertEqual(string, "fro")
  }

  func testReplaceFirstMatchingReplacesTemplateVariablesWithTheCorrespondingCaptureGroup() {
    var string = "foo"
    string.replaceFirst(matching: "(oo)", with: "$1$1")
    XCTAssertEqual(string, "foooo")
  }

  func testReplaceAllMatchingReplacesAllMatchesWithinTheGivenString() {
    var string = "foo"
    string.replaceAll(matching: "o", with: "r")
    XCTAssertEqual(string, "frr")
  }

  func testReplaceAllMatchingReplacesTemplateVariablesWithTheCorrespondingCaptureGroup() {
    var string = "foo foo"
    string.replaceAll(matching: "(o)", with: "$1$1")
    XCTAssertEqual(string, "foooo foooo")
  }

  func testReadmeExampleReformatsAGreeting() {
    let result = "hello world".replacingFirst(matching: "h(ello) (\\w+)", with: "H$1, $2!")
    XCTAssertEqual(result, "Hello, world!")
  }

  func testReplacingWithAShorterString() {
    var string = "foo fooo foooo fooooo"
    string.replaceAll(matching: "o+", with: "")
    XCTAssertEqual(string, "f f f f")
  }
}
