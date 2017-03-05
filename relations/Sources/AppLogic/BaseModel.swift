import Vapor
import Fluent

public class BaseModel: Model {
    public var id: Node?
    public var deleted = false
    public var exists = false

    public init() {}
    
    public required init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.deleted = try node.extract("deleted")
    }

    public func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": self.id,
            "deleted": self.deleted
        ])
    }

    class func prepare(_ model: Schema.Creator) throws { }

    public static func prepare(_ database: Database) throws {
        try database.create(self.entity) { model in
            model.id()

            try self.prepare(model)
        }
    }

    public static func revert(_ database: Database) throws {
        try database.delete(self.entity)
    }
}
