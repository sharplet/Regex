final class GrepSpec: QuickSpec {
  override func spec() {

    describe("grep()") {
      it("lazily enumerates matching lines") {
        let lines = "foo\nbar\nbaz\nquux"
        let matching = lines.grep("^ba").map { line, _ in line }
        expect(matching).to(equal(["bar", "baz"]))
      }

      it("matches empty lines") {
        let lines = "foo\n\nbar\n"
        let matching = lines.grep("^$").map { line, _ in line }
        expect(matching).to(equal([""]))
      }

      it("matches the last line even without a trailing newline") {
        let lines = "foo\nbar"
        let matching = lines.grep("bar").map { line, _ in line }
        expect(matching).to(equal(["bar"]))
      }

      it("passes the match result for accessing captures") {
        let string = "foo: 1\nbar: 2\nbaz: 3"

        let result = string
          .grep("^(\\w+): (\\d+)$")
          .map { _, match in
            match.captures[1].flatMap { Int($0) }!
          }

        expect(result).to(equal([1, 2, 3]))
      }

      it("handles CRLF as a single newline") {
        let string = "foo\r\nbar\r\n"
        let result = string.grep(".*").map { line, _ in line }
        expect(result).to(equal(["foo", "bar"]))
      }
    }

  }
}

import Quick
import Nimble
import Regex
