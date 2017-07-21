import XCTest
import Quick

@testable import RegexTests

var specs = [
  RegexSpec.self,
  OptionsSpec.self,
  StringReplacementSpec.self,
]

#if swift(>=3.2)
specs.append(CodableSpec.self)
#endif

QCKMain(specs)
