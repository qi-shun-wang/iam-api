import Foundation
import Fluent

final class User: Model {
    
    static var schema: String = "users"
    
    @ID(key:.id)
    var id: UUID?
    
    @Field(key: "account_id")
    var accountID: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "access_id")
    var accessID: String
    
    @Field(key: "access_key")
    var accessKey: String
    
    @Siblings(through: RoleUser.self, from: \.$user, to: \.$role)
    public var roles: [Role]
    
    @Siblings(through: GroupUser.self, from: \.$user, to: \.$group)
    public var groups: [Group]
    
    init() {}
    
    init(id: UUID? = nil,
         accountID: String,
         password: String,
         accessID: String,
         accessKey: String) {
        self.id = id
        self.accountID = accountID
        self.password = password
        self.accessID = accessID
        self.accessKey = accessKey
    }
}
