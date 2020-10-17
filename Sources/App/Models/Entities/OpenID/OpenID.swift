//import Fluent

final class OpenID: Codable {
    var id: Int?
    
    var type: String
    var meta: String
    var token: String
    var userID: Int
    
    init(id: Int? = nil,
         type: String,
         meta: String,
         token: String,
         userID: Int) {
        self.id = id
        self.type = type
        self.meta = meta
        self.token = token
        self.userID = userID
    }
}
