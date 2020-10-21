import Foundation
import Fluent

final class Role: Model {
    
    static var schema: String = "roles"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "type")
    var type: String
    
    @Siblings(through: RolePolicy.self, from: \.$role, to: \.$policy)
    public var policies: [Policy]
    
    @Siblings(through: RoleUser.self, from: \.$role, to: \.$user)
    public var users: [User]
    
    init() {}
    
    init(id: Role.IDValue? = nil, type: String) {
        self.id = id
        self.type = type
    }
}
