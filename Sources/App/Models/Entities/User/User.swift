final class User: Codable {
    var id: Int?
    
    var accountID: String
    var password: String
    var accessID: String
    var accessKey: String
    
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
