import XCTest

import Vapor
import VaporMemory
import Turnstile

@testable import AppLogic

class AppLogicTests: XCTestCase {

    static var allTests = [
        ("testSQL", testSQL)
    ]

    override func setUp() {
        let driver = VaporMemoryDriver()
        let database = Database(driver)
        Admin.database = database
        Log.database = database
    }

    func testSQL() throws {
        let credentials = UsernamePassword(username: "test@email.com", password: "password")
        var admin = try Admin.register(credentials: credentials) as? Admin
        try admin?.save()

        var log1 = Log(method: "GET", path: "/test", duration: 0.034)
        try log1.save()

        XCTAssertEqual(
            "\(try admin?.logs().makeQuery().sql)",
            "Optional(Fluent.SQL.select(\"logs\", [(Log) admin_id equals number(1)], [], [], nil))"
        )
    }

}
