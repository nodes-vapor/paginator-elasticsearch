import XCTest

import PaginatorElasticsearchTests

var tests = [XCTestCaseEntry]()
tests += PaginatorElasticsearchTests.allTests()
XCTMain(tests)