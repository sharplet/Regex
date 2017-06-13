import XCTest
import Quick

@testable import RegexTests

QCKMain([
    RegexSpec.self,
    OptionsSpec.self,
    StringReplacementSpec.self,
])
