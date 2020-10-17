import Fluent

final class User: Model {
    static var schema: String = "users"
    
    @ID(key:.id)
    var id: Int?
    
    @Field(key: "account_id")
    var accountID: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "access_id")
    var accessID: String
    
    @Field(key: "access_key")
    var accessKey: String
    
    init() {}
    
    init(id: Int? = nil,
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
