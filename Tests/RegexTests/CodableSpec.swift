#if swift(>=3.2)
import Quick
import Nimble
import Regex
import Foundation

struct Form: Codable, Equatable {
  struct Validation: Codable, Equatable {
    var name: String
    var pattern: Regex

    static func == (lhs: Validation, rhs: Validation) -> Bool {
      return lhs.name == rhs.name
        && lhs.pattern == rhs.pattern
    }
  }

  var validations: [Validation]

  static func == (lhs: Form, rhs: Form) -> Bool {
    return lhs.validations == rhs.validations
  }
}

final class CodableSpec: QuickSpec {
  override func spec() {
    // swiftlint:disable opening_brace
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
    // swiftlint:enable opening_brace

    let form = Form(
      validations: [
        Form.Validation(name: "greeting", pattern: Regex("^(\\w+) world!$")),
      ]
    )

    it("can be decoded from json") {
      let data = json.data(using: .utf8)!
      expect { try JSONDecoder().decode(Form.self, from: data) } == form
    }

    it("can be encoded to json") {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      expect { String(data: try encoder.encode(form), encoding: .utf8)! } == json
    }

    it("is identical after encoding and decoding") {
      struct Payload: Codable { var regex: Regex }
      let original = Payload(regex: Regex("^(\\w+) world!$"))
      expect {
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Payload.self, from: encoded)
        return original.regex == decoded.regex
      } == true
    }
  }
}
#endif
