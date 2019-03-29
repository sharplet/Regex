import XCTest

extension CodableTests {
    static let __allTests = [
        ("testCanBeDecodedFromJSON", testCanBeDecodedFromJSON),
        ("testCanBeEncodedToJSON", testCanBeEncodedToJSON),
        ("testIsIdenticalAfterEncodingAndDecoding", testIsIdenticalAfterEncodingAndDecoding),
    ]
}

extension OptionsTests {
    static let __allTests = [
        ("testAnchorsMatchLinesCanAnchorMatchesToTheStartOfEachLine", testAnchorsMatchLinesCanAnchorMatchesToTheStartOfEachLine),
        ("testDotMatchesLineSeparatorsAllowsDotToMatchNewlines", testDotMatchesLineSeparatorsAllowsDotToMatchNewlines),
        ("testIgnoreCaseEnablesALowercasePatternToMatchUppercaseInput", testIgnoreCaseEnablesALowercasePatternToMatchUppercaseInput),
        ("testIgnoreCaseEnablesAnUppercasePatternToMatchLowercaseInput", testIgnoreCaseEnablesAnUppercasePatternToMatchLowercaseInput),
        ("testIgnoreMetacharactersTreatsMetacharactersAsLiterals", testIgnoreMetacharactersTreatsMetacharactersAsLiterals),
    ]
}

extension RegexTests {
    static let __allTests = [
        ("testRegexCanMatchMultipleTimesInTheSameString", testRegexCanMatchMultipleTimesInTheSameString),
        ("testRegexCaptureRangesCorrectlyConvertFromUnderlyingIndexType", testRegexCaptureRangesCorrectlyConvertFromUnderlyingIndexType),
        ("testRegexDoesNotIncludeEntireMatchInCaptureList", testRegexDoesNotIncludeEntireMatchInCaptureList),
        ("testRegexLastMatchIsAvailableInPatternMatchingContext", testRegexLastMatchIsAvailableInPatternMatchingContext),
        ("testRegexLastMatchResetsLastMatchToNilWhenMatchFails", testRegexLastMatchResetsLastMatchToNilWhenMatchFails),
        ("testRegexMatchesMultipleCaptureGroups", testRegexMatchesMultipleCaptureGroups),
        ("testRegexMatchesSingleCaptureGroup", testRegexMatchesSingleCaptureGroup),
        ("testRegexMatchesWithNoCaptureGroups", testRegexMatchesWithNoCaptureGroups),
        ("testRegexOptionatCaptureGroupsMaintainCapturePositionRegardlessOfOptionality", testRegexOptionatCaptureGroupsMaintainCapturePositionRegardlessOfOptionality),
        ("testRegexOptionatCaptureGroupsReturnNilForUnmatchedCaptures", testRegexOptionatCaptureGroupsReturnNilForUnmatchedCaptures),
        ("testRegexProvidesAccessToCaptureRanges", testRegexProvidesAccessToCaptureRanges),
        ("testRegexProvidesAccessToTheEntireMatchedString", testRegexProvidesAccessToTheEntireMatchedString),
        ("testRegexProvidesAccessToTheMatchedRange", testRegexProvidesAccessToTheMatchedRange),
        ("testRegexSupportsMatchOperator", testRegexSupportsMatchOperator),
        ("testRegexSupportsMatchOperatorInReverse", testRegexSupportsMatchOperatorInReverse),
        ("testRegexWhenMatchingAtLineAnchorsCanAnchorMatchesToTheStartOfEachLine", testRegexWhenMatchingAtLineAnchorsCanAnchorMatchesToTheStartOfEachLine),
        ("testRegexWhenMatchingAtLineAnchorsValidatesReadmeExampleIsCorrect", testRegexWhenMatchingAtLineAnchorsValidatesReadmeExampleIsCorrect),
        ("testValidateReadmeExampleForCaptureRanges", testValidateReadmeExampleForCaptureRanges),
    ]
}

extension StringReplacementTests {
    static let __allTests = [
        ("testReadmeExampleReformatsAGreeting", testReadmeExampleReformatsAGreeting),
        ("testReplaceAllMatchingReplacesAllMatchesWithinTheGivenString", testReplaceAllMatchingReplacesAllMatchesWithinTheGivenString),
        ("testReplaceAllMatchingReplacesTemplateVariablesWithTheCorrespondingCaptureGroup", testReplaceAllMatchingReplacesTemplateVariablesWithTheCorrespondingCaptureGroup),
        ("testReplaceFirstMatchingReplacesTemplateVariablesWithTheCorrespondingCaptureGroup", testReplaceFirstMatchingReplacesTemplateVariablesWithTheCorrespondingCaptureGroup),
        ("testReplaceFirstMatchingReplacesTheFirstMatchWithTheGivenString", testReplaceFirstMatchingReplacesTheFirstMatchWithTheGivenString),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CodableTests.__allTests),
        testCase(OptionsTests.__allTests),
        testCase(RegexTests.__allTests),
        testCase(StringReplacementTests.__allTests),
    ]
}
#endif
