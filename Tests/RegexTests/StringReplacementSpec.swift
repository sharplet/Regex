final class StringReplacementSpec: QuickSpec {
  override func spec() {

    describe("replaceFirstMatching()") {
      it("replaces the first match with the given string") {
        var string = "foo"
        string.replaceFirst(matching: "o", with: "r")
        expect(string).to(equal("fro"))
      }

      it("replaces template variables with the corresponding capture group") {
        var string = "foo"
        string.replaceFirst(matching: "(oo)", with: "$1$1")
        expect(string).to(equal("foooo"))
      }
    }

    describe("replaceAllMatching()") {
      it("replaces all matches within the given string") {
        var string = "foo"
        string.replaceAll(matching: "o", with: "r")
        expect(string).to(equal("frr"))
      }

      it("replaces template variables with the corresponding capture group") {
        var string = "foo foo"
        string.replaceAll(matching: "(o)", with: "$1$1")
        expect(string).to(equal("foooo foooo"))
      }
    }

    describe("README example") {
      it("reformats a greeting") {
        let result = "hello world".replacingFirst(matching: "h(ello) (\\w+)", with: "H$1, $2!")
        expect(result).to(equal("Hello, world!"))
      }
    }

  }
}

import Quick
import Nimble
import Regex
