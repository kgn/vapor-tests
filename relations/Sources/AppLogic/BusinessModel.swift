import Vapor
import Fluent
import Foundation

public class BusinessModel: BaseModel {
    public var isDeleted = false
    
    public init(deleted: Bool? = false) {
        self.isDeleted = deleted ?? false
        super.init()
    }
    
    public required init(node: Node, in context: Context) throws {
        self.isDeleted = try node.extract("deleted")
        
        try super.init(node: node, in: context)
    }
    
    public override func makeNode(context: Context) throws -> Node {
        var node = try super.makeNode(context: context)
        
        node["deleted"] = self.isDeleted.makeNode()
        
        return node
    }
    
    override class func prepare(_ model: Schema.Creator) throws {
        model.bool("deleted")
        
        try super.prepare(model)
    }
    
}
