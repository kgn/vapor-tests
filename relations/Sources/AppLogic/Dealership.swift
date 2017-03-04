import Vapor
import Fluent

public final class Dealership: Model {
    public var id: Node?
    public var name: String
    public var exists = false

    public init(name: String) {
        self.name = name
    }

    public init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.name = try node.extract("name")
    }

    public func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": self.id,
            "name": self.name,
        ])
    }

    public static func prepare(_ database: Database) throws {
        try database.create("users") { users in
            users.id()
            users.string("name")
        }
    }

    public static func revert(_ database: Database) throws {
        try database.delete(self.entity)
    }
}

extension Dealership {
  public func cars() throws -> Children<Car> {
      return self.children()
  }
}
