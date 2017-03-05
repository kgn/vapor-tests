import Vapor
import Fluent

public final class Log: BaseModel {

    public var adminId: Node?
    
    public var method: String!
    public var path: String!
    public var duration: Double!

    public var responseCode: Int?
    public var message: String?
    public var userAgent: String?
    public var peerAddress: String?
    
    public init(method: String, path: String, duration: Double) {
        self.method = method
        self.path = path
        self.duration = duration
        super.init()
    }
    
    public required init(node: Node, in context: Context) throws {
        self.adminId = try node.extract("admin_id")
        
        self.method = try node.extract("method")
        self.path = try node.extract("path")
        self.duration = try node.extract("duration")

        self.responseCode = try node.extract("response_code")
        self.message = try node.extract("message")
        self.userAgent = try node.extract("user_agent")
        self.peerAddress = try node.extract("peer_address")
        
        try super.init(node: node, in: context)
    }
    
    public override func makeNode(context: Context) throws -> Node {
        var node = try super.makeNode(context: context)
        
        node["admin_id"] = self.adminId?.makeNode()
        
        node["method"] = self.method.makeNode()
        node["path"] = self.path.makeNode()
        node["duration"] = self.duration.makeNode()
        
        node["response_code"] = try self.responseCode?.makeNode()
        node["message"] = self.message?.makeNode()
        node["user_agent"] = self.userAgent?.makeNode()
        node["peer_address"] = self.peerAddress?.makeNode()
        
        return node
    }
    
    override class func prepare(_ model: Schema.Creator) throws {
        model.parent(Admin.self, optional: true)
        
        model.string("method")
        model.string("path")
        model.double("duration")
        
        model.int("response_code", optional: true)
        model.string("message", optional: true)
        model.string("user_agent", optional: true)
        model.string("peer_address", optional: true)
        
        try super.prepare(model)
    }
    
}

// MARK: - Relation

extension Log {
    
    func admin() throws -> Parent<Admin> {
        return try self.parent(self.adminId)
    }
    
}
