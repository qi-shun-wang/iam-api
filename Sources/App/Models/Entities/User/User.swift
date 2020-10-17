import Foundation
import Fluent

final class User: Model {
    typealias IDValue = UUID
    
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
