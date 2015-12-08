final class OptionsSpec: QuickSpec {
  override func spec() {

    describe(".IgnoreCase") {
      it("enables an uppercase pattern to match lowercase input") {
        let regex = Regex("FOO", options: .IgnoreCase)
        expect(regex.matches("foo")).to(beTrue())
      }

      it("enables a lowercase pattern to match uppercase input") {
        let regex = Regex("foo", options: .IgnoreCase)
        expect(regex.matches("FOO")).to(beTrue())
      }
    }

    describe(".IgnoreMetacharacters") {
      it("treats metacharacters as literals") {
        let regex = Regex("foo(bar)", options: .IgnoreMetacharacters)
        expect(regex.matches("foobar")).to(beFalse())
        expect(regex.matches("foo(bar)")).to(beTrue())
      }
    }

  }
}

import Quick
import Nimble
import Regex
