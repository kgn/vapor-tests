import Vapor
import Fluent

public final class Car: BaseModel {
    public var make: String
    public var model: String
    public var dealershipId: Node?

    public init(make: String, model: String) {
        self.make = make
        self.model = model
        super.init()
    }

    public required init(node: Node, in context: Context) throws {
        self.make = try node.extract("make")
        self.model = try node.extract("model")
        self.dealershipId = try node.extract("dealership_id")
        
        try super.init(node: node, in: context)
    }

    public override func makeNode(context: Context) throws -> Node {
        var node = try super.makeNode(context: context)

        node["make"] = self.make.makeNode()
        node["model"] = self.model.makeNode()
        node["dealership_id"] = self.dealershipId?.makeNode()

        return node
    }

    override class func prepare(_ model: Schema.Creator) throws {
        model.string("make")
        model.string("model")
        model.parent(Dealership.self)

        try super.prepare(model)
    }
}

extension Car {
    public func owner() throws -> Parent<Dealership> {
        return try self.parent(self.dealershipId)
    }
}
