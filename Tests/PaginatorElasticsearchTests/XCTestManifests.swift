import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(paginator_elasticsearchTests.allTests),
    ]
}
#endif