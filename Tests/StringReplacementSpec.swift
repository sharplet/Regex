final class StringReplacementSpec: QuickSpec {
  override func spec() {

    describe("replaceFirstMatching()") {
      it("replaces the first match with the given string") {
        var string = "foo"
        string.replaceFirstMatching("o", with: "r")
        expect(string).to(equal("fro"))
      }

      it("replaces template variables with the corresponding capture group") {
        var string = "foo"
        string.replaceFirstMatching("(oo)", with: "$1$1")
        expect(string).to(equal("foooo"))
      }
    }

    describe("replaceAllMatching()") {
      it("replaces all matches within the given string") {
        var string = "foo"
        string.replaceAllMatching("o", with: "r")
        expect(string).to(equal("frr"))
      }

      it("replaces template variables with the corresponding capture group") {
        var string = "foo foo"
        string.replaceAllMatching("(o)", with: "$1$1")
        expect(string).to(equal("foooo foooo"))
      }
    }

  }
}

import Quick
import Nimble
import Regex
