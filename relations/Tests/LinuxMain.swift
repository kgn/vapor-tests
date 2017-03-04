#if os(Linux)
import XCTest

@testable import AppLogicTests

XCTMain([
    testCase(AppLogicTests.allTests)
])

#endif
