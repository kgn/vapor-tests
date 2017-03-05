import Vapor
import Fluent

public final class Dealership: BaseModel {
    public var name: String

    public init(name: String) {
        self.name = name
        super.init()
    }

    public required init(node: Node, in context: Context) throws {
        self.name = try node.extract("name")
        
        try super.init(node: node, in: context)
    }

    public override func makeNode(context: Context) throws -> Node {
        var node = try super.makeNode(context: context)

        node["name"] = self.name.makeNode()

        return node
    }

    override class func prepare(_ model: Schema.Creator) throws {
        model.string("name")

        try super.prepare(model)
    }
}

extension Dealership {
  public func cars() throws -> Children<Car> {
      return self.children()
  }
}
