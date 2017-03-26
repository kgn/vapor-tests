import Vapor
import Fluent

public class Part: Model {
    
    public var id: Node?
    public var exists = false
    
    public var name: String?    
    public var uuid: String?
    
    public init(name: String?, uuid: String?) {
        self.name = name
        self.uuid = uuid
    }
    
    public required init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
        self.name = try node.extract("name")
        self.uuid = try node.extract("uuid")
    }
    
    public func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": self.id,
            "name": self.name,
            "uuid": self.uuid
        ])
    }
    
    public static func prepare(_ database: Database) throws {
        try database.create(self.entity) { model in
            model.id()
            
            model.string("name", optional: true)
            model.string("uuid", optional: true)
        }
    }
    
    public static func revert(_ database: Database) throws {
        try database.delete(self.entity)
    }
    
}
