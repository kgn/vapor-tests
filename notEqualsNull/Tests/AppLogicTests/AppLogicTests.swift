import XCTest

import Vapor
import VaporMemory
import Foundation

@testable import AppLogic

class AppLogicTests: XCTestCase {

    static var allTests = [
        ("testEqualsNotNull", testEqualsNotNull)
    ]

    override func setUp() {
        let driver = VaporMemoryDriver()
        let database = Database(driver)
        Part.database = database
    }

    func testEqualsNotNull() throws {
        var part1 = Part(name: "Motherboard", uuid: UUID().uuidString)
        try part1.save()
        
        var part2 = Part(name: "Memory", uuid: nil)
        try part2.save()
        
        var part3 = Part(name: "Hard Drive", uuid: UUID().uuidString)
        try part3.save()
        
        let query = try Part.query().filter("uuid", .notEquals, Node.null)
        
        XCTAssertEqual("\(query.sql)", "select(\"parts\", [(Part) uuid notEquals null], [], [], nil)")
        
        // TEST FAILS
        XCTAssertEqual(try query.count(), 2)
    }

}
