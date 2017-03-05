import Vapor
import Fluent
import Foundation

public class BaseModel: Model {
    
    public var id: Node?
    public var exists = false
    
    public init() { }
    
    public required init(node: Node, in context: Context) throws {
        self.id = try node.extract("id")
    }
    
    public func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": self.id
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
