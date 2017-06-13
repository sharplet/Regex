final class OptionsSpec: QuickSpec {
  override func spec() {

    describe(".ignoreCase") {
      it("enables an uppercase pattern to match lowercase input") {
        let regex = Regex("FOO", options: .ignoreCase)
        expect(regex.matches("foo")).to(beTrue())
      }

      it("enables a lowercase pattern to match uppercase input") {
        let regex = Regex("foo", options: .ignoreCase)
        expect(regex.matches("FOO")).to(beTrue())
      }
    }

    describe(".ignoreMetacharacters") {
      it("treats metacharacters as literals") {
        let regex = Regex("foo(bar)", options: .ignoreMetacharacters)
        expect(regex.matches("foobar")).to(beFalse())
        expect(regex.matches("foo(bar)")).to(beTrue())
      }
    }

    describe(".anchorsMatchLines") {
      it("can anchor matches to the start of each line") {
        let regex = Regex("^foo", options: .anchorsMatchLines)
        let multilineString = "foo\nbar\nfoo\nbaz"
        expect(regex.allMatches(in: multilineString).count).to(equal(2))
      }
    }

    describe(".dotMatchesLineSeparators") {
      it("allows dot to match newlines") {
        let regex = Regex("test.test", options: .dotMatchesLineSeparators)
        let multilineString = "test\ntest"
        expect(regex.allMatches(in: multilineString).count).to(equal(1))
      }
    }

  }
}

import Quick
import Nimble
import Regex
