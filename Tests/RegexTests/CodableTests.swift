import Foundation
import Regex
import XCTest

struct Form: Codable, Equatable {
  struct Validation: Codable, Equatable {
    var name: String
    var pattern: Regex
  }

  var validations: [Validation]
}

final class CodableTests: XCTestCase {
  let json = """
  {
    "validations" : [
      {
        "name" : "greeting",
        "pattern" : "^(\\\\w+) world!$"
      }
    ]
  }
  """

  let form = Form(
    validations: [
      Form.Validation(name: "greeting", pattern: Regex("^(\\w+) world!$"))
    ]
  )

  func testCanBeDecodedFromJSON() {
    let data = json.data(using: .utf8)!
    XCTAssertEqual(try JSONDecoder().decode(Form.self, from: data), form)
  }

  func testCanBeEncodedToJSON() throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    XCTAssertEqual(String(data: try encoder.encode(form), encoding: .utf8)!, json)
  }

  func testIsIdenticalAfterEncodingAndDecoding() throws {
    struct Payload: Codable { var regex: Regex }
    let original = Payload(regex: Regex("^(\\w+) world!$"))
    let encoded = try JSONEncoder().encode(original)
    let decoded = try JSONDecoder().decode(Payload.self, from: encoded)

    XCTAssertEqual(original.regex, decoded.regex)
  }
}
