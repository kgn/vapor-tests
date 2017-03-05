import Vapor
import Fluent
import HTTP
import Auth
import Turnstile
import TurnstileCrypto

public final class Admin: BusinessModel {
    
    public var email: String!
    public var passwordHash: String!
    
    public init(email: String, rawPassword: String) throws {
        self.email = email
        self.passwordHash = BCrypt.hash(password: rawPassword)
        
        super.init()
    }
    
    public required init(node: Node, in context: Context) throws {
        self.email = try node.extract("email")
        self.passwordHash = try node.extract("password")
        
        try super.init(node: node, in: context)
    }
    
    public override func makeNode(context: Context) throws -> Node {
        var node = try super.makeNode(context: context)
        
        node["email"] = self.email.makeNode()
        node["password"] = self.passwordHash.makeNode()
        
        return node
    }
    
    override class func prepare(_ model: Schema.Creator) throws {
        model.string("email")
        model.string("password")
        
        try super.prepare(model)
    }
    
}

// MARK: - Auth

extension Admin: Auth.User {
    
    static func admin(from identifier: Identifier) throws -> Auth.User {
        guard let admin = try self.find(identifier.id) else {
            print("\(#file) \(#line): \(#function)")
            throw IncorrectCredentialsError()
        }
        return admin
    }
    
    static func admin(from accessToken: AccessToken) throws -> Auth.User {
        guard let admin = try self.query().filter("access_token", accessToken.string).first() else {
            throw IncorrectCredentialsError()
        }
        return admin
    }
    
    static func admin(from usernamePassword: UsernamePassword) throws -> Auth.User {
        guard let admin = try self.query().filter("email", usernamePassword.username).first() else {
            throw IncorrectCredentialsError()
        }
        guard try BCrypt.verify(password: usernamePassword.password, matchesHash: admin.passwordHash) else {
            throw IncorrectCredentialsError()
        }
        return admin
    }
    
    public static func authenticate(credentials: Credentials) throws -> Auth.User {
        switch credentials {
            case let identifier as Identifier: return try self.admin(from: identifier)
            case let accessToken as AccessToken: return try self.admin(from: accessToken)
            case let usernamePassword as UsernamePassword: return try self.admin(from: usernamePassword)
            default: throw UnsupportedCredentialsError()
        }
    }
    
    
    public static func register(credentials: Credentials) throws -> Auth.User {
        guard let usernamePassword = credentials as? UsernamePassword else {
            throw UnsupportedCredentialsError()
        }
        
        if try self.query().filter("email", usernamePassword.username).first() != nil {
            throw AccountTakenError()
        }
        
        return try Admin(email: usernamePassword.username, rawPassword: usernamePassword.password)
    }
    
}

extension Request {
    public func admin() throws -> Admin {
        guard let admin = try self.auth.user() as? Admin else {
            throw Abort.custom(status: .badRequest, message: "Invalid admin")
        }
        return admin
    }
}

// MARK: - Relation

extension Admin {

    func logs() throws -> Children<Log> {
        return self.children()
    }
    
}
