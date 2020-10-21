import Foundation
import Fluent

final class Group: Model {
    
    static var schema: String = "groups"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Siblings(through: GroupPolicy.self, from: \.$group, to: \.$policy)
    public var policies: [Policy]
    
    @Siblings(through: GroupUser.self, from: \.$group, to: \.$user)
    public var users: [User]
    
    init() {}
    
    init(id: Group.IDValue? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
