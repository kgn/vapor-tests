import Vapor
import Fluent

public final class Car: Model {
    public var id: Node?
    public var make: String
    public var model: String
    public var dealershipId: Node?
    public var exists = false

    public init(make: String, model: String) {
        self.make = make
        self.model = model
    }

    public init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.make = try node.extract("make")
        self.model = try node.extract("model")
        self.dealershipId = try node.extract("dealership_id")
    }

    public func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": self.id,
            "make": self.make,
            "model": self.model,
            "dealership_id": self.dealershipId
        ])
    }

    public static func prepare(_ database: Database) throws {
        try database.create("users") { users in
            users.id()
            users.string("make")
            users.string("model")
            users.parent(Dealership.self)
        }
    }

    public static func revert(_ database: Database) throws {
        try database.delete(self.entity)
    }
}

extension Car {
    public func owner() throws -> Parent<Dealership> {
        return try self.parent(self.dealershipId)
    }
}
