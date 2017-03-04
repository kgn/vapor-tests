import XCTest

import Vapor
import VaporMemory

@testable import AppLogic

class AppLogicTests: XCTestCase {

    static var allTests = [
        ("testSQL", testSQL)
    ]

    override func setUp() {
        let driver = VaporMemoryDriver()
        let database = Database(driver)
        Dealership.database = database
        Car.database = database
    }

    func testSQL() throws {
        var dealership = Dealership(name: "Jim's Cars")
        try dealership.save()

        var car1 = Car(make: "Honda", model: "Civic")
        car1.dealershipId = dealership.id
        try car1.save()

        var car2 = Car(make: "Toyota", model: "Corolla")
        car2.dealershipId = dealership.id
        try car2.save()

        let cars = try dealership.cars()
        XCTAssertEqual("\(try cars.makeQuery().sql)", "select(\"cars\", [(Car) dealership_id equals number(1)], [], [], nil)")
    }

}
