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

    describe(".AnchorsMatchLines") {
      it("can anchor matches to the start of each line") {
        let regex = Regex("^foo", options: .AnchorsMatchLines)
        let multilineString = "foo\nbar\nfoo\nbaz"
        expect(regex.allMatches(multilineString).count).to(equal(2))
      }
    }

    describe(".DotMatchesLineSeparators") {
      it("allows dot to match newlines") {
        let regex = Regex("test.test", options: .DotMatchesLineSeparators)
        let multilineString = "test\ntest"
        expect(regex.allMatches(multilineString).count).to(equal(1))
      }
    }

  }
}

import Quick
import Nimble
import Regex
